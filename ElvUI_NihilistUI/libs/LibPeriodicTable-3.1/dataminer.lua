-- (c) 2007 Nymbia.  see LGPLv2.1.txt for full details.
--this tool is run in the lua command line.  http://lua.org
--socket is required for internet data.
--get socket here: http://luaforge.net/projects/luasocket/
--if available, bit (LuaBitOp) will be used for instance difficulty loot
--if available, curl will be used, which allows connection re-use
--if available, sqlite3 will be used for the cache database

local SOURCE = SOURCE or "data.lua"
local DEBUG = DEBUG or 9
local TRANSMOGSETS_CHKSRC = TRANSMOGSETS_CHKSRC
local INSTANCELOOT_CHKSRC = INSTANCELOOT_CHKSRC
local INSTANCELOOT_MIN = INSTANCELOOT_MIN or 50
local INSTANCELOOT_MAXSRC = INSTANCELOOT_MAXSRC or 5
local INSTANCELOOT_TRASHMINSRC = INSTANCELOOT_TRASHMINSRC or 5

local DEBUG_TRACK_URL = true

local TRANSPORT_TYPES = {
	SOCKET = 1,	--use luasocket
	CURL = 2,	--use luacurl
	CURL_SHELL = 3,	-- shell out and run the system's curl executable
}
local URL_TRANSPORT = TRANSPORT_TYPES.CURL_SHELL

local MAX_TRADESKILL_LEVEL = 800
local MAX_ITEM_LEVEL = 1000

if arg[1] == "-chksrc" and arg[2] then
	table.remove(arg, 1)
	print("Enabling deep scan for Loot table of the following tables", arg[1])
	INSTANCELOOT_CHKSRC = true
end

local function dprint(dlevel, ...)
	if dlevel and DEBUG >= dlevel then
		print(...)
		io.flush()
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    elseif type(v) == 'function' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end

