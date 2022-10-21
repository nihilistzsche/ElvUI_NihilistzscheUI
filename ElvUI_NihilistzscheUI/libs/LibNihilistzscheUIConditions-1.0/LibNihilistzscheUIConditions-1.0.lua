local MAJOR_VERSION = "LibNihilistzscheUIConditions-1.0"
local MINOR_VERSION = 1

if not _G.LibStub then
    error(MAJOR_VERSION .. " requires LibStub")
end

local NihilistzscheLib = _G.LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not NihilistzscheLib then
    return
end

local strlen = _G.strlen
local tinsert = _G.tinsert

NihilistzscheLib.registeredConditions = {}

function NihilistzscheLib:RegisterCondition(tag, numArguments, validationFunc)
    if (self.registeredConditions[tag]) then
        return
    end
    self.registeredConditions[tag] = {numArguments = numArguments, validationFunc = validationFunc}
    self.registeredConditions[tag].matchStr = self:BuildConditionMatch(tag)
    self.registeredConditions[tag].negateMatchStr =
        string.sub(self.registeredConditions[tag].matchStr, 1, 2) ..
        "no" ..
            string.sub(self.registeredConditions[tag].matchStr, 3, strlen(self.registeredConditions[tag].matchStr) - 2)
end

function NihilistzscheLib:UnregisterCondition(tag)
    self.registeredConditions[tag] = nil
end

function NihilistzscheLib:BuildConditionMatch(tag)
    local info = self.registeredConditions[tag]
    if (not info) then
        return
    end

    local matchStr = "%[" .. tag
    if (info.numArguments > 0) then
        for i = 1, info.numArguments do
            local sep = ":"
            if (i > 1) then
                sep = "/"
            end
            matchStr = matchStr .. sep .. "([^/%]]+)"
        end
    end
    matchStr = matchStr .. "%]"
    return matchStr
end

function NihilistzscheLib:EvaluateConditionString(conditionString)
    for _, v in pairs(self.registeredConditions) do
        if (conditionString:match(v.matchStr)) then
            local args = {conditionString:match(v.matchStr)}
            if (not v.validationFunc(unpack(args))) then
                return false
            end
        elseif (conditionString:match(v.negateMatchStr)) then
            local args = {conditionString:match(v.negateMatchStr)}
            if (v.validationFunc(unpack(args))) then
                return false
            end
        end
    end

    return true
end

function NihilistzscheLib:GetTagsFromConditionString(conditionString)
    local tagsFound = {}
    for k, v in pairs(self.registeredConditions) do
        if (conditionString:match(v.matchStr)) then
            tinsert(tagsFound, k)
        end
    end
    return tagsFound
end
