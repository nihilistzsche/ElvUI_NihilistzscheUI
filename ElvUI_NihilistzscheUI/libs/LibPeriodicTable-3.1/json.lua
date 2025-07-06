local DEBUG = JSON_DEBUG

local loadstring = loadstring
local assert = assert
local tonumber = tonumber
local error = error
local print = print
local setmetatable = setmetatable
local string_sub = string.sub
local string_find = string.find
local string_match = string.match
local string_match = string.match

--[[
	Released in the public domain.

	Inspired by JSON4Lua, by Craig Mason-Jones ( http://json.luaforge.net/ )

	Only decode.
	Optionally supports unquoted string as key to array (Javascript format).
]]
module"json"

local decode_any

local function skip_space(s, startPos)
	if DEBUG then print("skip_space", startPos, string_sub(s, startPos)) end
	local c = string_sub(s, startPos, startPos)
	while string_find(" \n\r\t", c, nil, true) do
		startPos = startPos + 1
		c = string_sub(s, startPos, startPos)
	end
	return startPos, c
end

local function decode_string(s, startPos)
	if DEBUG then print("decode_string", startPos, string_sub(s, startPos)) end
	local escaped = false
	local quote_type =  string_sub(s, startPos, startPos)
	local endPos = startPos + 1
	while true do
		local char = string_sub(s, endPos, endPos)
		if char == '\\' then
			escaped = true
		elseif char == quote_type  and not escaped then
			if DEBUG then print("in decode_string", string_sub(s, startPos, endPos)) end
			local result = loadstring('return ' .. string_sub(s, startPos, endPos))()
			return result, endPos + 1
		else
			escaped = false
		end
		endPos = endPos + 1
	end
end

local function decode_number(s, startPos)
	if DEBUG then print("decode_number", startPos, string_sub(s, startPos)) end
	local endPos = assert(string_find(s, "[^0-9.e+-]", startPos)) - 1
	local result = string_sub(s, startPos, endPos)
	if DEBUG then print("in decode_number", endPos, result) end
	local value = assert(tonumber(result), "invalid number")
	return value, endPos + 1
end

local NIL = {}

local CONSTANTS = {
	["true"] = true,
	["false"] = false,
	["null"] = NIL,
}

local function decode_constant(s, startPos, allowStringConstants)
	if DEBUG then print("decode_constant", startPos, allowStringConstants, string_sub(s, startPos)) end
	assert(string_match(string_sub(s, startPos, startPos), "^[a-zA-Z_]"))
	local endPos = assert(string_find(s, "[^a-zA-Z0-9_]", startPos)) - 1
	local result = string_sub(s, startPos, endPos)
	local value = CONSTANTS[result]
	if not value and allowStringConstants then
		value = result
	end
	--assert(value, ("invalid constant %s"):format(result)) -- [ckaotik] constants can be nil/false which won't validate!
	return value, endPos + 1
end

local function decode_list(s, startPos)
	if DEBUG then print("decode_list", startPos, string_sub(s, startPos)) end
	local list = {}
	local index = 1
	startPos = startPos + 1
	while true do
		local char
		startPos, char = skip_space(s, startPos)
		if char == "]" then
			return list, startPos + 1
		elseif char == "," then
			index = index + 1
			startPos = startPos + 1
		else
			assert(not list[index])
			list[index], startPos = decode_any(s, startPos)
		end
	end
end

local function decode_array(s, startPos)
	if DEBUG then print("decode_array", startPos, string_sub(s, startPos)) end
	local array = {}
	local key, value
	local state = 0
	startPos = startPos + 1
	while true do
		if DEBUG then print("in decode_array", state, key, value) end
		local char
		startPos, char = skip_space(s, startPos)
		if char == "}" then
			if state == 3 then
				array[key] = value
			else
				assert(state == 0)
			end
			return array, startPos + 1
		elseif state == 1 and char == ":" then
			assert(key)
			startPos = startPos + 1
			state = 2
		elseif state == 3 and char == "," then
			array[key] = value
			startPos = startPos + 1
			state, key, value = 0, nil, nil
		elseif state == 0 then
			key, startPos = decode_any(s, startPos, true)
			state = 1
		elseif state == 2 then
			value, startPos = decode_any(s, startPos)
			state = 3
		else
			error("unable to parse array")
		end
	end
end

decode_any = function(s, startPos, allowStringConstants)
	assert(s, "Missing required string to decode")
	if DEBUG then print("decode_any", startPos, string_sub(s, startPos)) end
	local char
	startPos, char = skip_space(s, startPos)
	if char == "'" or char == '"' then
		return decode_string(s, startPos)
	elseif char == "[" then
		return decode_list(s, startPos)
	elseif char == "{" then
		return decode_array(s, startPos)
	elseif string_find("0123456789+-.", char, nil, true) then
		return decode_number(s, startPos)
	else
		return decode_constant(s, startPos, allowStringConstants)
	end
	error("invalid decode")
end

_M.decode = function (s, allowStringConstants)
	return decode_any(s, 1, allowStringConstants)
end

_M.register_constant = function (name, value)
	CONSTANTS[name] = value
end

setmetatable(_M, {
	__call = function (_, s, allowStringConstants)
		return decode_any(s, 1, allowStringConstants)
	end,
})

_M.null = NIL
