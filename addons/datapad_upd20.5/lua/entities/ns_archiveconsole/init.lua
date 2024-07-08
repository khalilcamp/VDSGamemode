AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    local function CheckLoaded()
        if NCS_DATAPAD.CONFIG.MODEL then
            self:SetModel(NCS_DATAPAD.CONFIG.MODEL)
        else
            timer.Simple(0, CheckLoaded)
        end
    end

    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end

    CheckLoaded()
end

--]]------------------------------------------------]]--
--	Local Values
--]]------------------------------------------------]]--

local function SendNotification(ply, msg)
	local CFG = {
		Appension = NCS_DATAPAD.CONFIG.PREFIX,
		Color = NCS_DATAPAD.CONFIG.PREFIX_C,
	}

	NCS_DATAPAD.AddText(ply, CFG.Color, "["..CFG.Appension.."] ", color_white, msg)
end

--]]------------------------------------------------]]--
--	Activate
--]]------------------------------------------------]]--

function ENT:Use(P)
    NCS_DATAPAD.IsAdmin(P, function(ACCESS)
		if ACCESS or NCS_DATAPAD.CONFIG.ArchiveAccess[team.GetName(P:Team())] then
            local PAGE = 0

            local TAB = {}

            local START = 1

            if PAGE > 0 then
                START = PAGE * 5
            end

            for i = START, ( START + 4 ) do
                table.insert( TAB, NCS_DATAPAD.E_ARCHIVED[i] )
            end

            net.Start("NS_DATAPAD_ArchiveConsole")
                net.WriteTable(TAB)
            net.Send(P)
        else
			SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_noArchiveAccess"))
        end
    end )
end