
ENT.Base = "lvs_base_fakehover"
ENT.PrintName = "[LVS] UT-AT Leve"
ENT.Author = "Svenman"
ENT.Information = "The Unstable Terrain Artillery Transport (UT-AT), also known as the Trident, was a military transport and assault vehicle that served the Grand Army of the Republic during the Clone Wars when the use of walkers was unsuitable. Slow and vulnerable, the vehicle was adept at crossing bridges and traversing unstable terrain, but due to its elevated position it was constantly prone to enemy attack. Alternate configurations of the UT-AT were stocked with bridge laying equipment, converting the transport into an effective trail blazer."
ENT.Category = "[LVS] - Star Wars"

ENT.Spawnable		= true
ENT.AdminSpawnable	= false

ENT.MDL = "models/svenman/ut-at_smol/ut-at.mdl"

ENT.GibModels = {
	"models/props_c17/TrapPropeller_Engine.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/svenman/ut-at_smol/body.mdl",
	"models/gibs/helicopter_brokenpiece_01.mdl",
	"models/gibs/helicopter_brokenpiece_02.mdl",
	"models/gibs/helicopter_brokenpiece_03.mdl",
	"models/combine_apc_destroyed_gib02.mdl",
	"models/combine_apc_destroyed_gib04.mdl",
	"models/combine_apc_destroyed_gib05.mdl",
	"models/props_c17/trappropeller_engine.mdl",
	"models/gibs/airboat_broken_engine.mdl",
}

ENT.AITEAM = 2

ENT.MaxHealth = 16500

ENT.ForceAngleMultiplier = 2
ENT.ForceAngleDampingMultiplier = 1

ENT.ForceLinearMultiplier = 1
ENT.ForceLinearRate = 0.25

ENT.MaxVelocityX = 160
ENT.MaxVelocityY = 25

ENT.MaxTurnRate = 0.2

ENT.BoostAddVelocityX = 120
ENT.BoostAddVelocityY = 120

ENT.GroundTraceHitWater = true
ENT.GroundTraceLength = 50
ENT.GroundTraceHull = 100

ENT.LAATC_PICKUPABLE = true
ENT.LAATC_DROP_IN_AIR = true
ENT.LAATC_PICKUP_POS = Vector(-280,0,-150)
ENT.LAATC_PICKUP_Angle = Angle(0,0,0)


function ENT:OnSetupDataTables()
	self:AddDT( "Bool", "IsCarried" )

	self:AddDT( "Entity", "TurretDriver" )
	self:AddDT( "Entity", "TurretSeat" )

	self:AddDT( "Bool", "IsMoving" )
	self:AddDT( "Bool", "IsCarried" )
	self:AddDT( "Bool", "FrontInRange" )

	self:AddDT( "Vector", "MassCenter" )
	self:AddDT( "Vector", "DeltaV" )
	
	self:AddDT( "Entity", "TurretL1Seat" )
	self:AddDT( "Entity", "TurretL1Driver" )
	self:AddDT( "Bool", "TurretL1Fire" )
	
	self:AddDT( "Entity", "TurretL2Seat" )
	self:AddDT( "Entity", "TurretL2Driver" )
	self:AddDT( "Bool", "TurretL2Fire" )
	
	self:AddDT( "Entity", "TurretR1Seat" )
	self:AddDT( "Entity", "TurretR1Driver" )
	self:AddDT( "Bool", "TurretR1Fire" )
	
	self:AddDT( "Entity", "TurretR2Seat" )
	self:AddDT( "Entity", "TurretR2Driver" )
	self:AddDT( "Bool", "TurretR2Fire" )
	
	self:AddDT( "Entity", "UnderturretSeat" )
	self:AddDT( "Entity", "UnderturretDriver" )
	self:AddDT( "Bool", "UnderturretFire" )

	self:AddDT( "Bool", "LightsOn" )

	if SERVER then
		self:NetworkVarNotify( "IsCarried", self.OnIsCarried )
	end
end

function ENT:GetAimAngles()
	local trace = self:GetEyeTrace()

	local AimAnglesR = self:WorldToLocalAngles( (trace.HitPos - self:LocalToWorld( Vector(-452,-192,90) ) ):GetNormalized():Angle() )
	local AimAnglesL = self:WorldToLocalAngles( (trace.HitPos - self:LocalToWorld( Vector(-452,192,90) ) ):GetNormalized():Angle() )

	return AimAnglesR, AimAnglesL
end

function ENT:WeaponsInRange()
	if self:GetIsCarried() then return false end

	local AimAnglesR, AimAnglesL = self:GetAimAngles()

	return not ((AimAnglesR.p >= 4 and AimAnglesL.p >= 4) or (AimAnglesR.p <= -30 and AimAnglesL.p <= -30) or (math.abs(AimAnglesL.y) + math.abs(AimAnglesL.y)) >= 30)
end

function ENT:PlayAnimation( animation, playbackrate, ent )
	playbackrate = playbackrate or 1

	if not IsValid(ent) then
		ent = self
	end 

	local sequence = ent:LookupSequence( animation )

	ent:ResetSequence( sequence )
	ent:SetPlaybackRate( playbackrate )
	ent:SetSequence( sequence )
end


