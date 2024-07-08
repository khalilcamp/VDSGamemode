SWEP.PrintName = "Pliers"
SWEP.Author =	"Joe"

SWEP.Spawnable =	true
SWEP.Adminspawnable =	false
SWEP.Category = "Joe"
SWEP.ShowWorldModel = false


SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/v_pliers.mdl"
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false
SWEP.DrawCrosshair = true

SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = true



function SWEP:PrimaryAttack()
	if not SERVER then return end
	local ply = self.Owner
	local tr = ply:GetEyeTrace()

	local ent = tr.Entity
	if not IsValid(ent) or ent:GetClass() != "joe_cable" then return end
	if ent.iscut then return end
	if not IsValid(ent.bomb) then return end
	if ent.bomb:GetBodygroup(1) == 0 then return end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )

	self:SetNextPrimaryFire(CurTime() + 2)

	ent.bomb:CableCut(ent)
	ent.iscut = true
	ent:SetModel("models/starwars_bomb/starwars_bomb_cable_cut.mdl")
	self.Owner:EmitSound("bomb/cut.mp3")
end

function SWEP:SecondaryAttack()

end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )

	self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() )

end

function SWEP:Holster()
	
	return true
end

function SWEP:OnRemove()

end
