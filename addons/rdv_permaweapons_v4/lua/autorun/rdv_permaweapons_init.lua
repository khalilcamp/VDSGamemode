timer.Simple(0, function()
    NCS_PERMAWEAPONS = NCS_PERMAWEAPONS or {
        WEAPONS = {},
        CharSystems = {},
        CFG = {
            Weapons = {},
        },
        CATS = {},
    }
    
    local rootDir = "perma_weapons"

    local function AddFile(File, dir, realm)
        if !realm then
            realm = string.lower(string.Left(File , 3))
        end

        if SERVER and realm == "sv_" then
            include(dir..File)
        elseif realm == "sh_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            end
            include(dir..File)
        elseif realm == "cl_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            elseif CLIENT then
                include(dir..File)
            end
        end
    end

    local function IncludeDir(dir, realm)
        dir = dir .. "/"
        local File, Directory = file.Find(dir.."*", "LUA")

        for k, v in ipairs(File) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir, realm)
            end
        end

        for k, v in ipairs(Directory) do
            if ( v == "weapons" ) then
                IncludeDir(dir..v, "sh_")
                continue
            end

            IncludeDir(dir..v)
        end
    end
    IncludeDir(rootDir)

    if CAMI then
        CAMI.RegisterPrivilege({
            Name = "[NCS] PermaWeapons",
            MinAccess = "superadmin"
        })
    end

    if SERVER then
        NCS_PERMAWEAPONS.MysqlConnect()
    end
end)