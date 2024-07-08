AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/swcw_items/sw_datapad.mdl")
    self:SetUseType(SIMPLE_USE)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    
    self.COLLECTED = {}

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

--]]------------------------------------------------]]--
--	Local Values
--]]------------------------------------------------]]--

local COL_1 = Color(255,255,255)

local function SendNotification(ply, msg)
	local CFG = {
		Appension = NCS_DATAPAD.CONFIG.PREFIX,
		Color = NCS_DATAPAD.CONFIG.PREFIX_C,
	}

	NCS_DATAPAD.AddText(ply, CFG.Color, "["..CFG.Appension.."] ", COL_1, msg)
end

--]]------------------------------------------------]]--
--	Activate
--]]------------------------------------------------]]--

function ENT:Use(ply)
    if self.COLLECTED[ply:SteamID64()] then
        SendNotification(ply, NCS_DATAPAD.GetLang(nil, "DAP_alreadyCollected"))
        return
    end

    local TITLE = self:GetEntryTitle()
    local TEXT = self:GetEntryDescription()

    if TITLE == "" or TEXT == "" then
        return
    end

    NCS_DATAPAD.PlaySound(ply, "rdv/misc/datapad_pickup.ogg")

    ply:GiveDatapadEntry(TITLE, TEXT, nil)

    self.COLLECTED[ply:SteamID64()] = true
end 