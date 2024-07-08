SWEP.PrintName = "Remote-Trigger"
SWEP.Author =	"Joe"

SWEP.Spawnable =	false
SWEP.Adminspawnable =	false
SWEP.Category = "Joe"
SWEP.ShowWorldModel = false


SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 55
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/thejoe/v_detonator.mdl"
SWEP.WorldModel = "models/thejoe/w_detonator.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.DrawCrosshair = false

SWEP.Primary.Clipsize =	-1
SWEP.Primary.DefaultClip =	-1
SWEP.Primary.Automatic =	false
SWEP.Primary.Ammo =	"none"

SWEP.Secondary.Clipsize =	-1
SWEP.Secondary.DefaultClip =	-1
SWEP.Secondary.Automatic =	false
SWEP.Secondary.Ammo =	"none"
SWEP.UseHands = true

SWEP.animinprogress = false

SWEP.state = true

function SWEP:PrimaryAttack()
	if not SERVER then return end
	local vm = self.Owner:GetViewModel()
	if vm:GetSequence() != self:LookupSequence("idle_open") then return end
	self:RunAnim("press", function()
		if not self.Owner.activebombs or table.Count(self.Owner.activebombs) <= 0 then return end
		for bomb,_ in pairs(self.Owner.activebombs) do
			if not IsValid(bomb) then continue end
			if bomb.defused then continue end
			if not bomb.activated then continue end
			bomb:Explode()
		end
	end)
	self:SetNextPrimaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	if not SERVER then return end
	if self.animinprogress then return end
	if not self.Owner.activebombs or table.Count(self.Owner.activebombs) <= 0 then return end
	local deactivate
	for bomb,_ in pairs(self.Owner.activebombs) do
		if not IsValid(bomb) then continue end
		if bomb.activated then
			bomb:DeactivateBomb()
			deactivate = true
		else
			bomb:ActivateBomb()
			deactivate = false
		end
	end
	if deactivate then
		self:RunAnim("cap_open_to_closed", function() self:RunAnim("idle_closed") end)
	elseif deactivate == false then
		self:RunAnim("cap_closed_to_open", function() self:RunAnim("idle_open") end)
	end
	self:SetNextSecondaryFire(CurTime() + 2)
	self.Owner:EmitSound("weapons/slam/mine_mode.wav")
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if not SERVER then return end
	if IsValid(self.bomb) and self.bomb.activated == false then
		self:RunAnim("idle_closed")
	else
		self:RunAnim("idle_open")
	end
end

function SWEP:RunAnim(anim,callback)
	if self.animinprogress then return end
	self.animinprogress = true
	local vm = self.Owner:GetViewModel()

	if isstring(anim) then
		anim = vm:LookupSequence( anim ) 
	end
	vm:SendViewModelMatchingSequence( anim )
	timer.Simple(self:SequenceDuration(anim), function()
		if not IsValid(self) then return end
		self.animinprogress = false
		if callback then callback() end
	end)
end

function SWEP:Holster()
	self.animinprogress = false
	return true
end

function SWEP:OnRemove()

end