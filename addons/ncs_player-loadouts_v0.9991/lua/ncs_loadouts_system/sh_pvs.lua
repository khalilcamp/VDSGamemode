local UpdateList = {}

if CLIENT then
    local dataCaching = {}
    
    function NCS_LOADOUTS.GetConfigData(dataType, callback)
        if UpdateList[dataType] and dataType == 1 then callback(NCS_LOADOUTS.LIST) return end
        if UpdateList[dataType] and dataType == 2 then callback(NCS_LOADOUTS.CERTS) return end

        net.Start("NCS_LOADOUTS_SnatchConfigData")
            net.WriteUInt(dataType, 2)
        net.SendToServer()
        
        dataCaching[dataType] = callback
        UpdateList[dataType] = true
    end

    net.Receive("NCS_LOADOUTS_SnatchConfigData", function()
        local dataType = net.ReadUInt(2)
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local uncompressed = util.Decompress(data)

        if (!uncompressed) then
            return
        end

        local D = util.JSONToTable(uncompressed)

        if dataCaching[dataType] and isfunction(dataCaching[dataType]) then
            dataCaching[dataType](D)
        end

        if dataType == 1 then
            NCS_LOADOUTS.LIST = D

            hook.Run("NCS_LOADOUTS_LoadoutsUpdated")
        else
            NCS_LOADOUTS.CERTS = D

            hook.Run("NCS_LOADOUTS_CertificationsUpdated")
        end
    end )
else

    local function SendConfigData(FILTER, DT)
        local json
        local compressed
        local length

        if DT == 1 then
            local DATA = NCS_LOADOUTS.LIST

            json = util.TableToJSON(DATA)
            compressed = util.Compress(json)
            length = compressed:len()
        elseif DT == 2 then
            local DATA = NCS_LOADOUTS.CERTS

            json = util.TableToJSON(DATA)
            compressed = util.Compress(json)
            length = compressed:len()
        end

        net.Start("NCS_LOADOUTS_SnatchConfigData")
            net.WriteUInt(DT, 2)
            net.WriteUInt(length, 32)
            net.WriteData(compressed, length)
        net.Send(FILTER)
    end

    util.AddNetworkString("NCS_LOADOUTS_UpdateLoadoutsConfiguration")

    hook.Add("NCS_LOADOUTS_SaveLoadouts", "NCS_LOADOUTS_UpdateListManagement", function(D)
        local FILTER = RecipientFilter()
        
        for k, v in ipairs(player.GetHumans()) do
            if UpdateList[v] and UpdateList[v][1] then
                FILTER:AddPlayer(v)
            end
        end

        SendConfigData(FILTER, 1)
    end )

    hook.Add("NCS_LOADOUTS_SaveCertifications", "NCS_LOADOUTS_UpdateListManagement", function(D)
        local FILTER = RecipientFilter()

        for k, v in ipairs(player.GetHumans()) do
            if UpdateList[v] and UpdateList[v][2] then
                FILTER:AddPlayer(v)
            end
        end
        
        SendConfigData(FILTER, 2)
    end )

    util.AddNetworkString("NCS_LOADOUTS_SnatchConfigData")
    net.Receive("NCS_LOADOUTS_SnatchConfigData", function(_, P)
        local DT = net.ReadUInt(2)

        UpdateList[P] = UpdateList[P] or {}
        UpdateList[P][DT] = true
        
        SendConfigData(P, DT)
    end )
end
