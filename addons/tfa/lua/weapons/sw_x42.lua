SWEP.Gun							= ("sw_e5")
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "tfa_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Base							= "tfa_gun_base"
SWEP.Category						= "Ninguem Weapon Pack"
SWEP.Manufacturer 					= "Blastech Industries"
SWEP.Author							= "Kai"
SWEP.Contact						= ""
SWEP.Spawnable						= true
SWEP.AdminSpawnable					= true
SWEP.DrawCrosshair					= true
SWEP.DrawCrosshairIS 				= true
SWEP.PrintName						= "X-42 Heavy Flamethrower"
SWEP.Type							= "Heavy Flamethrower"
SWEP.DrawAmmo						= true
SWEP.data 							= {}
SWEP.data.ironsights				= nil
SWEP.Secondary.IronFOV				= 78
SWEP.Slot							= 1
SWEP.SlotPos						= 100
SWEP.FiresUnderwater 				= false

SWEP.IronInSound 					= nil
SWEP.IronOutSound 					= nil
SWEP.CanBeSilenced					= false
SWEP.Silenced 						= false
SWEP.DoMuzzleFlash 					= false
SWEP.SelectiveFire					= true
SWEP.DisableBurstFire				= false
SWEP.OnlyBurstFire					= false
SWEP.DefaultFireMode 				= "Automatic"
SWEP.FireModeName 					= nil
SWEP.DisableChambering 				= true

SWEP.Primary.ClipSize 				= -1 -- This is the size of a clip
SWEP.Primary.DefaultClip 			= 500 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.RPM					= 700
SWEP.Primary.RPM_Burst				= 300
SWEP.Primary.Ammo					= "AirboatGun"
SWEP.Primary.AmmoConsumption 		= 1
SWEP.Primary.Range 					= 20*30
SWEP.Primary.RangeFalloff 			= -1
SWEP.Primary.NumShots				= 10
SWEP.Primary.Automatic				= true
SWEP.Primary.RPM_Semi				= nil
SWEP.Primary.BurstDelay				= nil
SWEP.Primary.Sound 					= nil
SWEP.Primary.ReloadSound 			= nil
SWEP.Primary.PenetrationMultiplier 	= 0
SWEP.Primary.Damage					= 200
SWEP.Primary.HullSize 				= 0
SWEP.DamageType 					= flame

SWEP.FireModes = {
	"Auto",
}


SWEP.IronRecoilMultiplier			= 1
SWEP.CrouchRecoilMultiplier			= nil
SWEP.JumpRecoilMultiplier			= nil
SWEP.WallRecoilMultiplier			= nil
SWEP.ChangeStateRecoilMultiplier	= nil
SWEP.CrouchAccuracyMultiplier		= nil
SWEP.ChangeStateAccuracyMultiplier	= nil
SWEP.JumpAccuracyMultiplier			= nil
SWEP.WalkAccuracyMultiplier			= nil
SWEP.NearWallTime 					= 0.5
SWEP.ToCrouchTime 					= 0.1
SWEP.WeaponLength 					= 35
SWEP.SprintFOVOffset 				= 12
SWEP.ProjectileVelocity 			= nil

SWEP.ProjectileEntity 				= nil
SWEP.ProjectileModel 				= nil

SWEP.ViewModel						= "models/weapons/synbf3/c_e11.mdl"
SWEP.WorldModel						= "models/weapons/synbf3/w_e11.mdl"
SWEP.ViewModelFOV					= 70
SWEP.ViewModelFlip					= false
SWEP.MaterialTable 					= nil
SWEP.UseHands 						= true
SWEP.HoldType 						= "shotgun"
SWEP.ReloadHoldTypeOverride 		= "physgun"

SWEP.ShowWorldModel = false

SWEP.BlowbackEnabled 				= false
SWEP.BlowbackVector 				= Vector(0,-2.5,0)
SWEP.BlowbackCurrentRoot			= 0
SWEP.BlowbackCurrent 				= 0
SWEP.BlowbackBoneMods 				= nil
SWEP.Blowback_Only_Iron 			= false
SWEP.Blowback_PistolMode 			= false
SWEP.Blowback_Shell_Enabled 		= false
SWEP.Blowback_Shell_Effect 			= "None"

SWEP.Tracer							= 0
SWEP.TracerName 					= nil
SWEP.TracerCount 					= 1
SWEP.TracerLua 						= false
SWEP.TracerDelay					= 0.01
SWEP.ImpactEffect 					= nil
SWEP.ImpactDecal 					= "FadingScorch"

SWEP.VMPos = Vector(1.240, -7, -0.65)
SWEP.VMAng = Vector(0,0,0)

