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

    self.SavedHackText = ""
    self.SavedHackTitle = ""

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
	if not IsValid(P:GetActiveWeapon()) or P:GetActiveWeapon():GetClass() ~= "datapad_player" then
		SendNotification(P, NCS_DATAPAD.GetLang(nil, "DAP_pleaseEquipDatapad"))

		return
	end

	if not self:GetIsHacking() then
		net.Start("RDV_DATAPAD_OpenConsoleMenu")
			net.WriteEntity(self)
		net.Send(P)

		return false
	end

	local TIME_REMAINING = self:GetHackTimeRemaining()

	if self:GetIsHacking() && TIME_REMAINING <= 0 then
		if self:GetEntryTitle() == "" or self:GetEntryDescription() == "" then
			return false
		end

		P:GiveDatapadEntry(self:GetEntryTitle(), self:GetEntryDescription(), nil)

		self:SetIsHacking(false)

		return false
	end
end

function ENT:Think()
	local HACKING = self:GetIsHacking()

	if not HACKING then
		return false
	end

	local TIME_REMAINING = self:GetHackTimeRemaining()

	if not TIME_REMAINING || TIME_REMAINING == 0 || TIME_REMAINING <= 0 then
		return false
	end

	self:SetHackTimeRemaining(TIME_REMAINING - 1)

    self:NextThink( CurTime() + 1 )
    return true
end