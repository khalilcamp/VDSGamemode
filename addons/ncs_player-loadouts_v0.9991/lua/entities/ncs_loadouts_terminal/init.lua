AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local function SendNotification(ply, msg)
    local CFG = NCS_LOADOUTS.CONFIG
	local PC = CFG.prefixcolor
	local PT = CFG.prefixtext

    NCS_LOADOUTS.AddText(ply, Color(PC.r, PC.g, PC.b), "["..PT.."] ", color_white, msg)
end

function ENT:Initialize()
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetModel(NCS_LOADOUTS.CONFIG.vendormodel)

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:Use(P)
    local P_DATA = ( NCS_LOADOUTS.P_DATA[P:SteamID64()] or {} )

    if ( NCS_LOADOUTS.CONFIG.accessoption == 2 ) then SendNotification(P, NCS_LOADOUTS.GetLang(nil, "accessDisabled")) return end

    net.Start("NCS_LOADOUTS_MenuOpen")
        if !P_DATA.InitialCertsUpdated and P_DATA.CERTS then
            net.WriteBool(true)
            net.WriteTable(P_DATA.CERTS or {})

            P_DATA.InitialCertsUpdated = true
        else
            net.WriteBool(false)
        end
    net.Send(P)
end