function ENT:InitWeapons()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Ammo = 600
	weapon.Delay = 0.2
	weapon.HeatRateUp = 0.25
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		if not ent:WeaponsInRange() then return true end

		local ID_L = ent:LookupAttachment( "sideturretL" )
		local ID_R = ent:LookupAttachment( "sideturretR" )
		local MuzzleL = ent:GetAttachment( ID_L )
		local MuzzleR = ent:GetAttachment( ID_R )

		if not MuzzleL or not MuzzleR then return end

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and MuzzleL.Pos or MuzzleR.Pos
		local Dir =  (ent.MirrorPrimary and MuzzleL.Ang or MuzzleR.Ang):Up()
		
		if not IsValid(self:GetDriver()) or not IsValid(self:GetDriverSeat()) then return end

		local Driver = self:GetDriver()
		local Pod = self:GetDriverSeat()


		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.TracerName = "lvs_laser_blue_long"
		bullet.Force	= 100
		bullet.HullSize 	= 1
		bullet.Damage	= 25
		bullet.Velocity = 40000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(50,50,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetStart( Vector(50,50,255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )

		ent:TakeAmmo()

		if ent.MirrorPrimary then
			ent:PlayAnimation( "sideturretL_fire" )
	
			ent:EmitSound("ut-at_turret_fire")
		end

		ent:EmitSound("ut-at_turret_fire")
		ent:PlayAnimation( "sideturretR_fire" )

		
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end


	weapon.OnThink = function( ent, active )
		if ent:GetIsCarried() then
			self:SetPoseParameter("sidecannon_pitch", 0 )

			return
		end

		if not IsValid(self:GetDriver()) then return end

		local AimAnglesR, AimAnglesL = ent:GetAimAngles()

		self:SetPoseParameter("sidecannonR_pitch",AimAnglesR.p  )
		self:SetPoseParameter("sidecannonR_yaw",AimAnglesR.y  )
		self:SetPoseParameter("sidecannonL_pitch",AimAnglesL.p  )
		self:SetPoseParameter("sidecannonL_yaw",AimAnglesL.y  )
		
	end


	self:AddWeapon( weapon )


	local weapon = {}
	weapon.Icon = Material("lvs/weapons/missile.png")
	weapon.Ammo = 60
	weapon.Delay = 1
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )
		if not ent:WeaponsInRange() then return true end

		local Driver = ent:GetDriver()

	
		if not IsValid( ent ) then return end

		if ent:GetAmmo() <= 0 then ent:SetHeat( 1 ) return end

		ent:TakeAmmo()

		local ID_L = ent:LookupAttachment( "sidecannonL" )
		local ID_R = ent:LookupAttachment( "sidecannonR" )
		local MuzzleL = ent:GetAttachment( ID_L )
		local MuzzleR = ent:GetAttachment( ID_R )

		if not MuzzleL or not MuzzleR then return end

		local FirePos = {
			[1] = MuzzleL,
			[2] = MuzzleR,
		}

		ent.MirrorPrimary = not ent.MirrorPrimary

		if ent.MirrorPrimary then
			ent.FireIndex = 2
			ent:PlayAnimation( "sidecannonR_fire" )
			
		else
			ent.FireIndex = 1
			ent:PlayAnimation( "sidecannonL_fire" )
		end

		local Pos = FirePos[ent.FireIndex].Pos
		local Dir =  FirePos[ent.FireIndex].Ang:Up()

		local AimAnglesR, AimAnglesL = ent:GetAimAngles()
		
		local effectdata = EffectData()
		effectdata:SetEntity( self )

		if self.FireIndex == 2 then
			util.Effect( "lfs_ut-at_sidecannonR_muzzle", effectdata)
			
		else
			util.Effect( "lfs_ut-at_sidecannonL_muzzle", effectdata)
		end

		if not IsValid(self:GetDriver()) or not IsValid(self:GetDriverSeat()) then return end

		local projectile = ents.Create( "lvs_protontorpedo" )
		projectile:SetPos( Pos )
		projectile:SetAngles( Dir:Angle() )
		projectile:SetParent( ent )
		projectile:SetDamage(500)
		projectile:Spawn()
		projectile:Activate()
		projectile:SetAttacker( IsValid( Driver ) and Driver or self )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
		projectile:Enable()
		
		ent:EmitSound("ut-at_cannon_fire")

		ent:SetHeat( 1 )
		ent:SetOverheated( true )
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("weapons/shotgun/shotgun_cock.wav")
	end
	self:AddWeapon( weapon )

	self:InitTurret()
	self:InitTurretL1()
	self:InitTurretL2()
	self:InitTurretR1()
	self:InitTurretR2()
	self:InitUnderTurret()
end

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/iftx/loop.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		SoundLevel = 85,
	},
	{
		sound = "lvs/vehicles/iftx/loop_hi.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
		SoundLevel = 85,
	},
	{
		sound = "^lvs/vehicles/iftx/dist.wav",
		Pitch = 70,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 30,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		SoundLevel = 90,
	},
}


sound.Add( {
	name = "ut-at_turret_fire",
	channel = CHAN_AUTO,
	volume = 0.8,
	level = 125,
	pitch = 100,
	sound = "svenman/ut-at_turret_fire.wav"
} )

sound.Add( {
	name = "ut-at_cannon_fire",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 125,
	pitch = 100,
	sound = "svenman/ut-at_cannon_fire.wav"
} )
sound.Add( {
	name = "ut-at_engine",
	channel = CHAN_AUTO,
	volume = 0.6,
	level = 125,
	pitch = 100,
	sound = "svenman/ut-at_engine.wav"
} )

ENT.ShadowParams = {
	secondstoarrive		= 0.001,
	maxangular			= 25,
	maxangulardamp		= 100000,
	maxspeed			= 1000000,
	maxspeeddamp		= 500000,
	dampfactor			= 1,
	teleportdistance	= 0,
}