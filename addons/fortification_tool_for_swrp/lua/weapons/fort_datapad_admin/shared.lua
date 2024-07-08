SWEP.PrintName = "Admin Datapad"
SWEP.Author =	"Joe"

SWEP.Spawnable =	true
SWEP.Adminspawnable =	false
SWEP.Category = "Datapads"
SWEP.ShowWorldModel = false

SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"
SWEP.Slot = 5

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = true


SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/joes/c_datapad.mdl"
SWEP.WorldModel = "models/joes/w_datapad.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair = false

function SWEP:PrimaryAttack()
	if CLIENT then JoeFort:OpenAdminFortMenu() end
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()

end

function SWEP:Initialize()

end

function SWEP:Holster()
	
	return true
end

function SWEP:OnRemove()

end
