util.AddNetworkString("RDV_DAP_ConfigurationMenu")
util.AddNetworkString("RDV_DAP_ConfigurationUpdate")

local function SendNotification(ply, msg)
	local CFG = {
		Appension = NCS_DATAPAD.CONFIG.PREFIX,
		Color = NCS_DATAPAD.CONFIG.PREFIX_C,
	}

	NCS_DATAPAD.AddText(ply, CFG.Color, "["..CFG.Appension.."] ", color_white, msg)
end

hook.Add("PlayerSay", "RDV_DAP_ConfigurationCommand", function(P, TEXT)
    if TEXT == string.lower(NCS_DATAPAD.CONFIG.COMMAND) then
        NCS_DATAPAD.IsAdmin(P, function(ACCESS)
            if !ACCESS then return end
            
            local DATA = {}

            local function Race()
                if DATA.MostPlayed and DATA.EntriesCreated then
                    net.Start("RDV_DAP_ConfigurationMenu")
                        net.WriteUInt(DATA.EntriesCreated, 32)
                        net.WriteTable(DATA.MostPlayed)
                    net.Send(P)
                end
            end

            RDV_DP_Mysql:RawQuery("SELECT COUNT(*), PLAYER FROM RDV_DATAPAD_ENTRIES GROUP BY PLAYER ORDER BY COUNT(*) DESC", function(data)
                if data and data[1] ~= nil then
                    DATA.MostPlayed = { COUNT = ( data[1]["COUNT(*)"] or 0 ), PLAYER = ( data[1].PLAYER or "Invalid" ) }
                else
                    DATA.MostPlayed = { COUNT = 0, PLAYER = "Invalid" }
                end

                Race()
            end )

            RDV_DP_Mysql:RawQuery("SELECT COUNT(*) FROM RDV_DATAPAD_ENTRIES", function(data)
                if data and data[1] ~= nil then
                    DATA.EntriesCreated = ( data[1]["COUNT(*)"] or 0 )
                else
                    DATA.EntriesCreated = 0
                end

                Race()
            end )
        end )

        return ""
    end
end )

local function LoadConfig()
    local PATH = "rdv/datapad/cfg/config.json"

    if file.Exists(PATH, "DATA") then
        local DATA = file.Read(PATH, "DATA")
        DATA = util.JSONToTable(DATA)

        for k, v in pairs(DATA) do
            if ( DATA[k] ~= nil ) then
                NCS_DATAPAD.CONFIG[k] = v
            end
        end
    end
end
LoadConfig()

hook.Add("NCS_DATAPAD_PlayerReadyForNetworking", "RDV_DAP_ConfigUpdate", function(P)
    local CFG = NCS_DATAPAD.CONFIG

    if !CFG or !istable(CFG) then return end

    local json = util.TableToJSON(CFG)
    local compressed = util.Compress(json)
    local length = compressed:len()

    net.Start("RDV_DAP_ConfigurationUpdate")
        net.WriteUInt(length, 32)
        net.WriteData(compressed, length)
    net.Send(P)     
end )

net.Receive("RDV_DAP_ConfigurationUpdate", function(_, P)
    NCS_DATAPAD.IsAdmin(P, function(ACCESS)
        if !ACCESS then return end
        
        local length = net.ReadUInt(32)
        local data = net.ReadData(length)
        local uncompressed = util.Decompress(data)

        if (!uncompressed) then
            return
        end

        local DIR = "rdv/datapad/cfg/"

        file.CreateDir(DIR)

        file.Write(DIR.."config.json", uncompressed)

        local D = util.JSONToTable(uncompressed)

        if !D.USERGROUPS["superadmin"] then
            D.USERGROUPS["superadmin"] = "World"
        end

        if D.DescLimit then
            D.DescLimit = math.Round(D.DescLimit)
        end

        if D.TitleLimit then
            D.TitleLimit = math.Round(D.TitleLimit)
        end

        NCS_DATAPAD.CONFIG = D

        SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_configurationUpdated"))

        net.Start("RDV_DAP_ConfigurationUpdate")
            net.WriteUInt(length, 32)
            net.WriteData(data, length)
        net.Broadcast()
    end )
end )