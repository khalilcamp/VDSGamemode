SWEP.PrintName = "EMP Grenade"
SWEP.Author =	"Joe"

SWEP.Spawnable =	true
SWEP.Adminspawnable =	true
SWEP.Category = "EMP"
SWEP.ShowWorldModel = true

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.Primary.Clipsize =	1
SWEP.Primary.DefaultClip =	1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"emp_grenade"

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = true

SWEP.HoldType = "grenade"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/thejoe/v_emp.mdl"
SWEP.WorldModel = "models/thejoe/w_emp.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair = false

function SWEP:Initialize()
	self:SetHoldType("grenade")
end

function SWEP:PrimaryAttack()
	if self:Clip1() <= 0 then return end
	local ply = self.Owner
	local vm = ply:GetViewModel()
	local anim = vm:LookupSequence( "throw" )
	vm:SendViewModelMatchingSequence( anim )

	timer.Simple(vm:SequenceDuration(anim), function()
		if not IsValid(self) then return end
		if SERVER then
			ply:SetAnimation(PLAYER_ATTACK1)
			self:ThrowGrenade(5000,1,0.4)
			vm:SendViewModelMatchingSequence( 0 )
		end
	end)
	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration(anim) + 0.5)
end

function SWEP:ThrowGrenade(mul,mult1,mult2,rolled)
	local ply = self.Owner
	local ent = ents.Create( "sw_emp_grenade_ent" )
	local pos = ply:EyePos() + ply:GetRight() * 10 
	if rolled then pos = pos - ply:GetUp() * 8 end
	local aimvec = ply:EyeAngles():Forward() * mult1 + ply:EyeAngles():Up() * mult2
	
	ent:SetPos( pos )
	ent:SetAngles( ply:EyeAngles() )
	ent:SetOwner( ply )
	ent.ExplodeTimer = CurTime() + 3
	ent.isrolled = rolled and true or nil
	ent:Spawn()
	
	self:TakePrimaryAmmo(1)
	self:SetHoldType("normal")
	self:Reload()
	
	local phys = ent:GetPhysicsObject()
	if ( not phys:IsValid() ) then ent:Remove() return end
	
	aimvec:Mul( mul )
	phys:ApplyForceCenter( aimvec )
end

function SWEP:SecondaryAttack()
	if self:Clip1() <= 0 then return end
	local ply = self.Owner

	local vm = ply:GetViewModel()
	local anim = vm:LookupSequence( "throw2" )
	vm:SendViewModelMatchingSequence( anim )

	timer.Simple(vm:SequenceDuration(anim) * 0, function()
		if not IsValid(self) then return end
		if SERVER then
			ply:SetAnimation(PLAYER_ATTACK1)
			self:ThrowGrenade(1500,1,0.3,true)
			vm:SendViewModelMatchingSequence( 0 )
		end
	end)
	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration(anim) + 2)
end

function SWEP:Reload()
	if self:Clip1() > 0 then return end
	if self.Owner:GetAmmoCount("emp_grenade") <= 0 then return end
	local vm = self.Owner:GetViewModel()
	self:SetClip1(1)
	self.Owner:RemoveAmmo(1,"emp_grenade")
	self:SetHoldType("grenade")
	local anim = vm:LookupSequence( "draw" ) 
	vm:SendViewModelMatchingSequence( anim )
	self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration(anim) + 0.1)
	timer.Simple(vm:SequenceDuration(anim), function()
		if not IsValid(self) then return end
		local anim = vm:LookupSequence( "idle" ) 
		vm:SendViewModelMatchingSequence( anim )
	end)
end

function SWEP:Deploy()
	if not SERVER then return end
	if self:Clip1() <= 0 then return end
	local vm = self.Owner:GetViewModel()
	local anim = vm:LookupSequence( "draw" ) 
	vm:SendViewModelMatchingSequence( anim )

	timer.Simple(vm:SequenceDuration(anim), function()
		if not IsValid(self) then return end
		local anim = vm:LookupSequence( "idle" ) 
		vm:SendViewModelMatchingSequence( anim )
	end)
end

function SWEP:Holster()
	return true
end

function SWEP:OnRemove()
end

function SWEP:ShouldDrawViewModel()
	return self:Clip1() > 0
end

function SWEP:DrawWorldModel( flags )
	if IsValid(self.Owner) and self:Clip1() <= 0 and self.Owner:GetAmmoCount("emp_grenade") <= 0 then return end
	self:DrawModel( flags )
end