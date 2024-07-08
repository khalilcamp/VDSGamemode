AddCSLuaFile()

SWEP.Base 					= "weapon_base"

SWEP.PrintName 				= "Turret Placer"
SWEP.Author 				= ""

SWEP.Slot 					= 0
SWEP.SlotPos 				= 99

SWEP.Spawnable 				= false
SWEP.Category 				= "[RDV] BF2 Turret"
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
SWEP.turretSpawnClass = false

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

function SWEP:Think()
	if self.Owner:KeyPressed(IN_ATTACK2) and CurTime() > self.Time then
		self.Time = CurTime() + 0.2
		if self.DrawCrosshair == true then
			self.DrawCrosshair = false
		else
			self.DrawCrosshair = true
		end
	end
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	y = y + 10
	x = x + 10
	wide = wide -20
	tall = tall -20

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( Material( "entities/"..self.ClassName..".png"))

	surface.DrawTexturedRect( x + wide/4 + 0.5,y,wide / 2,wide / 2)
end

function SWEP:PrimaryAttack()
	if SERVER then
		if !self.turretSpawnClass then return end
		
		if IsValid(self.Owner.PLAYER_TURRET) then
			return
		end

		local trace = self.Owner:GetEyeTrace()

		if trace.HitPos:DistToSqr(self.Owner:GetPos()) < 200 ^ 2 then
			local SpawnPos = trace.HitPos - trace.HitNormal * 0.1
			local SpawnAng = self.Owner:EyeAngles()
			SpawnAng.p = 0
			SpawnAng.y = SpawnAng.y + 90

			local turret = ents.Create(self.turretSpawnClass)
			turret:SetPos( SpawnPos )
			turret:SetAngles( SpawnAng )
			turret:Spawn()
			turret:SetDeviant_TurretOwner(self.Owner)

			turret:EmitSound("addoncontent/turret/turret_placement.ogg")

			self.Owner.PLAYER_TURRET = turret

			local possible = {
				"addoncontent/turret/turret_online_01.ogg",
				"addoncontent/turret/turret_online_02.ogg",
				"addoncontent/turret/turret_online_03.ogg",
			}

			self.Owner:EmitSound(possible[math.random(1, #possible)])

			self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_DROP)
		end

		self:SetNextPrimaryFire(CurTime() + 5)
	end

	return true
end

function SWEP:SecondaryAttack()
	if SERVER then
		
		local trace = self.Owner:GetEyeTrace().Entity
		
		if not IsValid(trace) then
			return
		end

		if trace:GetClass() ~= self.turretSpawnClass then
			return
		end

		if not trace:GetDeviant_TurretOwner() then
			return
		end

		if IsValid(trace) then
			trace:EmitSound("addoncontent/turret/turret_pickup.ogg")

			trace:Remove()
		end

		self:SetNextSecondaryFire(CurTime() + 5)
	end

	return true
end