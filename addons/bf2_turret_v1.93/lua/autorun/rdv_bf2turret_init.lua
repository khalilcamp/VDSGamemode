timer.Simple(0, function()
    local VALID = RDV.LIBRARY.RegisterProduct("BF2 Turret", {}, "VrTINXT")

    if !VALID then return end

    RDV.BF2_TURRET = RDV.BF2_TURRET or {
        TURRETS = {},
    }

    local rootDir = "rdv_bf2turret"

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
            if ( v == "variants" ) then
                IncludeDir(dir..v, "sh_")
                continue
            end

            IncludeDir(dir..v)
        end

    end
    IncludeDir(rootDir)
end)