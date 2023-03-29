local NUI = _G.unpack((select(2, ...)))
local PXP = NUI.PartyXP

function PXP:InitData() self.data = {} end

function PXP:UpdateData(guid, ...)
    local data = self.data[guid]
    if not data then
        data = {}
        self.data[guid] = data
    end
    local _d = { ... }
    for i = 1, #_d, 2 do
        local k, v = _d[i], _d[i + 1]
        data[k] = v
    end
    data.guid = guid
end

function PXP:GetDataForPartyMember(guid) return self.data[guid] end
