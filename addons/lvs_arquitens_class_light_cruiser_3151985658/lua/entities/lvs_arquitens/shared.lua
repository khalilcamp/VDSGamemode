
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "Arquitens-Class Light Cruiser (Republic)"
ENT.Author = "Dec"
ENT.Information = "Arquitens-Class Light Cruiser (Republic)"
ENT.Category = "[LVS] SW-Vehicles"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/DiggerThings/Arquitens/republic.mdl"
ENT.GibModels = {
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

ENT.MaxVelocity = 1200
ENT.MaxThrust = 1400

ENT.ThrustVtol = 55
ENT.ThrustRateVtol = 3
ENT.TurnRatePitch = 0.1
ENT.TurnRateYaw = 0.6
ENT.TurnRateRoll = 0.07

ENT.ForceLinearMultiplier = 0.5

ENT.ForceAngleMultiplier = 0.9
ENT.ForceAngleDampingMultiplier = 0.5

ENT.MaxHealth = 30000
ENT.MaxShield = 25000

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "SecondGunnerSeat" )
	self:AddDT( "Entity", "ThirdGunnerSeat" )
	self:AddDT( "Entity", "FourthGunnerSeat" )
	self:AddDT( "Entity", "FifthGunnerSeat" )
end

function ENT:GetAimAngles( ent )
    local trace = ent:GetEyeTrace()
    local AimAngles = self:WorldToLocalAngles( (trace.HitPos - self:LocalToWorld( Vector(100,300,30) ) ):GetNormalized():Angle() )

    return AimAngles
end

function ENT:WeaponsInRange( ent )
    local AimAngles = self:GetAimAngles( ent )

    return not (AimAngles.p >= 360 or AimAngles.p <= -360)
end

function ENT:AnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (40 * 0.98 - self.SMLG) * FrameTime() * 12 or 0
	
	local Ang = 0 + self.SMLG
	
	self:ManipulateBoneAngles( 34, Angle(0,Ang*2.5,0) )
	self:ManipulateBoneAngles( 36, Angle(0,Ang*2.5,0) )
	self:ManipulateBoneAngles( 38, Angle(0,-Ang*2.5,0) )

end

function ENT:BackAnimLandingGear()
	self.SMLG = self.SMLG and self.SMLG + (40 * 0.08 - self.SMLG) * FrameTime() * 12 or 0
	
	local Ang = 0 + self.SMLG
	
	self:ManipulateBoneAngles( 34, Angle(0,Ang*2.5,0) )
	self:ManipulateBoneAngles( 36, Angle(0,Ang*2.5,0) )
	self:ManipulateBoneAngles( 38, Angle(0,-Ang*2.5,0) )
end