local function printdiff(set, old, new)
	if DEBUG < 2 then return end
	-- we remove the drop rate for these sets in the diff
	-- because they are irrelevant to the comparison
	local has_drop_rate = set:find("InstanceLoot", nil, true)
			and not set:find("Trash Mobs", nil, true)
	local temp = {}
	local oldEntries = 0
	local newEntries = 0
	if old then
		for entry in old:gmatch("[^,]+") do
			oldEntries = oldEntries + 1
			if has_drop_rate then entry = entry:match("(%d+):%d+") end
			temp[entry] = (temp[entry] or 0) - 1
		end
	end
	if new then
		for entry in new:gmatch("[^,]+") do
			newEntries = newEntries + 1
			if has_drop_rate then entry = entry:match("(%d+):%d+") end
			temp[entry] = (temp[entry] or 0) + 1
		end
	end
	local added, removed = {}, {}
	for entry, value in pairs(temp) do
		if value > 0 then
			added[#added + 1] = entry
		elseif value < 0 then
			removed[#removed + 1] = entry
		end
	end
	if #added + #removed > 0 then
		dprint(2, "CHANGED", set, "("..oldEntries.." -> "..newEntries..")")
	end

	if #removed > 0 then
		table.sort(removed, sortSet_id)
		dprint(2, "REMOVED", table.concat(removed, ","))
	end
	if #added > 0 then
		table.sort(added, sortSet_id)
		dprint(2, "ADDED", table.concat(added, ","))
	end
end

local sets

local json = require("json")
json.register_constant("undefined", json.null)
local socket_url = require("socket.url")
local httptime, httpcount = 0, 0

local WOWHEAD_FILTER_PARAMS = { "na", "ma", "minle", "maxle", "minrl", "maxrl", "minrs", "maxrs", "qu", "sl", "cr", "crs", "crv", "type" }

local function WH2(page, p_name, p_tag, filter)
	local escape = socket_url.escape
	local url = {"https://www.wowhead.com/", page}
	if p_name then
		url[#url + 1] = "/name:"
		url[#url + 1] = escape(p_name)
	end
	if p_tag then
		url[#url + 1] = "/tag:"
		url[#url + 1] = escape(p_tag)
	end

	if filter then
		url[#url + 1] = "&filter="
		if type(filter) == "table" then
			local first = true
			for _, k in ipairs(WOWHEAD_FILTER_PARAMS) do
				local v = filter[k]
				if v then
					if not first then
						url[#url + 1] = ";"
					else
						first = false
					end
					url[#url + 1] = escape(k)
					url[#url + 1] = "="
					if type(v) == "table" then
						for i, s in ipairs(v) do
							if i > 1 then url[#url + 1] = ":" end
							url[#url + 1] = escape(s)
						end
					else
						url[#url + 1] = escape(v)
					end
				end
			end
		else
			-- we don't escape if filter is a string
			url[#url + 1] = filter
		end
	end
	return table.concat(url)
end

local function WH(page, value, filter)
	local escape = socket_url.escape
	local url = {"https://www.wowhead.com/", page}
	if value then
		url[#url + 1] = "="
		url[#url + 1] = escape(value)
	end
	if filter then
		url[#url + 1] = "&filter="
		if type(filter) == "table" then
			local first = true
			for _, k in ipairs(WOWHEAD_FILTER_PARAMS) do
				local v = filter[k]
				if v then
					if not first then
						url[#url + 1] = ";"
					else
						first = false
					end
					url[#url + 1] = escape(k)
					url[#url + 1] = "="
					if type(v) == "table" then
						for i, s in ipairs(v) do
							if i > 1 then url[#url + 1] = ":" end
							url[#url + 1] = escape(s)
						end
					else
						url[#url + 1] = escape(v)
					end
				end
			end
		else
			-- we don't escape if filter is a string
			url[#url + 1] = filter
		end
	end
	return table.concat(url)
end

local getpage
do
	if(URL_TRANSPORT == TRANSPORT_TYPES.CURL) then
		local curl_status, curl = pcall(require, "luacurl")
		if (not curl_status) then
			print("TRANSPORT_TYPES.CURL requested, but library not found")
			os.exit()
		else
			local write = function (temp, s)
				temp[#temp + 1] = s
				return s:len()
			end
			local c = curl.new()
			function getpage(url)
				if DEBUG_TRACK_URL then dprint(1, "curl", url); end;
				local temp = {}
				c:setopt(curl.OPT_URL, url)
				c:setopt(curl.OPT_USERAGENT, "Mozilla/5.0") -- needed or item information will be missing
				c:setopt(curl.OPT_WRITEFUNCTION, write)
				c:setopt(curl.OPT_WRITEDATA, temp)
				c:setopt(curl.OPT_FOLLOWLOCATION, true)
				local stime = os.time()
				local status, info = c:perform()
				httptime = httptime + (os.time() - stime)
				httpcount = httpcount + 1
				if not status then
					dprint(1, "curl error", url, info)
				else
					temp = table.concat(temp)
					if temp:len() > 0 then
						return temp
					end
				end
			end
		end
	elseif(URL_TRANSPORT == TRANSPORT_TYPES.SOCKET) then
		local http = require("socket.http")

		function getpage(url)
			if DEBUG_TRACK_URL then dprint(1, "socket.http", url); end;
			local stime = os.time()
			local r = http.request(url)
			httptime = httptime + (os.time() - stime)
			httpcount = httpcount + 1
			return r
		end
	elseif(URL_TRANSPORT == TRANSPORT_TYPES.CURL_SHELL) then
		function getpage(p_url)
			if DEBUG_TRACK_URL then dprint(1, "curl shell", p_url); end;
			local start_time = os.time()
			local shell_command = 'curl --silent --show-error --user-agent "Mozilla/5.0" --insecure --location "' .. p_url .. '"'
--print(shell_command)
			local file = assert(io.popen(shell_command, 'r'))
			local output = file:read('*all')
			file:close()
			httptime = httptime + (os.time() - start_time)
			httpcount = httpcount + 1
			return output
		end

	end
end




if not NOCACHE then
	local real_getpage = getpage
	local status, sqlite = pcall(require, "lsqlite3")
	if status then
		db = sqlite.open("wowhead.db")
		db:exec([[
CREATE TABLE IF NOT EXISTS cache (
	url TEXT,
	content BLOB,
	time TEXT,
	PRIMARY KEY (url)
)]])
		local CACHE_TIMEOUT = CACHE_TIMEOUT or "+7 day"
		local select_stmt = db:prepare("SELECT content FROM cache WHERE url = ? AND datetime(time, '"..CACHE_TIMEOUT.."') > datetime('now')")
		local insert_stmt = db:prepare("INSERT OR REPLACE INTO cache VALUES (?, ?, CURRENT_TIMESTAMP)")
		getpage = function (url)
			select_stmt:bind_values(url)
			local result = select_stmt:step()
			dprint(4, "cache", url, result == sqlite3.ROW and "hit" or "miss")
			if result == sqlite3.ROW then
				result = select_stmt:get_value(0)
				select_stmt:reset()
				return result
			else
				select_stmt:reset()
			end
			local content = real_getpage(url)
			if content then
				insert_stmt:bind_values(url, content)
				insert_stmt:step()
				insert_stmt:reset()
			end
			return content
		end
	else
		local page_cache = {}
		getpage = function (url)
			local page = page_cache[url]
			if not page then
				page = real_getpage(url)
				page_cache[url] = page
			end
			return page
		end
	end
end

local function read_data_file()
	local subset = string.gsub(arg[1] or '','%.','%.')
	local f = assert(io.open(SOURCE, "r"))
	local file = f:read("*all")
	f:close()

	local sets = {}
	local setcount = 0
	for set, data in file:gmatch('\t%[%"('..subset..'[^"]*)%"%][^=]-= "([^"]-)"') do
		sets[set] = data
		setcount = setcount + 1
	end
	-- when scanning loot also offer heroic/lfr versions
	if (arg[1] or ''):match("^InstanceLoot%.") then
		for set, data in file:gmatch('\t%[%"('..(string.gsub(subset, "^InstanceLoot", "InstanceLootHeroic"))..'[^"]*)%"%][^=]-= "([^"]-)"') do
			sets[set] = data
			setcount = setcount + 1
		end
		for set, data in file:gmatch('\t%[%"('..(string.gsub(subset, "^InstanceLoot", "InstanceLootLFR"))..'[^"]*)%"%][^=]-= "([^"]-)"') do
			sets[set] = data
			setcount = setcount + 1
		end
	end

	return file, sets, setcount
end

local handlers = {}
--[=[ HELPER FUNCTIONS

Use the helper functions whenever possible.

Doing "for itemid, content in page:gmatch("_%[(%d+)%]=(%b[])") do ... end" is deprecated, because it will match
any item that has a tooltip in the current page. It could be currency, or reagents, or anything else, not just what
you're looking for. Right now, the only exception is the "Bandage" Data, because the tooltip content is analysed.

Use WH() to create url to wowhead. This will allow a single place to modify in case wowhead changes it's url format again.

url = WH(type[, value[, filter]])

Parameters:
_ type is the basic query type ("items", "item", "spell", ...)
_ value is the optional base value of the request (for instance WH("spell", 12345) will return the URL for the spell 12345
_ filter is the optional filtering data. It can either be a table or a string. The string is added as-is in the url, the table
  is analysed and transformed into a string using the format required by wowhead. USE the table format if possible.

The function returns the url for the query.

list = basic_listview_handler(url[, handler[, names[, inplace_list]]])

basic_listview_handler is a function that should be used as much as possible.

Parameters:
_ url is the url to to fetch data from.
_ handler is the (optional) entry handler. See below.
_ names is the optional name of the listview, in case the url returns several lists. Can be a string or a table.
  if not given, the first table will be used.
_ inplace_list is an optional array that will be filled with the result of handlers, instead of a new one.
  If inplace_list is given, then basic_listview_handler() return value should be discarded.
  No sorting and string concat is performed if inplace_list is not nil.

_ list is the resulting periodic table.

the handler should be of the form :
result = handler(data)

_ data is on entry in the listview, as a lua array.
_ result should be the entry in the periodic table, or nil if the entry is not correct.
  result will be converted to string after handler.

The default handler will return the id of the data.

id = basic_listview_get_first_id(url)

this function return the first "id" of the first entry in the first listview of the given url.
Used when searching for mobs or containers by name.

multiple_qualities_listview_handler is used to split a search between several qualities and level restrictions
when the amount of elements returned by a simple search is too important.

]=]

local REJECTED_TEMPLATES = {
	comment = true,
	screenshot = true,
	mission = true,
	video = true,
	guide = true,
}
local function get_page_listviews(url)
	local page = assert(getpage(url))
	local views = {}
	for view in page:gmatch("new Listview(%b())") do
		local template = view:match("template: ?'(.-)'[,}]")
		if not REJECTED_TEMPLATES[template] then
			local id = view:match("id: ?'(.-)'[,}]")
			local data = view:match("data: ?(%b[])[,}]")
			if data then
				-- for droprate support
				local count = view:match("_totalCount: ?(%d+)[,}]")
				views[id] = {id = id, data = json(data, true), count = count and tonumber(count)}
			else
				data = view:match("data: ?(%w+)[,}]")
				if data then
					data = page:match("var "..data.." = (%b[])")
					if data then
						views[id] = {id = id, data = json(data, true)}
					end
				end
			end
		end
	end
	return views
end

local locale_data
local function fetch_locale_data()
	if not locale_data then
		local page = assert(getpage("https://static.wowhead.com/js/locale_enus.js"))
		locale_data = json(page:match("g_zones%s*=%s*(%b{})"), true)
	end
end
local function get_zone_name_from_id(id)
	fetch_locale_data()
	return locale_data[tonumber(id)]
end
local function get_zone_id_from_name(name)
	fetch_locale_data()
	for id,zone in pairs(locale_data) do
		if zone == name then
			return id
		end
	end
end

-- Used to sort tables with values [-id|id][:value] using value as primary sort data
local function sortSet(a, b)
	local aId, aValue = a:match("(%-?%d+):(%-?%d+)")
	local bId, bValue = b:match("(%-?%d+):(%-?%d+)")
	if (not aId) then
		aId = a
	else
		aValue = tonumber(aValue)
	end
	if (not bId) then
		bId = b
	else
		bValue = tonumber(bValue)
	end
	aId = tonumber(aId)
	bId = tonumber(bId)

	if (aValue and bValue) then
		if (aValue == bValue) then
			return aId < bId
		else
			return aValue < bValue
		end
	elseif (aValue) then
		return false
	elseif (bValue) then
		return true
	else
		return aId < bId
	end
end

-- Used to sort tables with values [-id|id][:value] using id as primary sort data
local function sortSet_id(a, b)
	local aId, aValue = a:match("(%-?%d+):")
	local bId, bValue = b:match("(%-?%d+):")
	if (not aId) then
		aId = a
	end
	if (not bId) then
		bId = b
	end
	aId = tonumber(aId)
	bId = tonumber(bId)

	return aId < bId
end

local function basic_itemid_handler(item)
	return item.id
end

local function basic_listview_handler(url, handler, names, inplace_set)
	if not handler then handler = basic_itemid_handler end
	local newset = inplace_set or {}
	if type(names) == "string" then
		names = {[names] = true}
	end
	local views = get_page_listviews(url)
	for name, view in pairs(views) do
		if not names or names[name] then
			if #(view.data) == 200 then
				print("*WARNING* "..url.." possibly returns more than 200 entries")
			end
			for _, item in ipairs(view.data) do
				local s = handler(item)
				if s then
					newset[#newset + 1] = tostring(s)
				end
			end
		end
		if not names then break end
	end
	local itemcount = #newset
	if DEBUG_TRACK_URL then dprint(3, "BasicListViewHandler", itemcount, url); end;
	if not inplace_set then
		table.sort(newset, sortSet)
		return table.concat(newset, ",")
	end
end

local function basic_listview_get_first_id(url)
	local views = get_page_listviews(url)
	if not views then return end
	local _, view = next(views)
	if not view then return end
	local _, item = next(view.data)
	if not item then return end
	return item.id
end

local function is_in(table, value)
	for _, v in pairs(table) do
		if v == value then return true end
	end
end

local function basic_listview_get_npc_id(npc, zone)
	-- override because of a bug in wowhead where the mob is not reported as lootable.
	if npc == "Sathrovarr the Corruptor" then return 24892 end
	if npc == "Electron" then return 42179 end
	-- override because "," in names screws things up
	if npc == "Corla Herald of Twilight" then return 39679 end
	-- override because NPC name exists multiple times
	if npc == "Kael'thas Sunstrider" and zone == "Magisters' Terrace" then return 24664 end
	local url = WH("npcs", nil, {na = npc, cr={32,9}, crs={1,1}, crv={0,0}, ma=1})
	local views = get_page_listviews(url)
	if not views.npcs then return end
	local data = views.npcs.data
	if zone then zone = get_zone_id_from_name(zone) end
	local first_id
	for _, entry in ipairs(data) do
		if entry.name == npc and (not zone or not entry.location or is_in(entry.location, zone)) then
			return entry.id
		end
		if not first_id then first_id = entry.id end
	end
	return first_id
end

local function basic_listview_get_id_by_name(url, name)
	local views = get_page_listviews(url)
	if not views then return end
	local _, view = next(views)
	if not view then return end

	for _, entry in ipairs(view.data) do
		if entry.name == name then
			return entry.id
		end
		-- fallback to first id
		if not first_id then first_id = entry.id end
	end
	return first_id
end

local function multiple_qualities_listview_handler(type, value, filter, set, typelevel, level_step_size)
	local min, max = "min"..typelevel, "max"..typelevel
	level_step_size = level_step_size or 30
	for q = 0, 7 do
		filter.qu = q
		if q == 1 then
			-- we split here because there's a lot of them
			for level = 0, MAX_ITEM_LEVEL, level_step_size do
				filter[min] = level
				filter[max] = level + (level_step_size - 1)
				basic_listview_handler(WH(type, value, filter), nil, nil, set)
			end
			filter[min] = nil
			filter[max] = nil
		else
			basic_listview_handler(WH(type, value, filter), nil, nil, set)
		end
	end
end

--[[ STATIC DATA ]]

local Class_Skills_categories = {
	["Death Knight"] = {
		General = "7.6",
		Talent = "-2.6",
		Blood = "-12.6.250",
		Frost = "-12.6.251",
		Unholy = "-12.6.252",
	},
	Druid = {
		General = "7.11",
		Talent = "-2.11",
		Balance = "-12.11.102",
		Feral = "-12.11.103",
		Guardian = "-12.11.104",
		Restoration = "-12.11.105",
	},
	Hunter = {
		General = "7.3",
		Talent = "-2.3",
		["Beast Mastery"] = "-12.3.253",
		Marksmanship = "-12.3.254",
		Survival = "-12.3.255",
	},
	Mage = {
		General = "7.8",
		Talent = "-2.8",
		Arcane = "-12.8.62",
		Fire = "-12.8.63",
		Frost = "-12.8.64",
	},
	Monk = {
		General = "7.10",
		Talent = "-2.10",
		Brewmaster = "-12.10.268",
		Windwalker = "-12.10.269",
		Mistweaver = "-12.10.270",
	},
	Paladin = {
		General = "7.2",
		Talent = "-2.2",
		Holy = "-12.2.65",
		Protection = "-12.2.73",
		Retribution = "-12.2.70",
	},
	Priest = {
		General = "7.5",
		Talent = "-2.5",
		Discipline = "-12.5.256",
		Holy = "-12.5.257",
		Shadow = "-12.5.258",
	},
	Rogue = {
		General = "7.4",
		Talent = "-2.4",
		Assassination = "-12.4.259",
		Combat = "-12.4.260",
		Subtlety = "-12.4.261",
	},
	Shaman = {
		General = "7.7",
		Talent = "-2.7",
		Elemental = "-12.7.262",
		Enhancement = "-12.7.263",
		Restoration = "-12.7.264",
	},
	Warlock = {
		General = "7.9",
		Talent = "-2.9",
		Affliction = "-12.9.265",
		Demonology = "-12.9.266",
		Destruction = "-12.9.267",
	},
	Warrior = {
		General = "7.1",
		Talent = "-2.1",
		Arms = "-12.1.71",
		Fury = "-12.1.72",
		Protection = "-12.1.73",
	},
}

local Tradeskill_Gather_filter_values = {
	Disenchant = 68,
	Fishing = 69,
	Herbalism = 70,
	Milling = 143,
	Mining = 73,
	Pickpocketing = 75,
	Skinning = 76,
	Prospecting = 88,
}

local Tradeskill_Tool_filters = {
	Alchemy = {
		{cr=91,crs=12,crv=0}, -- Tool - Philosopher's Stone
	},
	Blacksmithing = {
		{cr=91,crs=162,crv=0},-- Tool - Blacksmith Hammer
		{cr=91,crs=161,crv=0},-- Tool - Gnomish Army Knife
		{cr=91,crs=167,crv=0},-- Tool - Hammer Pick
	},
	--[[ [ckaotik] deprecated
	Cooking = {
		{cr=91,crs=169,crv=0},-- Tool - Flint and Tinder
		{cr=91,crs=161,crv=0},-- Tool - Gnomish Army Knife
	},]]--
	Enchanting = {
		{cr=91,crs=62,crv=0}, -- Tool - Runed Adamantite Rod
		{cr=91,crs=10,crv=0}, -- Tool - Runed Arcanite Rod
		{cr=91,crs=101,crv=0},-- Tool - Runed Azurite Rod
		{cr=91,crs=6,crv=0},  -- Tool - Runed Copper Rod
		{cr=91,crs=63,crv=0}, -- Tool - Runed Eternium Rod
		{cr=91,crs=41,crv=0}, -- Tool - Runed Fel Iron Rod
		{cr=91,crs=8,crv=0},  -- Tool - Runed Golden Rod
		{cr=91,crs=7,crv=0},  -- Tool - Runed Silver Rod
		{cr=91,crs=190,crv=0},-- Tool - Runed Titanium Rod [ckaotik]
		{cr=91,crs=9,crv=0},  -- Tool - Runed Truesilver Rod
	},
	Engineering = {
		{cr=91,crs=14,crv=0}, -- Tool - Arclight Spanner
		{cr=91,crs=162,crv=0},-- Tool - Blacksmith Hammer
		{cr=91,crs=161,crv=0},-- Tool - Gnomish Army Knife
		{cr=91,crs=15,crv=0}, -- Tool - Gyromatic Micro-Adjustor
	},
	Inscription = {
		--{cr=91,crs=81,crv=0}, -- Tool - Hollow Quill
		{cr=91,crs=121,crv=0},-- Tool - Scribe Tools
		{na="draenic mortar"},-- Tool - Draenic Mortar
	},
--	Jewelcrafting = { -- TODO: missing on wowhead 10/12/20
	-- Tool - Jeweler's Kit still missing as of 12/06/04
--	},
	Mining = {
		{cr=91,crs=168,crv=0},-- Tool - Bladed Pickaxe
		{cr=91,crs=161,crv=0},-- Tool - Gnomish Army Knife
		{cr=91,crs=167,crv=0},-- Tool - Hammer Pick
		{cr=91,crs=165,crv=0},-- Tool - Mining Pick
	},
	Skinning = {
		{cr=91,crs=168,crv=0},-- Tool - Bladed Pickaxe
		{cr=91,crs=161,crv=0},-- Tool - Gnomish Army Knife
		{cr=91,crs=166,crv=0},-- Tool - Skinning Knife
	},
}

local Containers_ItemsInType_items = {
	Cooking = 92748, -- Portable Refrigerator
	Herb = 67393, -- "Carriage - Going Green" Herb Tote Bag
	Enchanting = 67389, -- "Carriage - Exclusive" Enchanting Evening Purse
	Engineering = 67390, -- "Carriage - Maddy" High Tech Bag
	Gem = 67392, -- "Carriage - Exclusive" Gem Studded Clutch
	Inscription = 67394, -- "Carriage - Xandera" Student's Satchel
	Leatherworking = 67395, -- "Carriage - Meeya" Leather Bag
	Mining = 67396, -- "Carriage - Christina" Precious Metal Bag
	Tackle = 60218, -- Lure Master Tackle Box
}

local Bag_categories = {
	Basic = "1.0",
	Cooking = "1.10",
	Herb = "1.2",
	Enchanting = "1.3",
	Engineering = "1.4",
	Gem = "1.5",
	Mining = "1.6",
	Leatherworking = "1.7",
	Inscription = "1.8",
	Tackle = "1.9",
}

local Minipet_filters = {
	Achievement = {cr=172,crs=1,crv=0},
	Quest = {cr=18,crs=1,crv=0},
	Drop = {cr=128,crs=4,crv=0},
	Crafted = {cr=86,crs=11,crv=0},
	Vendor = {cr=92,crs=1,crv=0},
	Other = {cr={128,128,128},crs={5,8,2},crv={0,0,0},ma=1}, -- the bad & the ugly
}

local Mount_filter_categories = {
	Normal = "15.5.1",
	Flying = "15.5.2",
	Aquatic = "15.5.3",
}

local Tradeskill_Recipe_categories = {
	Leatherworking = "9.1",
	Tailoring = "9.2",
	Engineering = "9.3",
	Blacksmithing = "9.4",
	Cooking = "9.5",
	Alchemy = "9.6",
	["First Aid"] = "9.7",
	Enchanting = "9.8",
	Fishing = "9.9",
	Jewelcrafting = "9.10",
	Inscription = "9.11",
	Mining = "9.12",
}

local Tradeskill_Recipe_filters = {
	Quest = {cr=18,crs=1,crv=0},
	Drop = {cr=72,crs=1,crv=0},
	Crafted = {cr=86,crs=11,crv=0},
	Vendor = {cr=92,crs=1,crv=0},
	Other = {cr={18,72,86,92},crs={5,2,12,2},crv={0,0,0,0}},
}

local Tradeskill_Gather_GemsInNodes_nodes = {
	["Copper Vein"] = 1731,
	["Incendicite Mineral Vein"] = 1610,
	["Tin Vein"] = 1732,
	["Lesser Bloodstone Deposit"] = 2653,
	["Ooze Covered Silver Vein"] = 73940,
	["Silver Vein"] = 1733,
	["Iron Deposit"] = 1735,
	["Indurium Mineral Vein"] = 19903,
	["Gold Vein"] = 1734,
	["Ooze Covered Gold Vein"] = 73941,
	["Mithril Deposit"] = 2040,
	["Ooze Covered Mithril Deposit"] = 123310,
	["Ooze Covered Truesilver Deposit"] = 123309,
	["Truesilver Deposit"] = 2047,
	["Dark Iron Deposit"] = 165658,
	["Ooze Covered Thorium Vein"] = 123848,
	["Small Thorium Vein"] = 324,
	["Ooze Covered Rich Thorium Vein"] = 177388,
	["Rich Thorium Vein"] = 175404,
	["Fel Iron Deposit"] = 181555,
	["Nethercite Deposit"] = 185877,
	["Large Obsidian Chunk"] = 181069,
	["Small Obsidian Chunk"] = 181068,
	["Adamantite Deposit"] = 181556,
	["Cobalt Deposit"] = 189978,
	["Rich Adamantite Deposit"] = 181569,
	["Ancient Gem Vein"] = 185557,
	["Khorium Vein"] = 181557,
	["Rich Cobalt Deposit"] = 189979,
	["Saronite Deposit"] = 189980,
	["Obsidium Deposit"] = 202736,
	["Rich Saronite Deposit"] = 189981,
	["Pure Saronite Deposit"] = 195036,
	["Rich Obsidium Deposit"] = 202739,
	["Titanium Vein"] = 191133,
	["Elementium Vein"] = 202738,
	["Rich Elementium Vein"] = 202741,
	["Pyrite Deposit"] = 202737,
	["Rich Pyrite Deposit"] = 202740,
	["Ghost Iron Deposit"] = 209311,
	["Rich Ghost Iron Deposit"] = 209328,
	["Kyparite Deposit"] = 209312,
	["Rich Kyparite Deposit"] = 209329,
	["Trillium Vein"] = 209313,
	["Rich Trillium Vein"] = 209330,
}

local Tradeskill_Profession_filters = {
	["Engineering.Basic"] = {cr=5,crs=2,crv=0},
}

local Tradeskill_Profession_categories = {
	Alchemy = "11.171",
	Blacksmithing = "11.164",
	["Cooking.Basic"] = "9.185",
	["Cooking.Way of the Brew"] = "9.980",
	["Cooking.Way of the Grill"] = "9.975",
	["Cooking.Way of the Oven"] = "9.979",
	["Cooking.Way of the Pot"] = "9.977",
	["Cooking.Way of the Steamer"] = "9.978",
	["Cooking.Way of the Wok"] = "9.976",
	Enchanting = "11.333",
	["Engineering.Basic"] = "11.202",
	["Engineering.Gnomish"] = "11.202.20219",
	["Engineering.Goblin"] = "11.202.20222",
	["First Aid"] = "9.129",
	Inscription = "11.773",
	Jewelcrafting = "11.755",
	Leatherworking = "11.165",
	Smelting = "11.186",
	Tailoring = "11.197",
}

local Gear_Socketed_filters = {
	Back	= {
		{sl=16,cr=80,crs=7,crv=0},
	},
	Chest	= {
		{sl=5,cr=80,crs=7,crv=0,qu={0,1,2,3}},
		{sl=5,cr=80,crs=7,crv=0,qu={4,5,6,7}},
	},
	Feet	= {
		{sl=8,cr=80,crs=7,crv=0},
	},
	Finger	= {
		{sl=11,cr=80,crs=7,crv=0},
	},
	Hands	= {
		{sl=10,cr=80,crs=7,crv=0},
	},
	Head	= {
		{sl=1,cr=80,crs=7,crv=0,qu={0,1,2,3}},
		{sl=1,cr=80,crs=7,crv=0,qu={4,5,6,7}},
	},
	Legs	= {
		{sl=7,cr=80,crs=7,crv=0},
	},
	["Main Hand"]	= {
		{sl=21,cr=80,crs=7,crv=0},
	},
	Neck	= {
		{sl=2,cr=80,crs=7,crv=0},
	},
	["Off Hand"]	= {
		{sl=22,cr=80,crs=7,crv=0},
	},
	["One Hand"]	= {
		{sl=13,cr=80,crs=7,crv=0},
	},
	Ranged	= {
		{sl=15,cr=80,crs=7,crv=0},
	},
	Shield	= {
		{sl=14,cr=80,crs=7,crv=0},
	},
	Shoulder	= {
		{sl=3,cr=80,crs=7,crv=0,qu={0,1,2,3}},
		{sl=3,cr=80,crs=7,crv=0,qu={4,5,6,7}},
	},
	Trinket	= {
		{sl=12,cr=80,crs=7,crv=0},
	},
	["Two Hand"]	= {
		{sl=17,cr=80,crs=7,crv=0},
	},
	Waist	= {
		{sl=6,cr=80,crs=7,crv=0},
	},
	Wrist	= {
		{sl=9,cr=80,crs=7,crv=0},
	},
}

local Gear_level_filters = {
	{maxrl=59},
	{minrl=60,maxrl=60},
	{minrl=61,maxrl=69},
	{minrl=70,maxrl=70},
	{minrl=71,maxrl=79},
	{minrl=80,maxrl=80},
	{minrl=81,maxrl=84},
	{minrl=85,maxrl=89},
	{minrl=90,maxrl=90},
}

local GearSets_tags = {
	["Tier 2"] = 4


}

local GearSets_fixedids = {

--Crafted. The miner chooses the wrong thing so we hardcode it
	["The Unyielding"] = 570,
	
	["The Gladiator"] = 1,

	["Battlegear of Undead Slaying"] = 533,
	["Blessed Battlegear of Undead Slaying"] = 784,
	["Conqueror's Battlegear"] = 496,
	["Garb of the Undead Slayer"] = 535,
	["Blessed Garb of the Undead Slayer"] = 783,
	["Regalia of Undead Cleansing"] = 536,
	["Blessed Regalia of Undead Cleansing"] = 781,
	["Undead Slayer's Armor"] = 534,
	["Undead Slayer's Blessed Armor"] = 782,

-- Arena Season 1
	["Gladiator's Aegis"] = 582,
	["Gladiator's Battlegear"] = 567,
	["Gladiator's Dreadgear"] = 568,
	["Gladiator's Earthshaker"] = 578,
	["Gladiator's Felshroud"] = 615,
	["Gladiator's Investiture"] = 687,
	["Gladiator's Pursuit"] = 586,
	["Gladiator's Raiment"] = 581,
	["Gladiator's Redemption"] = 690,
	["Gladiator's Refuge"] = 685,
	["Gladiator's Regalia"] = 579,
	["Gladiator's Sanctuary"] = 584,
	["Gladiator's Thunderfist"] = 580,
	["Gladiator's Vestments"] = 577,
	["Gladiator's Vindication"] = 583,
	["Gladiator's Wartide"] = 686,
	["Gladiator's Wildhide"] = 585,

-- T6
	["Tempest Regalia"] = 671,
	["Slayer's Armor"] = 668,

-- T9
	["Conqueror's Garona's Battlegear"] = -816,
	["Conqueror's Gul'dan's Regalia"] = -803,
	["Conqueror's Hellscream's Battlegear"] = -826,
	["Conqueror's Hellscream's Plate"] = -828,
	["Conqueror's Kel'Thuzad's Regalia"] = -804,
	["Conqueror's Khadgar's Regalia"] = -801,
	["Conqueror's Koltira's Battlegear"] = -830,
	["Conqueror's Koltira's Plate"] = -832,
	["Conqueror's Liadrin's Battlegear"] = -836,
	["Conqueror's Liadrin's Garb"] = -834,
	["Conqueror's Liadrin's Plate"] = -838,
	["Conqueror's Malfurion's Battlegear"] = -813,
	["Conqueror's Malfurion's Garb"] = -809,
	["Conqueror's Malfurion's Regalia"] = -811,
	["Conqueror's Nobundo's Battlegear"] = -823,
	["Conqueror's Nobundo's Garb"] = -819,
	["Conqueror's Nobundo's Regalia"] = -822,
	["Conqueror's Runetotem's Battlegear"] = -814,
	["Conqueror's Runetotem's Garb"] = -810,
	["Conqueror's Runetotem's Regalia"] = -812,
	["Conqueror's Sunstrider's Regalia"] = -802,
	["Conqueror's Thassarian's Battlegear"] = -829,
	["Conqueror's Thassarian's Plate"] = -831,
	["Conqueror's Thrall's Battlegear"] = -824,
	["Conqueror's Thrall's Garb"] = -820,
	["Conqueror's Thrall's Regalia"] = -821,
	["Conqueror's Turalyon's Battlegear"] = -835,
	["Conqueror's Turalyon's Garb"] = -833,
	["Conqueror's Turalyon's Plate"] = -837,
	["Conqueror's VanCleef's Battlegear"] = -815,
	["Conqueror's Velen's Raiment"] = -805,
	["Conqueror's Velen's Regalia"] = -807,
	["Conqueror's Windrunner's Battlegear"] = -817,
	["Conqueror's Windrunner's Pursuit"] = -818,
	["Conqueror's Wrynn's Battlegear"] = -825,
	["Conqueror's Wrynn's Plate"] = -827,
	["Conqueror's Zabra's Raiment"] = -806,
	["Conqueror's Zabra's Regalia"] = -808,
	["Triumphant Garona's Battlegear"] = {["245"] = -151, ["258"] = -189},
	["Triumphant Gul'dan's Regalia"] = {["245"] = -138, ["258"] = -176},
	["Triumphant Hellscream's Battlegear"] = {["245"] = -161, ["258"] = -199},
	["Triumphant Hellscream's Plate"] = {["245"] = -163, ["258"] = -201},
	["Triumphant Kel'Thuzad's Regalia"] = {["245"] = -139, ["258"] = -177},
	["Triumphant Khadgar's Regalia"] = {["245"] = -136, ["258"] = -174},
	["Triumphant Koltira's Battlegear"] = {["245"] = -165, ["258"] = -203},
	["Triumphant Koltira's Plate"] = {["245"] = -167, ["258"] = -205},
	["Triumphant Liadrin's Battlegear"] = {["245"] = -171, ["258"] = -209},
	["Triumphant Liadrin's Garb"] = {["245"] = -169, ["258"] = -207},
	["Triumphant Liadrin's Plate"] = {["245"] = -173, ["258"] = -211},
	["Triumphant Malfurion's Battlegear"] = {["245"] = -148, ["258"] = -186},
	["Triumphant Malfurion's Garb"] = {["245"] = -144, ["258"] = -182},
	["Triumphant Malfurion's Regalia"] = {["245"] = -146, ["258"] = -184},
	["Triumphant Nobundo's Battlegear"] = {["245"] = -158, ["258"] = -196},
	["Triumphant Nobundo's Garb"] = {["245"] = -154, ["258"] = -192},
	["Triumphant Nobundo's Regalia"] = {["245"] = -157, ["258"] = -195},
	["Triumphant Runetotem's Battlegear"] = {["245"] = -149, ["258"] = -187},
	["Triumphant Runetotem's Garb"] = {["245"] = -145, ["258"] = -183},
	["Triumphant Runetotem's Regalia"] = {["245"] = -147, ["258"] = -185},
	["Triumphant Sunstrider's Regalia"] = {["245"] = -137, ["258"] = -175},
	["Triumphant Thassarian's Battlegear"] = {["245"] = -164, ["258"] = -202},
	["Triumphant Thassarian's Plate"] = {["245"] = -166, ["258"] = -204},
	["Triumphant Thrall's Battlegear"] = {["245"] = -159, ["258"] = -197},
	["Triumphant Thrall's Garb"] = {["245"] = -155, ["258"] = -193},
	["Triumphant Thrall's Regalia"] = {["245"] = -156, ["258"] = -194},
	["Triumphant Turalyon's Battlegear"] = {["245"] = -170, ["258"] = -208},
	["Triumphant Turalyon's Garb"] = {["245"] = -168, ["258"] = -206},
	["Triumphant Turalyon's Plate"] = {["245"] = -172, ["258"] = -210},
	["Triumphant VanCleef's Battlegear"] = {["245"] = -150, ["258"] = -188},
	["Triumphant Velen's Raiment"] = {["245"] = -140, ["258"] = -178},
	["Triumphant Velen's Regalia"] = {["245"] = -142, ["258"] = -180},
	["Triumphant Windrunner's Battlegear"] = {["245"] = -152, ["258"] = -190},
	["Triumphant Windrunner's Pursuit"] = {["245"] = -153, ["258"] = -191},
	["Triumphant Wrynn's Battlegear"] = {["245"] = -160, ["258"] = -198},
	["Triumphant Wrynn's Plate"] = {["245"] = -162, ["258"] = -200},
	["Triumphant Zabra's Raiment"] = {["245"] = -141, ["258"] = -179},
	["Triumphant Zabra's Regalia"] = {["245"] = -143, ["258"] = -181},

-- T10
	["Ahn'Kahar Blood Hunter's Battlegear"] = -847,
	["Bloodmage's Regalia"] = -839,
	["Crimson Acolyte's Raiment"] = -841,
	["Crimson Acolyte's Regalia"] = -842,
	["Dark Coven's Regalia"] = -840,
	["Frost Witch's Battlegear"] = -850,
	["Frost Witch's Garb"] = -848,
	["Frost Witch's Regalia"] = -849,
	["Lasherweave Battlegear"] = -845,
	["Lasherweave Garb"] = -843,
	["Lasherweave Regalia"] = -844,
	["Lightsworn Battlegear"] = -856,
	["Lightsworn Garb"] = -855,
	["Lightsworn Plate"] = -857,
	["Scourgelord's Battlegear"] = -853,
	["Scourgelord's Plate"] = -854,
	["Shadowblade's Battlegear"] = -846,
	["Ymirjar Lord's Battlegear"] = -851,
	["Ymirjar Lord's Plate"] = -852,
	["Sanctified Ahn'Kahar Blood Hunter's Battlegear"] = {["264"] = -236, ["277"] = -255},
	["Sanctified Bloodmage's Regalia"] = {["264"] = -228, ["277"] = -247},
	["Sanctified Crimson Acolyte's Raiment"] = {["264"] = -230, ["277"] = -249},
	["Sanctified Crimson Acolyte's Regalia"] = {["264"] = -231, ["277"] = -250},
	["Sanctified Dark Coven's Regalia"] = {["264"] = -229, ["277"] = -248},
	["Sanctified Frost Witch's Battlegear"] = {["264"] = -239, ["277"] = -258},
	["Sanctified Frost Witch's Garb"] = {["264"] = -237, ["277"] = -256},
	["Sanctified Frost Witch's Regalia"] = {["264"] = -238, ["277"] = -257},
	["Sanctified Lasherweave Battlegear"] = {["264"] = -234, ["277"] = -253},
	["Sanctified Lasherweave Garb"] = {["264"] = -232, ["277"] = -251},
	["Sanctified Lasherweave Regalia"] = {["264"] = -233, ["277"] = -252},
	["Sanctified Lightsworn Battlegear"] = {["264"] = -245, ["277"] = -264},
	["Sanctified Lightsworn Garb"] = {["264"] = -244, ["277"] = -263},
	["Sanctified Lightsworn Plate"] = {["264"] = -246, ["277"] = -265},
	["Sanctified Scourgelord's Battlegear"] = {["264"] = -242, ["277"] = -261},
	["Sanctified Scourgelord's Plate"] = {["264"] = -243, ["277"] = -262},
	["Sanctified Shadowblade's Battlegear"] = {["264"] = -235, ["277"] = -254},
	["Sanctified Ymirjar Lord's Battlegear"] = {["264"] = -240, ["277"] = -259},
	["Sanctified Ymirjar Lord's Plate"] = {["264"] = -241, ["277"] = -260},

-- T11
	["Battlegear of the Raging Elements"] = {["359"] = 939, ["372"] = -296},
	["Earthen Battleplate"] = {["359"] = 943, ["372"] = -300},
	["Earthen Warplate"] = {["359"] = 942, ["372"] = -299},
	["Firelord's Vestments"] = {["359"] = 931, ["372"] = -288},
	["Lightning-Charged Battlegear"] = {["359"] = 930, ["372"] = -287},
	["Magma Plated Battlearmor"] = {["359"] = 926, ["372"] = -283},
	["Magma Plated Battlegear"] = {["359"] = 925, ["372"] = -282},
	["Mercurial Regalia"] = {["359"] = 936, ["372"] = -293},
	["Mercurial Vestments"] = {["359"] = 935, ["372"] = -292},
	["Regalia of the Raging Elements"] = {["359"] = 940, ["372"] = -297},
	["Reinforced Sapphirium Battlearmor"] = {["359"] = 934, ["372"] = -291},
	["Reinforced Sapphirium Battleplate"] = {["359"] = 932, ["372"] = -289},
	["Reinforced Sapphirium Regalia"] = {["359"] = 933, ["372"] = -290},
	["Shadowflame Regalia"] = {["359"] = 941, ["372"] = -298},
	["Stormrider's Battlegarb"] = {["359"] = 927, ["372"] = -284},
	["Stormrider's Regalia"] = {["359"] = 929, ["372"] = -286},
	["Stormrider's Vestments"] = {["359"] = 928, ["372"] = -285},
	["Vestments of the Raging Elements"] = {["359"] = 938, ["372"] = -295},
	["Wind Dancer's Regalia"] = {["359"] = 937, ["372"] = -294},

-- T12
	["Elementium Deathplate Battlegear"] = {["378"] = 1000, ["391"] = -349},
	["Elementium Deathplate Battlearmor"] = {["378"] = 1001, ["391"] = -350},
	["Obsidian Arborweave Battlegarb"] = {["378"] = 1002, ["391"] = -351},
	["Obsidian Arborweave Regalia"] = {["378"] = 1003, ["391"] = -352},
	["Obsidian Arborweave Vestments"] = {["378"] = 1004, ["391"] = -353},
	["Flamewaker's Battlegear"] = {["378"] = 1005, ["391"] = -354},
	["Vestments of the Dark Phoenix"] = {["378"] = 1006, ["391"] = -355},
	["Firehawk Robes of Conflagration"] = {["378"] = 1007, ["391"] = -356},
	["Balespider's Burning Vestments"] = {["378"] = 1008, ["391"] = -357},
	["Vestments of the Cleansing Flame"] = {["378"] = 1009, ["391"] = -358},
	["Regalia of the Cleansing Flame"] = {["378"] = 1010, ["391"] = -359},
	["Regalia of Immolation"] = {["378"] = 1011, ["391"] = -360},
	["Battleplate of Immolation"] = {["378"] = 1012, ["391"] = -361},
	["Battlearmor of Immolation"] = {["378"] = 1013, ["391"] = -362},
	["Volcanic Vestments"] = {["378"] = 1014, ["391"] = -363},
	["Volcanic Battlegear"] = {["378"] = 1015, ["391"] = -364},
	["Volcanic Regalia"] = {["378"] = 1016, ["391"] = -365},
	["Molten Giant Warplate"] = {["378"] = 1017, ["391"] = -366},
	["Molten Giant Battleplate"] = {["378"] = 1018, ["391"] = -367},

-- T13
	["Necrotic Boneplate Armor"] = {["384"] = -483, ["397"] = 1056, ["410"] = -502},
	["Necrotic Boneplate Battlegear"] = {["384"] = -482, ["397"] = 1057, ["410"] = -501},
	["Deep Earth Battlegarb"] = {["384"] = -480, ["397"] = 1058, ["410"] = -499},
	["Deep Earth Regalia"] = {["384"] = -479, ["397"] = 1059, ["410"] = -498},
	["Deep Earth Vestments"] = {["384"] = -481, ["397"] = 1060, ["410"] = -500},
	["Wyrmstalker Battlegear"] = {["384"] = -478, ["397"] = 1061, ["410"] = -497},
	["Time Lord's Regalia"] = {["384"] = -477, ["397"] = 1062, ["410"] = -496},
	["Armor of Radiant Glory"] = {["384"] = -476, ["397"] = 1065, ["410"] = -495},
	["Battleplate of Radiant Glory"] = {["384"] = -474, ["397"] = 1064, ["410"] = -493},
	["Regalia of Radiant Glory"] = {["384"] = -475, ["397"] = 1063, ["410"] = -494},
	["Regalia of Dying light"] = {["384"] = -472, ["397"] = 1067, ["410"] = -491},
	["Vestments of Dying Light"] = {["384"] = -473, ["397"] = 1066, ["410"] = -492},
	["Blackfang Battleweave"] = {["384"] = -471, ["397"] = 1068, ["410"] = -490},
	["Spiritwalker's Battlegear"] = {["384"] = -468, ["397"] = 1071, ["410"] = -487},
	["Spiritwalker's Regalia"] = {["384"] = -470, ["397"] = 1070, ["410"] = -489},
	["Spiritwalker's Vestments"] = {["384"] = -469, ["397"] = 1069, ["410"] = -488},
	["Vestments of the Faceless Shroud"] = {["384"] = -467, ["397"] = 1072, ["410"] = -486},
	["Colossal Dragonplate Armor"] = {["384"] = -466, ["397"] = 1074, ["410"] = -485},
	["Colossal Dragonplate Battlegear"] = {["384"] = -465, ["397"] = 1073, ["410"] = -484},

-- T14
	 ["Plate of the Lost Catacomb"] = {["483"] = -503, ["496"] = 1124, ["509"] = -526},
	 ["Battlegear of the Lost Catacomb"] = {["483"] = -504, ["496"] = 1123, ["509"] = -527},
	 ["Armor of the Eternal Blossom"] = {["483"] = -505, ["496"] = 1128, ["509"] = -528},
	 ["Battlegear of the Eternal Blossom"] = {["483"] = -508, ["496"] = 1127, ["509"] = -531},
	 ["Regalia of the Eternal Blossom"] = {["483"] = -506, ["496"] = 1126, ["509"] = -529},
	 ["Vestments of the Eternal Blossom"] = {["483"] = -507, ["496"] = 1125, ["509"] = -530},
	 ["Yaungol Slayer Battlegear"] = {["483"] = -509, ["496"] = 1129, ["509"] = -532},
	 ["Regalia of the Burning Scroll"] = {["483"] = -510, ["496"] = 1130, ["509"] = -533},
	 ["Armor of the Red Crane"] = {["483"] = -525, ["496"] = 1133, ["509"] = -548},
	 ["Battlegear of the Red Crane"] = {["483"] = -524, ["496"] = 1132, ["509"] = -547},
	 ["Vestments of the Red Crane"] = {["483"] = -523, ["496"] = 1131, ["509"] = -546},
	 ["White Tiger Battlegear"] = {["483"] = -519, ["496"] = 1135, ["509"] = -542},
	 ["White Tiger Plate"] = {["483"] = -518, ["496"] = 1136, ["509"] = -541},
	 ["White Tiger Vestments"] = {["483"] = -520, ["496"] = 1134, ["509"] = -543},
	 ["Regalia of the Guardian Serpent"] = { ["496"] = 1138},
	 ["Guardian Serpent Regalia"] = {["483"] = -522,  ["509"] = -545},
	 ["Vestments of the Guardian Serpent"] = {["483"] = -521, ["496"] = 1137, ["509"] = -544},
	 ["Battlegear of the Thousandfold Blades"] = {["483"] = -511, ["496"] = 1139, ["509"] = -534},
	 ["Battlegear of the Firebird"] = {["483"] = -512, ["496"] = 1142, ["509"] = -535},
	 ["Regalia of the Firebird"] = {["483"] = -514, ["496"] = 1141, ["509"] = -537},
	 ["Vestments of the Firebird"] = {["483"] = -513, ["496"] = 1140, ["509"] = -536},
	 ["Sha-Skin Regalia"] = {["483"] = -515, ["496"] = 1143, ["509"] = -538},
	 ["Battleplate of Resounding Rings"] = {["483"] = -516, ["496"] = 1144, ["509"] = -539},
	 ["Plate of Resounding Rings"] = {["483"] = -517, ["496"] = 1145, ["509"] = -540},

-- T15
	["Battleplate of the All-Consuming Maw"] = {["502"] = -701, ["522"] = 1152, ["535"] = -724},
	["Plate of the All-Consuming Maw"] = {["502"] = -702, ["522"] = 1151, ["535"] = -725},
	["Armor of the Haunted Forest"] = {["502"] = -706, ["522"] = 1156, ["535"] = -729},
	["Battlegear of the Haunted Forest"] = {["502"] = -703, ["522"] = 1153, ["535"] = -726},
	["Regalia of the Haunted Forest"] = {["502"] = -705, ["522"] = 1155, ["535"] = -728},
	["Vestments of the Haunted Forest"] = {["502"] = -704, ["522"] = 1154, ["535"] = -727, },
	["Battlegear of the Saurok Stalker"] = {["502"] = -707, ["522"] = 1157, ["535"] = -730, },
	["Regalia of the Chromatic Hydra"] = {["502"] = -708, ["522"] = 1158, ["535"] = -731, },
	["Fire-Charm Armor"] = {["502"] = -711, ["522"] = 1161, ["535"] = -734, },
	["Fire-Charm Battlegear"] = {["502"] = -709, ["522"] = 1159, ["535"] = -732, },
	["Fire-Charm Vestments"] = {["502"] = -710, ["522"] = 1160, ["535"] = -733, },
	["Battlegear of the Lightning Emperor"] = {["502"] = -712, ["522"] = 1162, ["535"] = -735, },
	["Plate of the Lightning Emperor"] = {["502"] = -714, ["522"] = 1164, ["535"] = -737, },
	["Vestments of the Lightning Emperor"] = {["502"] = -713, ["522"] = 1163, ["535"] = -736, },
	["Regalia of the Exorcist"] = {["502"] = -716, ["522"] = 1166, ["535"] = -739, },
	["Vestments of the Exorcist"] = {["502"] = -715, ["522"] = 1165, ["535"] = -738, },
	["Nine-Tail Battlegear"] = {["502"] = -717, ["522"] = 1167, ["535"] = -740, },
	["Battlegear of the Witch Doctor"] = {["502"] = -719, ["522"] = 1169, ["535"] = -742, },
	["Regalia of the Witch Doctor"] = {["502"] = -720, ["522"] = 1170, ["535"] = -743, },
	["Vestments of the Witch Doctor"] = {["502"] = -718, ["522"] = 1168, ["535"] = -741, },
	["Regalia of the Thousand Hells"] = {["502"] = -721, ["522"] = 1171, ["535"] = -744, },
	["Battleplate of the Last Mogu"] = {["502"] = -722, ["522"] = 1172, ["535"] = -745},
	["Plate of the Last Mogu"] = {["502"] = -723, ["522"] = 1173, ["535"] = -746},

-- T16
	["Battleplate of Cyclopean Dread"] = {["528"] = -1025, ["540"] = -1048, ["553"] = 1200, ["566"] = -1002},
	["Plate of Cyclopean Dread"] = {["528"] = -1026, ["540"] = -1049, ["553"] = 1201, ["566"] = -1003},
	["Armor of the Shattered Vale"] = {["528"] = -1030, ["540"] = -1053, ["553"] = 1196, ["566"] = -1007},
	["Battlegear of the Shattered Vale"] = {["528"] = -1027, ["540"] = -1050, ["553"] = 1199, ["566"] = -1004},
	["Regalia of the Shattered Vale"] = {["528"] = -1029, ["540"] = -1052, ["553"] = 1197, ["566"] = -1006},
	["Vestments of the Shattered Vale"] = {["528"] = -1028, ["540"] = -1051, ["553"] = 1198, ["566"] = -1005},
	["Battlegear of the Unblinking Vigil"] = {["528"] = -1031, ["540"] = -1054, ["553"] = 1195, ["566"] = -1008},
	["Chronomancer Regalia"] = {["528"] = -1032, ["540"] = -1055, ["553"] = 1194, ["566"] = -1009},
	["Armor of Seven Sacred Seals"] = {["528"] = -1035, ["540"] = -1058, ["553"] = 1191, ["566"] = -1012},
	["Battlegear of Seven Sacred Seals"] = {["528"] = -1033, ["540"] = -1056, ["553"] = 1193, ["566"] = -1010},
	["Vestments of Seven Sacred Seals"] = {["528"] = -1034, ["540"] = -1057, ["553"] = 1192, ["566"] = -1011},
	["Battlegear of Winged Triumph"] = {["528"] = -1036, ["540"] = -1059, ["553"] = 1190, ["566"] = -1013},
	["Plate of Winged Triumph"] = {["528"] = -1038, ["540"] = -1061, ["553"] = 1188, ["566"] = -1015},
	["Vestments of Winged Triumph"] = {["528"] = -1037, ["540"] = -1060, ["553"] = 1189, ["566"] = -1014},
	["Regalia of Ternion Glory"] = {["528"] = -1040, ["540"] = -1063, ["553"] = 1186, ["566"] = -1017},
	["Vestments of Ternion Glory"] = {["528"] = -1039, ["540"] = -1062, ["553"] = 1187, ["566"] = -1016},
	["Barbed Assassin Battlegear"] = {["528"] = -1041, ["540"] = -1064, ["553"] = 1185, ["566"] = -1018},
	["Celestial Harmony Battlegear"] = {["528"] = -1043, ["540"] = -1066, ["553"] = 1183, ["566"] = -1020},
	["Celestial Harmony Regalia"] = {["528"] = -1044, ["540"] = -1067, ["553"] = 1182, ["566"] = -1021},
	["Celestial Harmony Vestment"] = {["528"] = -1042, ["540"] = -1065, ["553"] = 1184, ["566"] = -1019},
	["Regalia of the Horned Nightmare"] = {["528"] = -1045, ["540"] = -1068, ["553"] = 1181, ["566"] = -1022},
	["Battleplate of the Prehistoric Marauder"] = {["528"] = -1046, ["540"] = -1069, ["553"] = 1180, ["566"] = -1023},
	["Plate of the Prehistoric Marauder"] = {["528"] = -1047, ["540"] = -1070, ["553"] = 1179, ["566"] = -1024},
	
--T18
	["Demongaze Armor"] = {["695"] = 1249, ["710"] = -1305, ["725"] = -1306, },
	["Oathclaw Wargarb"] = {["695"] = 1250, ["710"] = -1307, ["725"] = -1308, },
	["Battlegear of the Savage Hunt"] = {["695"] = 1253, ["710"] = -1313, ["725"] = -1314, },
	["Raiment of the Arcanic Conclave"] = {["695"] = 1251, ["710"] = -1309, ["725"] = -1310, },
	["Battlewrap of the Hurricane's Eye"] = {["695"] = 1252, ["710"] = -1311, ["725"] = -1312, },
	["Watch of the Ceaseless Vigil"] = {["695"] = 1254, ["710"] = -1315, ["725"] = -1316, },
	["Attire of Piety"] = {["695"] = 1255, ["710"] = -1317, ["725"] = -1318, },
	["Felblade Armor"] = {["695"] = 1256, ["710"] = -1319, ["725"] = -1320, },
	["Embrace of the Living Mountain"] = {["695"] = 1257, ["710"] = -1321, ["725"] = -1322, },
	["Deathrattle Regalia"] = {["695"] = 1259, ["710"] = -1325, ["725"] = -1326, },
	["Battlegear of Iron Wrath"] = {["695"] = 1258, ["710"] = -1323, ["725"] = -1324, },

}

--Negative values are for proper Currency items, positive values are for items that are used like currency
local Currency_Items = {
	
	["Ancient Mana"] = -1155,
	["Apexis Crystal"] = 32572,
	["Apexis Shard"] = 32569,
	["Arcane Rune"] = 29736,
	["Brawler's Gold"] = -1299,
	["Champion's Seal"] = -241,
	["Coilfang Armaments"] = 24368,
	["Curious Coin"] = -1275,
	["Echoes of Battle"] = -1356,
	["Echoes of Domination"] = -1357,
	["Essence of Corrupted Deathwing"] = -615,
	["Frozen Orb"] = 43102,
	["Glowcap"] = 24245,
	["Halaa Battle Token"] = 26045,
	["Halaa Research Token"] = 26044,
	["Holy Dust"] = 29735,
	["Mark of Honor Hold"] = 24579,
	["Mark of Thrallmar"] = 24581,
	["Mark of the Illidari"] = 32897,
	["Mark of the World Tree"] = -416,
	["Mote of Darkness"] = -614,
	["Nethershard"] = -1226,
	["Order Resources"] = -1220,
	["Sightless Eye"] = -1149,
	["Spirit Shard"] = -1704,
	["Sunmote"] = 34664,
	["Timewarped Badge"] = -1166,
	["Tol Barad Commendation"] = -391,
	["Winterfin Clam"] = 34597,
	["Elder Charm of Good Fortune"] = -697,
	["Bloody Coin"] = -789,
	["War Resources"] = -1560,
	["Seafarer's Dubloon"] = -1710,

-- PROFESSIONS
--   Blacksmithing
	["Elementium Bar"] = 52186,
	["Hardened Elementium Bar"] = 53039,
	["Pyrium Bar"] = 51950,
	["Kyparite"] = 72093,
--   Cooking
	["Epicurean's Award"] = -81,
	["Ironpaw Token"] = -402,
--   Enchanting
	["Dream Shard"] = 34052,
	["Abyss Crystal"] = 34057,
	["Hypnotic Dust"] = 52555,
	["Heavenly Shard"] = 52721,
	["Maelstrom Crystal"] = 52722,
--   Jewelcrafting
	["Dalaran Jewelcrafter's Token"] = -61,
	["Illustrious Jewelcrafter's Token"] = -361,
	["Zen Jewelcrafter's Token"] = -698,
--   Leatherworking
	["Heavy Borean Leather"] = 38425,
	["Arctic Fur"] = 44128,
	["Heavy Savage Leather"] = 56516,
--   Tailoring
	["Bolt of Embersilk Cloth"] = 53643,
	["Dreamcloth"] = 54440,

-- SEASONAL
	["Brewfest Prize Token"] = 37829,
	["Burning Blossom"] = 23247,
	["Coin of Ancestry"] = 21100,
	["Darkmoon Prize Ticket"] = -515,
	["Noblegarden Chocolate"] = 44791,
}

local Tradeskill_Gem_Cut_level_filters = {
	{maxle=60},
	{minle=61,maxle=70,qu=2},
	{minle=61,maxle=70,qu=3},
	{minle=61,maxle=70,qu=4},
	{minle=71,maxle=80,qu=2},
	{minle=71,maxle=80,qu=3},
	{minle=71,maxle=80,qu=4},
	{minle=81,maxle=85,qu=2},
	{minle=81,maxle=85,qu=3},
	{minle=81,maxle=85,qu=4},
	{minle=86,maxle=90,qu=2},
	{minle=86,maxle=90,qu=3},
	{minle=86,maxle=90,qu=4},
	{minle=91},
}

local Tradeskill_Gem_Color_categories = {
	Red = "3.0",
	Blue = "3.1",
	Yellow = "3.2",
	Purple = "3.3",
	Green = "3.4",
	Orange = "3.5",
	Meta = "3.6",
	Simple = "3.7",
	Prismatic = "3.8",
	Hydraulic = "3.9",
	Cogwheel = "3.10",
}

local Consumable_Bandage_filters = {
	Basic = "86;11;0",
	["Alterac Valley"] = {cr=104,crs=0,crv="Alterac"},
	["Warsong Gulch"] = {cr=107,crs=0,crv="Warsong"},
	["Arathi Basin"] = {cr=107,crs=0,crv="Arathi"},
}

local Consumable_Buff_Type_filters = {
	["Battle"] = {cr=107,crs=0,crv="battle elixir"},
	["Guardian"] = {cr=107,crs=0,crv="guardian elixir"},
	["Both1"] = {cr=107,crs=0,crv="guardian and battle elixir"},
	["Both2"] = {cr=107,crs=0,crv="effect persists through death"},
}

--[[ ITEM UTILITY FUNCTIONS ]]

-- .boe : will only search for boe items
-- .heroic : will only search for heroic items
-- .levels : only check items with these levels
-- .format : method of parsing, 1:old
-- .israid : filter by raid difficulty (not dungeon)
local InstanceLoot_TrashMobs = {
	--[[ CLASSIC ]]
	["Molten Core"] = { id = 2717, boe = true, levels = {66}, israid = true, format = 1 },
	["Blackwing Lair"] = { id = 2677, levels = {70,71}, israid = true, format = 1 },
	-- ["Zul'Gurub"] = { id = , levels = , }, -- Zul'Gurub has none
	-- ["Ruins of Ahn'Qiraj"] = { id = , levels = , }, -- Ruins of Ahn'Qiraj has none
	["Ahn'Qiraj"] = { id = 3428, levels = {71}, israid = true, format = 1 }, -- Temple of Ahn'Qiraj really
	--[[ BURNING CRUSADE ]]
	["Karazhan"] = { id = 2562, levels = {115}, israid = true, format = 1 },
	["Serpentshrine Cavern"] = { id = 3607, levels = {128}, israid = true, format = 1 },
	["The Eye"] = { id = 3842, levels = {128}, israid = true, format = 1 },
	["Hyjal Summit"] = { id = 3606, levels = {141}, israid = true, format = 1 },
	["Black Temple"] = { id = 3959, levels = {141}, israid = true, format = 1 },
	["Sunwell Plateau"] = { id = 4075, levels = {154}, israid = true, format = 1 },
	--[[ WRATH ]]
	["Naxxramas"] = { id = 3456, levels = {200, 213}, israid = true },
	["Ulduar"] = { id = 4273, levels = {200, 219, 226}, israid = true },
	["Icecrown Citadel"] = { id = 4812, levels = {200, 264}, israid = true },
	--[[ CATACLYSM ]]
	["The Bastion of Twilight"] = { id = 5334, levels = {359,372}, israid = true },
	["Blackwing Descent"] = { id = 5094, levels = {359,372}, israid = true },
	["Firelands"] = { id = 5723, levels = {359, 378}, israid = true, boe = true },
	["Dragon Soul"] = { id = 5892, levels = {397}, israid = true, boe = true },
	--[[ MOP ]]
	-- [TODO]
}

--[[
	WoWHead dificulty mapping:
	-- Dungeons
	1: heroic 5man
	2: normal 5man
	-- Raids
	4: all (loot statistics)
	8: normal 10man
	16: normal 25man
	32: heroic 10man
	64: heroic 25man
	128: lfr 25man
]]
local status, bit = pcall(require, "bit")
if not status then bit = nil end
local is_heroic_item = function(item)
	local result
	if bit then
		result = bit.band(1+32+64, item.modes.mode) ~= 0
	else
		result = item.heroic or (item.modes and (item.modes["1"] or item.modes["32"] or item.modes["64"]))
	end
	-- recheck, normal 25man might be our heroic version
	if not result then
		if bit then
			result = bit.band(16, item.modes.mode) ~= 0 and bit.band(8, item.modes.mode) == 0
		else
			result = item.modes["16"] and not item.modes["8"]
		end
	end
	return result
end
local is_lfr_item = function(item)
	local result
	if bit then
		result = bit.band(128, item.modes.mode) ~= 0
	else
		result = item.raidfinder or item.modes["128"]
	end
	return result
end
local is_normal_item = function(item, heroic, lfr)
	local result
	local heroic = heroic or is_heroic_item(item)
	local lfr = lfr or is_lfr_item(item)
	if bit then
		result = bit.band(2+8+16, item.modes.mode) ~= 0 or (not heroic and not lfr)
		-- item drops in normal 25, but not normal 10 - this is most likely a heroic item
		if result and bit.band(16, item.modes.mode) ~= 0 and bit.band(8, item.modes.mode) == 0 then
			result = nil
		end
	else
		result = (item.modes and (item.modes["2"] or item.modes["8"] or item.modes["16"])) or (not heroic and not lfr)
		if result and item.modes["16"] and not item.modes["8"] then
			result = nil
		end
	end
	return result
end

--[[ SET HANDLERS ]]

local function handle_trash_mobs(set)
	local instance = set:match("^InstanceLoot.-%.([^%.]+)")
	local info = assert(InstanceLoot_TrashMobs[instance], "Instance "..instance.." not found !")
	local heroicset = set:match("^InstanceLootHeroic%.")

	-- Filters: "Drops in ... ": <instance> + "Drops in 10 man normal (Raid)": <any> + ...
	local cr, crs, crv = { 16 }, { info.id }, { 0 }
	if info.format and info.format == 1 then
		-- old format: normal 10 = "normal", normal 25 = "heroic"
		if info.israid then
			if info.heroic or heroicset then
				table.insert(cr, "148") -- normal 25
			else
				table.insert(cr, "147") -- normal 10
			end
		else
			if info.heroic or heroicset then
				table.insert(cr, "106") -- heroic 5
			else
				table.insert(cr, "105") -- normal 5
			end
		end
		table.insert(crs, "-2323")
		table.insert(crv, 0)
	else
		-- new format: normal 10, normal 25 = "normal", heroic 10, heroic 25 = "heroic"
		if info.israid then
			if info.heroic or heroicset then
				table.insert(cr, "149") -- heroic 10
				table.insert(cr, "150") -- heroic 25
			else
				table.insert(cr, "147") -- normal 10
				table.insert(cr, "148") -- normal 25
			end
			table.insert(crs, "-2323")
			table.insert(crs, "-2323")
			table.insert(crv, 0)
			table.insert(crv, 0)
		else
			if info.heroic or heroicset then
				table.insert(cr, "106") -- heroic 5
			else
				table.insert(cr, "105") -- normal 5
			end
			table.insert(crs, "-2323")
			table.insert(crv, 0)
		end
	end

	-- only search for boe items
	if info.boe then
		table.insert(cr, "3")
		table.insert(crs, 1)
		table.insert(crv, 0)
	end

	local sets = {}
	for _, level in ipairs(info.levels) do
		-- we don't care about blues or higher
		local url = WH("items", nil, {minle = level, maxle = level, cr = cr, crs = crs, crv = crv, qu = {3,4,5,6,7}})
		local set = basic_listview_handler(url, function (item)
			local itemid, count = item.id, 0
			local url = WH("item", itemid)

			if item.sourcemore and not item.sourcemore[1].bd then
				return itemid
			end

			basic_listview_handler(url, function (item)
				if instance == "Blackwing Lair" and item.name:find("Death Talon") then -- Hack for BWL
					count = count + INSTANCELOOT_TRASHMINSRC
				end
				count = count + 1
			end, "dropped-by")
			if count <= INSTANCELOOT_TRASHMINSRC then
				return
			end
			return itemid
		end)
		if set and set ~= "" then
			table.insert(sets, set)
		end
	end
	return table.concat(sets, ",")
end

local is_junk_drop
do
	local junkdrops = {}
	is_junk_drop = function (itemid)
		local value = junkdrops[itemid]
		if value ~= nil then return value end

		local count = 0
		local url = WH("item", itemid)
		local page = getpage(url)

		local name = page:match("<h1>([^<%-]+)</h1>")
		dprint(4, "name", name)

		basic_listview_handler(url, function (entry)
			if entry.count and entry.count < INSTANCELOOT_MIN then return end
			count = count + 1
		end, "dropped-by")

		if count > INSTANCELOOT_MAXSRC then
			dprint(3, name, "Added to Junk (too many source)")
			junkdrops[itemid] = true
			return true
		else
			junkdrops[itemid] = false
			return false
		end
	end
end

handlers["^ClassSpell"] = function (set, data)
	local class, tree = set:match('^ClassSpell%.(.+)%.(.+)$')
	return basic_listview_handler(WH("spells", Class_Skills_categories[class][tree]), function(item)
		return "-"..item.id..":"..item.level
	end)
end

--handlers["^Disenchant%.Strange Dust"] = function (set, data)
--	return basic_listview_handler("http://www.wowhead.com/items?filter=161:3:163;1:1:10940;0:0:0",
--		function (item)
--			return item.id
--		end)
--end

local Disenchant_urls = {
	["Arcane Dust"] =  	"http://www.wowhead.com/items?filter=161:3:163;1:1:22445;0:0:0",
	["Arkhana"] =  	"http://www.wowhead.com/items?filter=161:3:163;1:1:124440;0:0:0",
	["Draenic Dust"] =  "http://www.wowhead.com/items?filter=161:3:163;1:1:109693;0:0:0",
	["Hypnotic Dust"] =  "http://www.wowhead.com/items?filter=161:3:163;1:1:52555;0:0:0",
	["Infinite Dust"] = "http://www.wowhead.com/items?filter=161:3:163;1:1:34054;0:0:0",
	["Light Illusion Dust"] =   	"http://www.wowhead.com/items?filter=161:3:163;1:1:16204;0:0:0",
	["Rich Illusion Dust"] =   "http://www.wowhead.com/items?filter=161:3:163;1:1:156930;0:0:0",
	["Shadow Dust"] =     "http://www.wowhead.com/items?filter=161:3:163;1:1:152875;0:0:0",
	["Spirit Dust"] =     "http://www.wowhead.com/items?filter=161:3:163;1:1:74249;0:0:0",
	["Strange Dust"] =  "http://www.wowhead.com/items?filter=161:3:163;1:1:10940;0:0:0",
}

handlers["^Disenchant%."] = function (set, data)
	local newset ={}
	local setname = set:match("%.([^%.]+)$")
	local url = Disenchant_urls[setname];

	basic_listview_handler(url, nil, nil, newset )

	table.sort(newset, sortSet)
	return table.concat(newset, ",")

end



handlers["^Consumable%.Bandage"] = function (set, data)
	local newset = {}
	local setname = set:match("%.([^%.]+)$")
	local filter = Consumable_Bandage_filters[setname]
	if not filter then return end
	local views = get_page_listviews(WH2("bandages", nil, nil, filter))
	for _, item in ipairs(views.items.data) do
		local item_url = WH("item", item.id)
		local item_page = getpage(item_url):gmatch("tooltip_enus = '<table>.-</table>'")() --Just focus on tooltip, otherwise it can match comments on the page
		item_page = item_page:gsub("<!--.--->", "")	--remove off commented html tags
		local heal = item_page:match("Heals (%d+) damage")
		if heal then
			newset[#newset + 1] = item.id .. ":" .. heal
		end

	end

	table.sort(newset, sortSet)
	return  table.concat(newset, ",")
end

local both_buff_types
handlers["^Consumable%.Buff Type"] = function (set, data)
	local newset
	local setname = set:match("%.([^%.]+)$")

	local filter = Consumable_Buff_Type_filters[setname]
	if setname ~= "Both" and not filter then return end

	if not both_buff_types then
		both_buff_types = {}
		local handler = function (item)
			both_buff_types[item.id] = true
		end
		basic_listview_handler(WH("items", nil, Consumable_Buff_Type_filters.Both1), handler)
		basic_listview_handler(WH("items", nil, Consumable_Buff_Type_filters.Both2), handler)
	end


	if setname == 'Both' then
		local list = {}
		for entry in pairs(both_buff_types) do
			list[#list + 1] = entry
		end
		return table.concat(list,",")
	end

	return basic_listview_handler(WH("items", nil, filter), function (item)
		local itemid = item.id
		if not both_buff_types[itemid] then
			return itemid
		end
	end)
end

handlers["^Consumable%.Scroll"] = function (set, data)
	local newset ={}
	basic_listview_handler(WH2("other-consumables", "scroll", nil, {cr="161", crs="1"}), nil, nil, newset )
	
	table.sort(newset, sortSet)
	return table.concat(newset, ",")

end


local Consumable_Potion_Recovery_filters = {
	["Rejuvenation.Basic"]		= {cr="107:107",		crs="0:0",		crv="health:mana"},
	["Rejuvenation.Trance"] 	= {cr="107",			crs="0",		crv="puts the",									},
	["Healing.Zone-Restricted"]	= {cr="107:107:107",	crs="0:0:0",	crv="restores:health:only"},
	["Healing.Endless"]			= {cr="107:107:104",	crs="0:0:0",	crv="restores:health:not+consumed"},
	["Healing.Basic"]			= {cr="107:107",		crs="0:0",		crv="restores:health",					excludes={"Healing.Zone-Restricted","Healing.Endless","Rejuvenation.Basic","Rejuvenation.Trance"}},
	["Mana.Zone-Restricted"]	= {cr="107:107:107",	crs="0:0:0",	crv="restores:mana:only"},
	["Mana.Endless"]			= {cr="107:107:104",	crs="0:0:0",	crv="restores:mana:not+consumed"},
	["Mana.Basic"]				= {cr="107:107",		crs="0:0",		crv="restores:mana",					excludes={"Mana.Zone-Restricted","Mana.Endless","Rejuvenation.Basic","Rejuvenation.Trance"}},
}

handlers["^Consumable%.Potion%.Recovery"] = function (set, data)

	local setName = set:match("%.([^%.]+%.[^%.]+)$")
	if not setName then return end

	local setFilter = Consumable_Potion_Recovery_filters[setName]
	if not setFilter then return end

	print(setName, WH("items","0.1",Consumable_Potion_Recovery_filters[setName]))

	local exclude = {}
	if setFilter.excludes then
		for _, v in ipairs(setFilter.excludes) do
			basic_listview_handler(WH("items","0.1",Consumable_Potion_Recovery_filters[v]),nil,nil, exclude)
		end
	end
	return basic_listview_handler(WH("items","0.1",Consumable_Potion_Recovery_filters[setName]), function(item)
		if not is_in(exclude,tostring(item.id)) then
			return item.id..":"..item.level
		end
	end)

end

handlers["^CurrencyItems"] = function (set, data)
	local currency = set:match("^CurrencyItems%.([^%.]+)")
	--if not Currency_Items[currency] then return end
	local currency_id = assert(Currency_Items[currency])
	if currency_id > 0 then
		return basic_listview_handler(WH("item", currency_id), function (item)
			local count
			for _, v in ipairs(item.cost[3]) do
				if v[1] == currency_id then
					count = v[2]
					break
				end
			end
			if not count then print(itemstr) end
			return item.id..":"..count
		end, "currency-for")
	else
		return basic_listview_handler(WH("currency", -currency_id), function (item)
			local count
			for _, v in ipairs(item.cost[2]) do
				if v[1] == 396 and item.level == 359 then return end --XXX temp fix for jp items showing up on a vp vendor (http://www.wowhead.com/npc=44245)
				if v[1] == -currency_id then
					count = v[2]
					break
				end
			end
			if not count then print(itemstr) end
			return item.id..":"..count
		end, "items")
	end
end

handlers["^Gear%.Socketed"] = function (set, data)
	local newset = {}
	local slot = set:match("%.([^%.]+)$")
	for _, filter in ipairs(Gear_Socketed_filters[slot]) do
		for _, levelfilter in ipairs(Gear_level_filters) do
			filter.minrl = levelfilter.minrl
			filter.maxrl = levelfilter.maxrl
			basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
		end
	end

	table.sort(newset, sortSet)
	return table.concat(newset, ",")
end

handlers["^Gear%.Trinket$"] = function (set, data)
	local newset = {}
	for q = 1, 7  do
		basic_listview_handler(WH("items", "4.-4", {qu=q}), nil, nil, newset)
	end

	table.sort(newset, sortSet)
	print("Trinkets Total:", # newset)
	return table.concat(newset, ",")
end

handlers["^GearSet"] = function (set, data)
	local newset, id = {}, nil
	local setname = set:match("%.([^%.]+)$")
	if GearSets_fixedids[setname] then
		id = GearSets_fixedids[setname]
		if type(id) == "table" then -- support for heroic versions of sets based on ilevel
			local ilevel = set:match("%.Tier %d+%.(%d+)%.")
			id = id[ilevel]
		end
	elseif set:find(".Gray.") then
	-- these aren't real sets so they can't be auto-mined
		return nil
	elseif set:find(".PvP.Arena.") then
	-- wowhead can't do exact match on name as it seems so other arena sets including the name would show up to (and be picked unfortunately)
		id = basic_listview_get_first_id(WH2("item-sets", setname, nil, {qu=4}))
	else
		local tiertag = set:match("(Tier %d+)")
		if(tiertag and GearSets_tags[tiertag]) then
			id = basic_listview_get_first_id(WH2("item-sets", setname, GearSets_tags[tiertag]))		
		else
			id = basic_listview_get_first_id(WH2("item-sets", setname, nil))
		end
	end
	if id then
		local count = 0
		local page = getpage(WH("item-set", id))
		local summary = json(page:match("new Summary%((%b{})%)"), true)
		for _, g in ipairs(summary.groups) do
			local itemid = g[1][1]
			if itemid then
				newset[#newset + 1] = tostring(itemid)
				count = count + 1
			else
				error("no itemid")
			end
		end
		dprint(3, "GearSet: "..setname.." has "..count)
		table.sort(newset, sortSet)
		return table.concat(newset, ",")
	end
end

local ArmorTypes = {
	["Cloth"] = 1,
	["Leather"] = 2,
	["Mail"] = 3,
	["Plate"] = 4,
}
local ArmorQualities = {
	["Junk"] = 0,
	["Common"] = 1,
	["Uncommon"] = 2,
	["Rare"] = 3,
	["Epic"] = 4,
}
local transmogparsed = {}

-- parsing transmog sets is rather weird as we can retrieve all required data from the overview listview
handlers["^TransmogSet"] = function (set, data)
	if not TRANSMOGSETS_CHKSRC then return end
	local type, quality, name = set:match("^TransmogSet%.([^%.]+)%.([^%.]+)%.?(.*)$")
	local setstub = "TransmogSet."..type.."."..quality

	if transmogparsed[setstub] then return end
	local transmogsetparsed = {}

	local url = WH("transmog-sets", nil, {qu=ArmorQualities[quality], type=ArmorTypes[type]})
	if not url then return end
	local page = assert(getpage(url))

	local data
	for var in page:gmatch("var transmogSets = (%b[])") do
		data = json(var, true)
	end

	-- force order so we keep a consistent naming scheme
	table.sort(data, function(a, b) return a.id < b.id end)
	for _, tset in ipairs(data) do
		local setname = string.sub(tset.name, 2)
		setname = string.gsub(setname, " %(Recolor%)", "")
		setname = string.gsub(setname, " %(Lookalike%)", "")

		-- handle duplicate set names, e.g. Arcane Regalia (Recolor)
		local offset = transmogsetparsed[setname]
		transmogsetparsed[setname] = (offset or 0) + 1
		if offset then
			setname = string.format("%s (Recolor %d)", setname, offset)
		end

		local transmogset = sets[setstub.."."..setname]
		if not transmogset then
			dprint(2, "ERR MISSING transmogrification set " .. setstub.."."..setname)
		else
			sets[setstub.."."..setname] = table.concat(tset.pieces, ",")
		end
	end
	transmogparsed[setstub] = true
end

handlers["^InstanceLoot%."] = function (set, data)
	if not INSTANCELOOT_CHKSRC then return end
	local newset = {}
	local zone, boss = set:match("([^%.]+)%.([^%.]+)$")
	if boss == "Trash Mobs" then
		return handle_trash_mobs(set)
	end
	local id, type = basic_listview_get_npc_id(boss, zone), "npc"
	if not id then
		local zoneid = get_zone_id_from_name(zone)
		local filter = zoneid and {cr=1, crs=zoneid, crv=0} or {}
		filter.na = boss
		id, type = basic_listview_get_first_id(WH("objects", nil, filter)), "object"
	end

	if id then
		local views = get_page_listviews(WH(type, id))
		local count_heroic, count_lfr = 0, 0

		local handle_heroic_item = function (item)
			local normalsub = set:match("^.-%.(.+)$")
			local heroicname = "InstanceLootHeroic."..normalsub
			if not sets[heroicname] and count_heroic == 0 then
				dprint(2, "ERR MISSING Heroic set for " .. normalsub .. ": " .. heroicname)
			end
			count_heroic = count_heroic + 1
		end
		local handle_lfr_item = function (item)
			local normalsub = set:match("^.-%.(.+)$")
			local lfrname = "InstanceLootLFR."..normalsub
			if not sets[lfrname] and count_lfr == 0 then
				dprint(2, "ERR MISSING LFR set for " .. normalsub .. ": " .. lfrname)
			end
			count_lfr = count_lfr + 1
		end

		local handler = function (item)
			dprint(4, "checking item", item.id)
			if is_junk_drop(item.id) then return end

			local quality = 6 - tonumber(item.name:match("^(%d)"))
			if quality < 1 then return end

			local is_lfr = is_lfr_item(item)
			local is_heroic = is_heroic_item(item)
			local is_normal = is_normal_item(item, is_heroic, is_lfr)

			if is_heroic then handle_heroic_item(item) end
			if is_lfr then handle_lfr_item(item) end

			if not is_normal then return end
			local totalDrops = (item.modes and item.modes["2"] and item.modes["2"].count) or (item.modes and item.modes["8"] and item.modes["8"].count) or (item.modes and item.modes["16"] and item.modes["16"].count) or item.count or 0
			local totalLoot = (item.modes and item.modes["2"] and item.modes["2"].outof) or (item.modes and item.modes["8"] and item.modes["8"].outof) or (item.modes and item.modes["16"] and item.modes["16"].outof) or totaldrops or 0

			local droprate = (totalDrops > 0 and totalLoot > 0) and totalDrops/totalLoot or 0
				  droprate = math.floor(droprate * 1000)
			return item.id..":"..droprate
		end

		for id, view in pairs(views) do
			if id == "contains" or id == "drops" then
				totaldrops = view.count
				for _, item in ipairs(view.data) do
					local v = handler(item)
					if v and not is_in(newset, v) then
						table.insert(newset, v)
					end
				end
			end
		end
		if not totaldrops or totaldrops == 0 then
			print("*ERROR* "..boss.. " NO LOOT DATA FOUND!")
		end

		dprint(2, "InstanceLoot: "..boss.." has "..(newset and #newset or 0).." normal, "..count_heroic.." heroic and "..count_lfr.." raid finder drops.")
		table.sort(newset, sortSet_id)
		return table.concat(newset, ",")
	else
		print("*ERROR* "..boss.. " NOT FOUND !")
	end
end
handlers["^InstanceLootHeroic%."] = function (set, data)
	if not INSTANCELOOT_CHKSRC then return end

	local newset = {}
	local zone, boss = set:match("([^%.]+)%.([^%.]+)$")
	if boss == "Trash Mobs" then
		return handle_trash_mobs(set)
	end
	local id, type = basic_listview_get_npc_id(boss, zone), "npc"
	if not id then
		local zoneid = get_zone_id_from_name(zone)
		local filter = zoneid and {cr=1, crs=zoneid, crv=0} or {}
		filter.na = boss
		id, type = basic_listview_get_first_id(WH("objects", nil, filter)), "object"
	end

	if id then
		local views = get_page_listviews(WH(type, id))
		local handler = function (item)
			dprint(4, "checking item", item.id)
			if is_junk_drop(item.id) then return end
			local quality = 6 - tonumber(item.name:match("^(%d)"))
			if quality < 1 then return end

			local is_heroic = is_heroic_item(item)
			if not is_heroic then return end

			local totalDrops = (item.modes["32"] and item.modes["32"].count or 0)
				+ (item.modes["64"] and item.modes["64"].count or 0)
				+ (item.modes["1"] and item.modes["1"].count or 0)
			local totalLoot = (item.modes["32"] and item.modes["32"].outof or 0)
				+ (item.modes["64"] and item.modes["64"].outof or 0)
				+ (item.modes["1"] and item.modes["1"].outof or 0)

			local droprate = (totalDrops > 0 and totalLoot > 0) and totalDrops/totalLoot or 0
				  droprate = math.floor(droprate * 1000)
			return item.id..":"..droprate
		end

		for id, view in pairs(views) do
			if id == "contains" or	id == "drops" then
				totaldrops = view.count
				for _, item in ipairs(view.data) do
					local v = handler(item)
					if v and not is_in(newset, v) then
						table.insert(newset, v)
					end
				end
			end
		end
		if not totaldrops or totaldrops == 0 then
			print("*ERROR* "..boss.. " NO LOOT DATA FOUND!")
		end

		table.sort(newset, sortSet_id)
		return table.concat(newset, ",")
	else
		print("*ERROR* "..boss.. " NOT FOUND !")
	end
end
handlers["^InstanceLootLFR%."] = function (set, data)
	if not INSTANCELOOT_CHKSRC then return end

	local newset = {}
	local zone, boss = set:match("([^%.]+)%.([^%.]+)$")
	if boss == "Trash Mobs" then
		return handle_trash_mobs(set)
	end
	local id, type = basic_listview_get_npc_id(boss, zone), "npc"
	if not id then
		local zoneid = get_zone_id_from_name(zone)
		local filter = zoneid and {cr=1, crs=zoneid, crv=0} or {}
		filter.na = boss
		id, type = basic_listview_get_first_id(WH("objects", nil, filter)), "object"
	end

	if id then
		local views = get_page_listviews(WH(type, id))
		local handler = function (item)
			dprint(4, "checking item", item.id)
			if is_junk_drop(item.id) then return end
			local quality = 6 - tonumber(item.name:match("^(%d)"))
			if quality < 1 then return end

			local is_lfr = is_lfr_item(item)
			if not is_lfr then return end

			local totalDrops = item.modes["128"].count
			local totalLoot = item.modes["128"].outof

			local droprate = (totalDrops > 0 and totalLoot > 0) and totalDrops/totalLoot or 0
				  droprate = math.floor(droprate * 1000)
			return item.id..":"..droprate
		end

		for id, view in pairs(views) do
			if id == "contains" or	id == "drops" then
				totaldrops = view.count
				for _, item in ipairs(view.data) do
					local v = handler(item)
					if v and not is_in(newset, v) then
						table.insert(newset, v)
					end
				end
			end
		end
		if not totaldrops or totaldrops == 0 then
			print("*ERROR* "..boss.. " NO LOOT DATA FOUND!")
		end

		table.sort(newset, sortSet_id)
		return table.concat(newset, ",")
	else
		print("*ERROR* "..boss.. " NOT FOUND !")
	end
end

--[[-- trash mobs only get scanned with -chksrc
handlers["^InstanceLootHeroic%..+%.Trash Mobs"] = function (set, data)
	return handle_trash_mobs(set)
end--]]

handlers["^Misc%.Bag%."] = function (set, data)
	local setname = set:match("%.([^%.]+)$")
	local cat = Bag_categories[setname]
	if not cat then return end
	return basic_listview_handler(WH("items", cat), function (item)
		return item.id..":"..item.nslots
	end)
end

handlers["^Misc%.Container%.ItemsInType"] = function (set, data)
	local newset = {}
	local container = set:match("%.([^%.]+)$")
	local container_id = Containers_ItemsInType_items[container]
	if not container_id then return end
	return basic_listview_handler(WH("item", container_id), nil, "can-contain")
end

-- Misc.Openable has too many items to capture this way. Even adding MANY limits level 1 still has > 200 items
handlers["^Misc%.Openable"] = function (set, data)
	local newset = {}
	multiple_qualities_listview_handler("items", nil, {cr=11,crs=1,crv=0}, newset, "le", 50)
	-- Add the clams that are not in the query
	basic_listview_handler(WH("items", nil, {na="clam", cr=107, crs=0, crv="Open"}), nil, nil, newset)
	table.sort(newset, sortSet)
	return table.concat(newset, ",")
end

handlers["^Misc%.Key"] = function (set, data)
	local setname = set:match("%.([^%.]+)$")
	return basic_listview_handler(WH("items", 13), nil, nil, newset)
end

handlers["^Misc%.Tabard"] = function (set, data)
	local setname = set:match("%.([^%.]+)$")
	return basic_listview_handler(WH("items", nil, {sl=19,cr=161;crs=1;crv=0}), nil, nil, newset)
end

handlers["^Misc%.Lockboxes"] = function (set, data)
	return basic_listview_handler(WH("items", nil, {cr=10,crs=1,crv=0}), function (item)
		page = getpage(WH("item", item.id).."&xml") -- hack
		local skill = page:match("Requires Lockpicking %((%d+)%)") or 0
		if skill then
			return item.id..":"..skill
		else
			print("Misc Lockboxes error for item "..item.id)
		end
	end)
end

handlers["^Consumable.Food.Edible.Combo.Conjured"] = function (set, data)
	return basic_listview_handler(WH("items", "0.5", {cr="9:107:107";crs="1:0:0";crv="0:health:mana"}), function (item)
		page = getpage(WH("item", item.id).."&xml") -- hack
		local mana = page:match("health and (%d+)%%* [Mm]ana")
		if mana then
			return item.id..":"..mana
		else
			print("Consumable.Food.Edible.Combo.Conjured error "..item.id)
		end
	end)
end

handlers["^Misc%.Minipet%."] = function (set, data)
	local count = 0
	local src = set:match("^Misc%.Minipet%.(.+)$")
	filter = Minipet_filters[src]
	if not filter then return end

	return basic_listview_handler(WH("items", "15.2", filter),
		function (item)
			return item.id..":"..(item.sourcemore and item.sourcemore[1].ti or 0)
		end)
end

handlers["^Misc%.Mount%."] = function (set, data)
	local count = 0
	local category = set:match("^Misc%.Mount%.([^%.]+)$")
	category = Mount_filter_categories[category]
	if not category then return end

	return basic_listview_handler(WH("items", category, {cr=161,crs=1,crv=0}),
		function (item)
			return item.id..":"..item.level
		end)
end

-- Misses way too much stuff
handlers["^Misc%.Usable%.StartsQuest$"] = function (set, data)
	local newset = {}
	multiple_qualities_listview_handler("items", nil, {cr=6,crs=1,crv=0}, newset, "rl")
	table.sort(newset, sortSet)
	return table.concat(newset, ",")
end

handlers["^Reputation%.Reward%."] = function (set, data)
	local faction = set:match("([^%.]+)$")
	local id = basic_listview_get_id_by_name(WH("factions"), faction)
	return basic_listview_handler(WH('faction', id), function(item)
		return item.id..':'..(item.standing+1)
	end, 'items')
end

handlers["^Tradeskill%.Crafted%.Archaeology"] = function (set, data)
	-- items created by Archaeology which are at least white quality
	local filters = {qu={1,2,3,4,5,6,7},cr=86,crs=16,crv=0}
	return basic_listview_handler(WH("items", nil, filters), nil, 'items')
end
handlers["^Tradeskill%.Crafted"] = function (set, data)
	local profession = set:match("^Tradeskill%.Crafted%.(.+)$")
	dprint(9, "profession", profession)

	if (profession == "Archaeology") then -- TODO
		return nil
	end

	local cat = Tradeskill_Profession_categories[profession]
	if not cat then return end

	local newset, fp_set, rp_set, lp_set, level_set = {}, {}, {}, {}, {}
	local reagenttable = {}

	local skillfilter = {}
	if Tradeskill_Profession_filters[profession] then
		for k, v in pairs(Tradeskill_Profession_filters[profession]) do
			skillfilter[k] = v
		end
	end
	for skilllevelfilter = 1, MAX_TRADESKILL_LEVEL, 25 do
		skillfilter.minrs = skilllevelfilter
		skillfilter.maxrs = skilllevelfilter + 24
--		if (skillfilter.maxrs == MAX_TRADESKILL_LEVEL) then
--			skillfilter.maxrs = nil
--		end
		basic_listview_handler(WH("spells", cat, skillfilter), function (item)
			local spellid = item.id
			if not item.reagents then return end
			-- local colorstring = itemstring:match("colors:(%b[])")
			local skilllvl = math.min(MAX_TRADESKILL_LEVEL, tonumber(item.learnedat) or MAX_TRADESKILL_LEVEL)
			local itemid = item.creates and item.creates[1] or (-1 * spellid) -- count ?
			dprint(3, profession, itemid, item.name, skilllvl)
			if itemid and skilllvl > 0 then
				newset[#newset + 1] = itemid..":"..(item.learnedat or 999)
				local newrecipemats = itemid..":"
				for _, reagent in ipairs(item.reagents) do
					local reagentid, reagentnum = unpack(reagent)
					if reagenttable[reagentid] then
						reagenttable[reagentid] = reagenttable[reagentid]..";"..itemid.."x"..reagentnum
					else
						reagenttable[reagentid] = itemid.."x"..reagentnum
					end
					newrecipemats = newrecipemats..reagentid.."x"..reagentnum..";"
				end
				newrecipemats = newrecipemats:sub(1,-2)
				local levels = {}
				if not item.colors then
					levels[1] = "?"
					levels[2] = "?"
					levels[3] = "?"
					levels[4] = "?"
				else
					for k,v in ipairs(item.colors) do
						levels[k] = v == 0 and "-" or tostring(v)
					end
				end
				fp_set[#fp_set + 1] = newrecipemats
				lp_set[#lp_set + 1] = "-"..spellid..":"..itemid
				level_set[#level_set + 1] = itemid..":"..table.concat(levels, "/")
			end
		end)
	end
	for k,v in pairs(reagenttable) do
		rp_set[#rp_set + 1] = k..":"..v
	end

	table.sort(fp_set, sortSet_id)
	fp_set = table.concat(fp_set, ",")
	printdiff("TradeskillResultMats.Forward."..profession, sets["TradeskillResultMats.Forward."..profession], fp_set)
	sets["TradeskillResultMats.Forward."..profession] = fp_set
	table.sort(rp_set, sortSet_id)
	rp_set = table.concat(rp_set, ",")
	printdiff("TradeskillResultMats.Reverse."..profession, sets["TradeskillResultMats.Reverse."..profession], rp_set)
	sets["TradeskillResultMats.Reverse."..profession] = rp_set
	table.sort(lp_set, sortSet)
	lp_set = table.concat(lp_set, ",")
	printdiff("Tradeskill.RecipeLinks."..profession, sets["Tradeskill.RecipeLinks."..profession], lp_set)
	sets["Tradeskill.RecipeLinks."..profession] = lp_set
	table.sort(level_set, sortSet_id)
	level_set = table.concat(level_set, ",")
	printdiff("TradeskillLevels."..profession, sets["TradeskillLevels."..profession], level_set)
	sets["TradeskillLevels."..profession] = level_set

	table.sort(newset, sortSet)
	return table.concat(newset, ",")
end

handlers["^Tradeskill%.Gather%."] = function (set, data)
	local count = 0
	if set:match("^Tradeskill%.Gather%.GemsInNodes") then
		local nodetype = set:match("%.([^%.]+)$")
		local id = Tradeskill_Gather_GemsInNodes_nodes[nodetype]
		if not id then return end
		return basic_listview_handler(WH("object", id), function(item)
			if item.classs == 7 and item.subclass == 4 then return item.id end
		end, "mining")
	else
		local gathertype = set:match("%.([^%.]+)$")
		local filter = Tradeskill_Gather_filter_values[gathertype]
		if filter then
			filter = {cr=filter, crs=1, crv=0}
			local newset = {}
			for q = 0, 7 do
				filter.qu = q
				if q == 0 or q == 1 or q == 2 then
					filter.minle = nil
					filter.maxle = 1
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
					filter.minle = 2
					filter.maxle = 30
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
					filter.minle = 31
					filter.maxle = 60
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
					filter.minle = 61
					filter.maxle = 90
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
					filter.minle = 91
					filter.maxle = nil
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
				else
					filter.minle = nil
					filter.maxle = nil
					basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
				end
			end
			table.sort(newset, sortSet)
			return table.concat(newset, ",")
		end
	end
end

handlers["^Tradeskill%.Gem%."] = function (set, data)
	local color = set:match("%.([^%.]+)$")
	if color == "Cut" then
		local newset = {}
		local gems = {}
		local gem_cut_func = function (item)
			local itemid = item.id
			basic_listview_handler(WH("item", itemid), function (item)
				if not item.reagents then return end -- uncraftable gems, e.g. 89873
				for _, reagent in ipairs(item.reagents) do
					local src_id, count = unpack(reagent)
					if src_id ~= 27860 then -- Purified Draenic Water
						if not gems[src_id] then gems[src_id] = {} end
						-- gems[src_id][#(gems[src_id]) + 1] = itemid
						table.insert(gems[src_id], itemid)
					end
				end
			end, 'created-by-spell')
		end
		local filter = {cr=81,crs=7,crv=0}
		for _, entry in ipairs(Tradeskill_Gem_Cut_level_filters) do
			filter.minle = entry.minle
			filter.maxle = entry.maxle
			filter.qu = entry.qu
			basic_listview_handler(WH("items", nil, filter), gem_cut_func)
		end
		for k, v in pairs(gems) do
			table.sort(v)
			newset[#newset + 1] = k..":"..table.concat(v, ";")
		end
		table.sort(newset, sortSet_id)
		return table.concat(newset, ",")
	else
		local filter = Tradeskill_Gem_Color_categories[color]
		return filter and basic_listview_handler(WH("items", filter))
	end
end

handlers["^Tradeskill%.Mat%.ByProfession"] = function (set, data)
	local profession = set:match("^Tradeskill%.Mat%.ByProfession%.(.+)$")
	local cat = Tradeskill_Profession_categories[profession]
	if not cat then return end
	local reagentlist = {}

	local skillfilter = {}
	if Tradeskill_Profession_filters[profession] then
		for k, v in pairs(Tradeskill_Profession_filters[profession]) do
			skillfilter[k] = v
		end
	end
	for skilllevelfilter = 1, MAX_TRADESKILL_LEVEL, 25 do
		skillfilter.minrs = skilllevelfilter
		skillfilter.maxrs = skilllevelfilter + 24
		basic_listview_handler(WH("spells", cat, skillfilter), function (item)
			if not item.reagents then return end
			for _, r in ipairs(item.reagents) do
				reagentlist[r[1]] = true
			end
		end)
	end
	local newset = {}
	for reagent in pairs(reagentlist) do
		newset[#newset + 1] = reagent
	end
	table.sort(newset)
	return table.concat(newset, ",")
end

handlers["Tradeskill%.Mat%.ByProfession%.Farming"] = function(set, data)
	local newset = {}
	basic_listview_handler(WH("items","0.0",{cr=107,crs=0,crv="Tilled Soil"}), nil, nil, newset)
	basic_listview_handler(WH("items","0.0",{cr=104,crs=0,crv="sunsong"}), nil, nil, newset)
	
	table.sort(newset, sortSet)
	return table.concat(newset, ",")

end

handlers["^Tradeskill%.Recipe%."] = function (set, data)
	local count = 0
	local profession, src = set:match("^Tradeskill%.Recipe%.([^%.]+)%.(.+)$")
	profession = Tradeskill_Recipe_categories[profession]
	filter = Tradeskill_Recipe_filters[src]
	if not profession or not filter then return end

	return basic_listview_handler(WH("items", profession, filter),
		function (item) return item.id..":"..item.skill end)
end

handlers["^Tradeskill%.Tool"] = function (set, data)
	local newset = {}
	local count = 0
	local profession = set:match("^Tradeskill%.Tool%.(.+)$")
	local filters = Tradeskill_Tool_filters[profession]
	if not filters then return end

	for _, filter in ipairs(filters) do
		basic_listview_handler(WH("items", nil, filter), nil, nil, newset)
	end

	table.sort(newset, sortSet)
	return table.concat(newset, ",")
end

-- Adds items not mineable / easily mineable to the end of a set
-- For instance rank 1 talents to ClassSpell
local additionalSetItems = {
	["ClassSpell.Death Knight.Blood"] = ",-48982:20,-49005:30,-49016:40,-55233:45,-55050:50,-49028:60",
	["ClassSpell.Death Knight.Frost"] = ",-49039:20,-49796:30,-49203:40,-51271:45,-49143:50,-49184:60",
	["ClassSpell.Death Knight.Unholy"] = ",-49158:20,-51052:40,-63560:40,-49222:45,-55090:50,-49206:60",
	["ClassSpell.Druid.Balance"] = ",-5570:30,-33831:50,-50516:50,-48505:60",
	["ClassSpell.Druid.Feral Combat"] = ",-49377:30,-33878:50,-33876:50,-50334:60",
	["ClassSpell.Druid.Restoration"] = ",-17116:30,-18562:40,-48438:60",
	["ClassSpell.Mage.Frost"] = ",-12472:20,-11958:30,-11426:40,-31687:50,-44572:60",
	["ClassSpell.Paladin.Protection"] = ",-64205:20",
	["ClassSpell.Rogue.Combat"] = ",-51690:60",
	["Tradeskill.Recipe.Jewelcrafting.Vendor"] = ",71949:525",
}

local function update_all_sets(sets, setcount)
	local setid = 0
	local failed = 0
	for set, data in pairs(sets) do
		setid = setid + 1
		local newset
		if data:sub(1,2) ~= "m," then
			dprint(1, ("current set: %4d/%4d"):format(setid, setcount), set)
			for pattern, handler in pairs(handlers) do
				if set:match(pattern) then
					local status, result = pcall(handler, set, data)
					if status then
						if result then
							newset = result
							break
						end
					else
						dprint(1, "ERR", set, pattern, result)
					end
				end
			end
		else
			dprint(1, ("current set: %4d/%4d"):format(setid, setcount), set, "   - skipped: multiset")
		end
		if newset then
			local add = additionalSetItems[set]
			if add then newset = newset..add end
			printdiff(set, sets[set] or "", newset)
			-- check if we mined an empty set that would overwrite existing data
			if newset == "" and sets[set] ~= newset then
				dprint(1, "WARNING: mined empty data for non-empty set. skipping set", set)
			else
				sets[set] = newset
				collectgarbage("collect")
			end
		else
			failed = failed + 1
		end
	end
	return failed
end

local function write_output(file, sets)
	local f = assert(io.open(SOURCE, "w"))
	for line in file:gmatch('([^\n]-\n)') do
		local setname, spaces, set_data, comment = line:match('\t%[%"([^"]+)%"%]([^=]-)=%s-"([^"]-)",([^\n]-)\n')
		
		--If it's a properly formatted set line either write out the updated info (if any) or write the original line back out
		if setname then
			if sets[setname] then
				f:write('\t["',setname,'"]',spaces,'= "',sets[setname],'",',comment,'\n')
			else
				f:write('\t["',setname,'"]',spaces,'= "',set_data,'",',comment,'\n')
			end
		else	--It's not a set line, could be a typo
			local comment_ptn = '^%s*%-%-'
			local block_end_ptn = '%]=-%]'
			local blank_ptn = '^%s-\n'
			if (DEBUG > 0)  and not (string.match(line, comment_ptn) or string.match(line, block_end_ptn) or string.match(line, blank_ptn)) then --A weird line, possibly an error
				print("warning: weird line:".. line)
			end
			f:write(line)
		end
	end
	f:close()
end

local function main()
	local starttime = os.time()

	local file, setcount
	file, sets, setcount = read_data_file()
	print(("%d sets in datafile"):format(setcount))
	local notmined = update_all_sets(sets, setcount)
	local elapsed = os.time()- starttime
	local cputime = os.clock()
	print(("Elapsed Time: %dm %ds"):format(elapsed/60, elapsed%60))
	print(("%dm %ds spent servicing %d web requests"):format(httptime/60, httptime%60, httpcount))
	print(("%dm %ds spent in processing data"):format((elapsed-httptime)/60,(elapsed-httptime)%60))
	print(("Approx %dm %.2fs CPU time used"):format(cputime/60, cputime%60))
	print(("%d sets mined, %d sets not mined."):format(setcount - notmined, notmined))
	write_output(file, sets)
end

main()
