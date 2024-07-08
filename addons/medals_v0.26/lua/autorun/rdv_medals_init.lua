timer.Simple(0, function()
    local VALID = RDV.LIBRARY.RegisterProduct("Medals", {}, "EHqttDU")

    if !VALID then return end

    RDV.MEDALS = RDV.MEDALS or {
        P_TAB = {},
        P_PRIM = {},
        LIST = {}, 
        CACHE_LIST = {},
    }

    local rootDir = "rdv_medals"

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

    properties.Add( "givemedal", {
        MenuLabel = RDV.LIBRARY.GetLang(nil, "MED_giveMedal"),
        Order = 999,
        MenuIcon = "icon16/add.png",
        Filter = function( self, ent, client )
            if not ent:IsPlayer() then return false end
    
            if !RDV.MEDALS.CFG.Admins[client:GetUserGroup()] then return false end
    
            return true
        end,
        Action = function( self, ent, uid )
            if ( !self:Filter( ent, LocalPlayer() ) ) then return end
    
    
            self:MsgStart()
                net.WriteEntity( ent )
                net.WriteUInt(uid, 32)
            self:MsgEnd()
        end,
        Receive = function( self, length, client )
            local ent = net.ReadEntity()
    
            if ( !self:Filter( ent, client ) ) then return end
    
            local MEDAL = net.ReadUInt(32)
    
            RDV.MEDALS.Give(MEDAL, ent, client)
        end,
        MenuOpen = function( self, option, ent, tr )
            if ( !self:Filter( ent, LocalPlayer() ) ) then return end
                    
            local submenu = option:AddSubMenu(RDV.LIBRARY.GetLang(nil, "MED_giveMedal"))
            
            for k, v in pairs(RDV.MEDALS.LIST) do
                if not IsValid(submenu) then
                    return
                end
                
                local opt = submenu:AddOption(v.Name, function()
                    if not IsValid(ent) then
                        return
                    end
    
                    self:Action(ent, k)
                end)
            end
        end,
    } )
end )