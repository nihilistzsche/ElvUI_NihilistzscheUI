-- (c) 2007 Nymbia.  see LGPLv2.1.txt for full details.
local sets = {}
local function update(filename)
	print("updating file:", filename)
	local f = assert(io.open(filename, "r"))
	local file = f:read("*all")
	f:close()
	local f = assert(io.open(filename, "w"))
	for line in string.gmatch(file, '([^\n]-\n)') do
		local setname, data = string.match(line, '\t%[%"([^\n^"]+)%"%][^\n]-=[^\n]-"([^\n]-)",')
		if setname and sets[setname] then
			f:write('\t["'..setname..'"]="'..sets[setname]..'",\n')
		else
			if setname then
				print("Set "..setname.." not found in latest data.")
			end
			f:write(line)
		end
	end
	f:close()
end
local f = assert(io.open("data.lua", "r"))
local file = f:read("*all")
f:close()

for line in string.gmatch(file, '([^\n]-\n)') do
	local setname, data = string.match(line, '\t%[%"([^\n^"]+)%"%][^\n]-=[^\n]-"([^\n]-)",')
	if data then
		sets[setname] = data
	end
end

update("./LibPeriodicTable-3.1-ClassSpell/LibPeriodicTable-3.1-ClassSpell.lua")
update("./LibPeriodicTable-3.1-Consumable/LibPeriodicTable-3.1-Consumable.lua")
update("./LibPeriodicTable-3.1-CurrencyItems/LibPeriodicTable-3.1-CurrencyItems.lua")
update("./LibPeriodicTable-3.1-InstanceLoot/LibPeriodicTable-3.1-InstanceLoot.lua")
update("./LibPeriodicTable-3.1-InstanceLootHeroic/LibPeriodicTable-3.1-InstanceLootHeroic.lua")
update("./LibPeriodicTable-3.1-InstanceLootLFR/LibPeriodicTable-3.1-InstanceLootLFR.lua")
update("./LibPeriodicTable-3.1-Gear/LibPeriodicTable-3.1-Gear.lua")
update("./LibPeriodicTable-3.1-GearSet/LibPeriodicTable-3.1-GearSet.lua")
update("./LibPeriodicTable-3.1-TransmogSet/LibPeriodicTable-3.1-TransmogSet.lua")
update("./LibPeriodicTable-3.1-Misc/LibPeriodicTable-3.1-Misc.lua")
update("./LibPeriodicTable-3.1-Reputation/LibPeriodicTable-3.1-Reputation.lua")
update("./LibPeriodicTable-3.1-Tradeskill/LibPeriodicTable-3.1-Tradeskill.lua")
update("./LibPeriodicTable-3.1-TradeskillLevels/LibPeriodicTable-3.1-TradeskillLevels.lua")
update("./LibPeriodicTable-3.1-TradeskillResultMats/LibPeriodicTable-3.1-TradeskillResultMats.lua")
