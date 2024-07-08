if RDV.COMMUNICATIONS and RDV.COMMUNICATIONS.LOADED then return end

local COL_1 = Color(255,255,255)

function RDV.COMMUNICATIONS.RegisterChannel(self, CHANNEL, DATA)
    if DATA.Factions then
        local NEW = {}

        for k, v in ipairs(DATA.Factions) do
            NEW[v] = true
        end

        DATA.Factions = NEW
    end

    if !DATA.Color then
        DATA.Color = COL_1
    end

    local HOOK = hook.Run("RDV_COMMS_CanRegisterChannel", CHANNEL, DATA)
    if ( HOOK == false ) then
        return
    end

    RDV.COMMUNICATIONS.LIST[CHANNEL] = DATA
end