SWEP.IronSightTime 					= 0.6
SWEP.Primary.KickUp					= nil
SWEP.Primary.KickDown				= nil
SWEP.Primary.KickHorizontal			= nil
SWEP.Primary.StaticRecoilFactor 	= nil
SWEP.Primary.Spread					= 0.015
SWEP.Primary.IronAccuracy 			= 0.005
SWEP.Primary.SpreadMultiplierMax 	= 1.5
SWEP.Primary.SpreadIncrement 		= 0.35
SWEP.Primary.SpreadRecovery 		= 0.98
SWEP.DisableChambering 				= false
SWEP.MoveSpeed 						= 0.9
SWEP.IronSightsMoveSpeed 			= 0.8

SWEP.IronSightsPos = Vector(-4.1, 0, 1.85)
SWEP.IronSightsAng = Vector(2, 0, 0)
SWEP.RunSightsPos = Vector(5, -1, 3)
SWEP.RunSightsAng = Vector(-21, 25, -11)
SWEP.InspectPos = Vector(8, -4.8, -3)
SWEP.InspectAng = Vector(11.199, 38, 0)

SWEP.ViewModelBoneMods = {
	["v_e11_reference001"] = { scale = Vector(0.005, 0.005, 0.005), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["e5"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/btx42.mdl", bone = "v_e11_reference001", rel = "", pos = Vector(0, -11, 0), angle = Angle(0, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}

SWEP.WElements = {
	["e5"] = { type = "Model", model = "models/jajoff/sps/cgiweapons/tc13j/btx42.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-7.7, 1.9, 0), angle = Angle(-11, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}
SWEP.ThirdPersonReloadDisable		=false
SWEP.Primary.DamageType 			= DMG_BURN
SWEP.DamageType 					= DMG_BURN
SWEP.RTScopeAttachment				= -1
SWEP.Scoped_3D 						= false
SWEP.ScopeReticule 					= "scope/gdcw_elcanreticle" 
SWEP.Secondary.ScopeZoom 			= 10
SWEP.ScopeReticule_Scale 			= {2.5,2.5}
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
DEFINE_BASECLASS( SWEP.Base )
game.AddParticles("particles/mnb_flamethrower.pcf")
PrecacheParticleSystem("flamethrower")

function SWEP:Think2( ... )
	if not IsFirstTimePredicted() then
		return BaseClass.Think2(self,...)
	end
	if not self:VMIV() then return end
	if self.Shooting_Old == nil then
		self.Shooting_Old = false
	end
	local shooting = self:GetStatus() == TFA.GetStatus("shooting")
	if shooting ~= self.Shooting_Old then
		if shooting then
			self:EmitSound("Weapon_Flamethrower.in")
			self.NextIdleSound = CurTime() + 0.2
			local fx = EffectData()
			fx:SetEntity(self)
			fx:SetAttachment(1)
			util.Effect("waw_flame",fx)
			--[[
			if self:IsFirstPerson() then
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self.OwnerViewModel,1)
			else
				ParticleEffectAttach("flamethrower",PATTACH_POINT_FOLLOW,self,1)
			end
			]]--
		else
			self:EmitSound("Weapon_Flamethrower.end")
			self.NextIdleSound = -1
			self:CleanParticles()
			--self:SendViewModelAnim( ACT_VM_PRIMARYATTACK_EMPTY)
		end
	end
	if shooting then
		if self.NextIdleSound and CurTime() > self.NextIdleSound then
			self:EmitSound("Weapon_Flamethrower.loop")
			self.NextIdleSound = CurTime() + SoundDuration( "Weapon_Flamethrower.loop" ) - 0.1
		end
	end
	self.Shooting_Old = shooting
	BaseClass.Think2(self,...)
end

function SWEP:ShootEffectsCustom() end
function SWEP:DoImpactEffect() return true end
local range
local bul = {}
local function cb( a, b, c )
	if b.HitPos:Distance( a:GetShootPos() ) > range then return end
	c:SetDamageType(DMG_BURN)
	if IsValid(b.Entity) and b.Entity.Ignite and not b.Entity:IsWorld() then
		b.Entity:Ignite( c:GetDamage(), 20 )
	end
end
function SWEP:ShootBullet()
	bul.Attacker = self.Owner
	bul.Distance = self.Primary.Range
	bul.HullSize = self.Primary.HullSize
	bul.Num = 1
	bul.Damage = self.Primary.Damage * ( 160 / self.Primary.RPM )
	bul.Distance = self.Primary.Range
	bul.Tracer = 0
	bul.Callback = cb
	bul.Src = self.Owner:GetShootPos()
	bul.Dir = self.Owner:GetAimVector()
	range = bul.Distance
	self.Owner:FireBullets(bul)
end