function ENT:InitWeapons()
	self.FirePositions = {
		Vector(2900,0,-30),
	}

	self.perst = 0
	self.perst1 = 0
	self.perst2 = 0
	self.perst3 = 0

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Ammo = 1200
	weapon.Delay = 0.5
	weapon.HeatRateUp = 0.40
	weapon.HeatRateDown = .5
	weapon.Attack = function( ent )
		self.NumPrim = self.NumPrim and self.NumPrim + 1 or 1
		if self.NumPrim > 2 then self.NumPrim = 1 end

		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local startpos = pod:LocalToWorld(pod:OBBCenter() )
		local trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + ent:GetForward() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = ent:GetCrosshairFilterEnts()
		} )

		local bullet = {}
		bullet.Src 	= ent:LocalToWorld(Vector(2900,0,-30) )
		bullet.Dir 	= (trace.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0,  0.03, 0.03 )
		bullet.TracerName = "lvs_laser_green"
		bullet.Force	= 10
		bullet.HullSize 	= 40
		bullet.Damage	= 1200
		bullet.Velocity = 50000
		bullet.SplashDamage	= 100
		bullet.SplashDamageRadius	= 250
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0, 255, 0) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_concussion_explosion", effectdata )
		end

		local effectdata = EffectData()
		effectdata:SetStart( Vector(0, 255, 0) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( ent:GetForward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )
		
		ent:LVSFireBullet( bullet )

		ent:TakeAmmo()

		ent.PrimarySND:PlayOnce( 80 + math.cos( CurTime() + self:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
	end
	weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	self:AddWeapon( weapon )

	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.95
	weapon.HeatRateUp = 0.40
	weapon.HeatRateDown = 0.8
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()
		
		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 360 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		veh.SNDTail:PlayOnce( 70 + math.Rand(-3,3), 1 )

		local ID_1 = self:LookupAttachment( "7" )
		local ID_2 = self:LookupAttachment( "6" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )


		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 450
		bullet.SplashDamage	= 300
		bullet.SplashDamageRadius	= 250
		bullet.Velocity = 20000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_concussion_explosion", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnThink = function( ent, active )
		self.perst1 = self.perst1 + 1

		if self.perst1 == 4 then
			self.perst1 = 0
		end

		if self.perst1 == 0 then
			local Pod = self:GetGunnerSeat()


			if IsValid( Pod:GetDriver() ) then
		
				local weapon = Pod:lvsGetWeapon()
			
				if not IsValid( weapon ) then return end
			
				local EyeAngles = self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
			
				local Yaw = EyeAngles.y
				local Pitch =  EyeAngles.x
			
				if Pitch < -20 then 
					Pitch = -20
				end
			
				local Pitch =  -Pitch

				local Yaw =  Yaw - 180

			
				self:ManipulateBoneAngles(self:LookupBone("joint12"), Angle(0, Pitch, 0))
				self:ManipulateBoneAngles(self:LookupBone("joint3"), Angle(0, -Yaw, 0))
			end
		end
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 100
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 2 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.95
	weapon.HeatRateUp = 0.40
	weapon.HeatRateDown = 0.8
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()
		
		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 360 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		veh.SNDTail:PlayOnce( 70 + math.Rand(-3,3), 1 )

		local ID_1 = self:LookupAttachment( "3" )
		local ID_2 = self:LookupAttachment( "4" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )

		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 450
		bullet.SplashDamage	= 300
		bullet.SplashDamageRadius	= 250
		bullet.Velocity = 20000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_concussion_explosion", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnThink = function( ent, active )
		self.perst2 = self.perst2 + 1

		if self.perst2 == 4 then
			self.perst2 = 0
		end

		if self.perst2 == 0 then
			local Pod = self:GetSecondGunnerSeat()

			if IsValid( Pod:GetDriver() ) then
		
				local weapon = Pod:lvsGetWeapon()
			
				if not IsValid( weapon ) then return end
			
				local EyeAngles = self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
			
				local Yaw = EyeAngles.y
				local Pitch =  EyeAngles.x
			
				if Pitch < -20 then 
					Pitch = -20
				end
			
				local Pitch =  Pitch

				local Yaw =  Yaw - 180

			
				self:ManipulateBoneAngles(self:LookupBone("joint13"), Angle(0, Pitch, 0))
				self:ManipulateBoneAngles(self:LookupBone("joint5"), Angle(0, -Yaw, 0))
			end
		end
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 100
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 3 )
	
local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.18
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()
		
		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 360 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		veh.SNDTail:PlayOnce( 100 + math.Rand(-3,3), 1 )
		

		local trace = ent:GetEyeTrace()

		local ID_1 = self:LookupAttachment( "13" )
		local ID_2 = self:LookupAttachment( "14" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )


		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 150
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnThink = function( ent, active )

		self.perst3 = self.perst3 + 1

		if self.perst3 == 4 then
			self.perst3 = 0
		end

		if self.perst3 == 0 then
			local Pod = self:GetThirdGunnerSeat()

			if IsValid( Pod:GetDriver() ) then
			
				local weapon = Pod:lvsGetWeapon()
			
				if not IsValid( weapon ) then return end
			
				local EyeAngles = self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
			
				local Yaw = EyeAngles.y
				local Pitch =  EyeAngles.x
			
				if Pitch > 20 then 
					Pitch = 20
				end
			
				local Pitch =  -Pitch

				local Yaw =  Yaw - 180

			
				self:ManipulateBoneAngles(self:LookupBone("joint10"), Angle(0, Pitch, 0))
				self:ManipulateBoneAngles(self:LookupBone("joint2"), Angle(0, Yaw, 0))
			end
		end
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 100
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 4 )

local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.18
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()
		
		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 360 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		local trace = ent:GetEyeTrace()

		veh.SNDTail:PlayOnce( 100 + math.Rand(-3,3), 1 )

		local ID_1 = self:LookupAttachment( "9" )
		local ID_2 = self:LookupAttachment( "10" )
		local Muzzle1 = self:GetAttachment( ID_1 )
		local Muzzle2 = self:GetAttachment( ID_2 )


		ent.MirrorPrimary = not ent.MirrorPrimary

		local Pos = ent.MirrorPrimary and Muzzle1.Pos or Muzzle2.Pos
		local Dir =  (ent.MirrorPrimary and Muzzle1.Ang or Muzzle2.Ang):Up()

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 150
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnThink = function( ent, active )

		self.perst = self.perst + 1

		if self.perst == 4 then
			self.perst = 0
		end

		if self.perst == 0 then

			local Pod = self:GetFourthGunnerSeat()

			if IsValid( Pod:GetDriver() ) then
		
				local weapon = Pod:lvsGetWeapon()
			
				if not IsValid( weapon ) then return end
			
				local EyeAngles = self:WorldToLocalAngles( weapon:GetAimVector():Angle() )
			
				local Yaw = EyeAngles.y
				local Pitch =  EyeAngles.x
			
				if Pitch > 20 then 
					Pitch = 20
				end
			
				local Pitch =  Pitch

				local Yaw =  Yaw - 180
			
				self:ManipulateBoneAngles(self:LookupBone("joint11"), Angle(0, Pitch, 0))
				self:ManipulateBoneAngles(self:LookupBone("joint4"), Angle(0, Yaw, 0))
			end
		end
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 500
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 5 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Delay = 0.18
	weapon.Attack = function( ent )
        if not ent:GetVehicle():WeaponsInRange( ent ) then return true end
		local pod = ent:GetDriverSeat()

		if not IsValid( pod ) then return end

		local dir = ent:GetAimVector()
		
		if ent:AngleBetweenNormal( dir, ent:GetForward() ) > 360 then return true end

		local trace = ent:GetEyeTrace()

		ent.SwapTopBottom = not ent.SwapTopBottom

		local veh = ent:GetVehicle()

		veh.SNDTail:PlayOnce( 100 + math.Rand(-3,3), 1 )
		
		local bullet = {}
		bullet.Src = veh:LocalToWorld( Vector(-1216.4,18.25,662.18) or Vector(-1216.4,18.25,662.18))
		bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()
		bullet.Spread 	= Vector( 0.01,  0.01, 0.01 )
		bullet.TracerName = "lvs_laser_blue"
		bullet.Force	= 10
		bullet.HullSize 	= 25
		bullet.Damage	= 150
		bullet.Velocity = 30000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) ) 
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetNormal( tr.HitNormal )
			util.Effect( "lvs_laser_impact", effectdata )
		end
		ent:LVSFireBullet( bullet )
	end
	weapon.OnSelect = function( ent )
		ent:EmitSound("physics/metal/weapon_impact_soft3.wav")
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/overheat.wav")
	end
	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()

		if not IsValid( base ) then 
			return LVS:CalcView( ent, ply, pos, angles, fov, pod )
		end

		if pod:GetThirdPersonMode() then
			pos = pos + base:GetUp() * 100
		end

		return LVS:CalcView( base, ply, pos, angles, fov, pod )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 360) and COLOR_RED or COLOR_WHITE

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

		local base = ent:GetVehicle()
		base:PaintCrosshairCenter( Pos2D, Col )
		base:PaintCrosshairOuter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 6 )

end

ENT.FlyByAdvance = 0.90
ENT.FlyBySound = "lvs/vehicles/frigates/flyby.wav" 

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/frigates/loop3.wav",
		Pitch = 90,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
	},
}

sound.Add( {
	name = "arq_gear",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 125,
	sound = "lfs/consular/landing_gear.wav"
} )
