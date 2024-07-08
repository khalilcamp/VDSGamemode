-- Microphone: https://www.flaticon.com/free-icon/microphone_709682
-- Person: https://icon-icons.com/icon/person/110935

timer.Simple(0, function()    
    local VALID = RDV.LIBRARY.RegisterProduct("Comms", {
        {
            Name = "RDV Library (https://steamcommunity.com/sharedfiles/filedetails/?id=2146897844)",
            Check = function()
                if !RDV then return false end
            end,
        },
    }, "qJStlJW")

    if !VALID then return end

    RDV.COMMUNICATIONS = RDV.COMMUNICATIONS or {
        RelayEnabled = true,
        LIST = {},
        OCCUPANTS = {},
        Players = {},
        TemporaryChannels = {},
        PASSIVE = {},
        SPASSIVE = {},
        MUTED = {},
        ACTIVE = {},
        RELAYS = {},
        RelayChannels = {},
        CFG = {},
    }

    local rootDir = "rdv_communications"

    local function AddFile(File, dir)
        local fileSide = string.lower(string.Left(File , 3))

        if SERVER and fileSide == "sv_" then
            include(dir..File)
        elseif fileSide == "sh_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            end
            include(dir..File)
        elseif fileSide == "cl_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            elseif CLIENT then
                include(dir..File)
            end
        end
    end

    local function IncludeDir(dir)
        dir = dir .. "/"
        local File, Directory = file.Find(dir.."*", "LUA")

        for k, v in ipairs(File) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir)
            end
        end
        
        for k, v in ipairs(Directory) do
            IncludeDir(dir..v)
        end
    end
    IncludeDir(rootDir)

    
    RDV.COMMUNICATIONS.LOADED = true
    
    hook.Run("RDV_COMMS_Loaded")
end)