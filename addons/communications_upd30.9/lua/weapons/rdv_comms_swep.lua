AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "Commslink"
SWEP.Author 				= "Nicolas"

SWEP.Slot 					= 0
SWEP.SlotPos 				= 99

SWEP.Spawnable 				= true
SWEP.Category 				= "[RDV] Communications"
SWEP.DrawCrosshair 			= true
SWEP.Crosshair 				= false

SWEP.HoldType 				= "normal"
SWEP.ViewModel 				= "models/weapons/c_arms.mdl"
SWEP.WorldModel 			= ""
SWEP.ViewModelFOV 			= 54
SWEP.ViewModelFlip 			= false
SWEP.UseHands 				= false

SWEP.Primary.Automatic		=  false
SWEP.Primary.Ammo			=  "none"

SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Ammo			=  "none"

SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair 			= true
SWEP.Time 					= CurTime() + 0

function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
end

function SWEP:Reload() end
function SWEP:PrimaryAttack() end
function SWEP:SecondaryAttack() end
function SWEP:OnDrop()	self:Remove() end
function SWEP:ShouldDropOnDie() self:Remove() end

if CLIENT then
	function SWEP:PrimaryAttack()
		if !IsFirstTimePredicted() then return end

		local PANEL = RDV.COMMUNICATIONS.Open()
		PANEL:ShowCloseButton(true)
		PANEL:MakePopup(true)
		PANEL:Center()
	end
end