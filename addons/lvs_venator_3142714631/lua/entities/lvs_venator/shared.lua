
ENT.Base = "lvs_base_starfighter"

ENT.PrintName = "Venator II"
ENT.Author = "WioLets"
ENT.Information = "Class Star Destroyer"
ENT.Category = "[LVS] - Star Wars"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/salty/venator-class-cruiser.mdl"
ENT.GibModels = {
	"models/salty/venator-class-cruiser.mdl"
}

ENT.AITEAM = 2


ENT.MaxVelocity = 350
ENT.MaxThrust = 360

ENT.ThrustVtol = 100
ENT.ThrustRateVtol = 0.1

ENT.TurnRatePitch = 0
ENT.TurnRateYaw = 0.2
ENT.TurnRateRoll = 0

ENT.ForceLinearMultiplier = 0.4

ENT.ForceAngleMultiplier = 0.4
ENT.ForceAngleDampingMultiplier = 0.4

ENT.MaxHealth = 90000
ENT.MaxShield = 90000


function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "SecondGunnerSeat" )
	self:AddDT( "Entity", "ThirdGunnerSeat" )
	self:AddDT( "Entity", "FourthGunnerSeat" )
	self:AddDT( "Entity", "FiveGunnerSeat" )
	self:AddDT( "Entity", "SixGunnerSeat" )
	self:AddDT( "Entity", "SevenGunnerSeat" )
	self:AddDT( "Entity", "EightGunnerSeat" )
	self:AddDT( "Entity", "NineGunnerSeat" )
	self:AddDT( "Entity", "TenGunnerSeat" )
end

function ENT:GetAimAngles( ent )
    local trace = ent:GetEyeTrace()
    local AimAngles = self:WorldToLocalAngles( (trace.HitPos - self:LocalToWorld( Vector(100,300,30) ) ):GetNormalized():Angle() )

    return AimAngles
end

function ENT:WeaponsInRange( ent )
    local AimAngles = self:GetAimAngles( ent )

    return not (AimAngles.p >= 50 or AimAngles.p <= -50)
end

	
	
	
	function ENT:InitWeapons()
	
	
	
	
	
	
	
	
	
	
	

local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 2	)
	
	
	
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 3	)
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.4
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 4	)
	
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.4
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 5	)
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.2
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 6	)
	
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.2
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 7	)
	
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.05
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 8	)
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_mg.png")
		weapon.Delay = 0.80
		weapon.HeatRateUp = 0.5
		weapon.HeatRateDown = 0.05
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end


			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) >= 105 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDDorsal:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.03,  0.03, 0.03 )
			bullet.TracerName = "lvs_laser_blue"
			bullet.Force	= 10
			bullet.HullSize 	= 25
			bullet.Damage	= 50
			bullet.SplashDamage = 200
			bullet.SplashDamageRadius = 200
			bullet.Velocity = 30000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_laser_impact", effectdata )
			end

			for i = -1,1,2 do
				bullet.Src 	= ent:LocalToWorld( Vector(0,13*i,-20) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
			end

		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 9	)
	
	
	
	
	
	local weapon = {}
		weapon.Icon = Material("lvs/weapons/dual_hmg.png")
		weapon.Delay = 0.35
		weapon.HeatRateUp = 0
		weapon.HeatRateDown = 0
		weapon.Attack = function( ent )
			local pod = ent:GetDriverSeat()

			if not IsValid( pod ) then return end

			local dir = ent:GetAimVector()

			if ent:AngleBetweenNormal( dir, ent:GetUp() ) <= 70 then return true end

			local trace = ent:GetEyeTrace()

			ent.SwapTopBottom = not ent.SwapTopBottom

			local veh = ent:GetVehicle()

			veh.SNDVentral:PlayOnce( 100 + math.Rand(-3,3), 1 )

			local bullet = {}
			bullet.Spread 	= Vector( 0.15, 0, 0 )
			bullet.TracerName = "lvs_laser_blue_artilleryship"
			bullet.Force	= 4000
			bullet.HullSize 	= 100
			bullet.Damage	= 1475
			bullet.SplashDamage = 1800
			bullet.SplashDamageRadius = 700
			bullet.Velocity = 40000
			bullet.Attacker 	= ent:GetDriver()
			bullet.Callback = function(att, tr, dmginfo)
				local effectdata = EffectData()
					effectdata:SetStart( Vector(0,0,255) ) 
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				util.Effect( "lvs_artillerygun", effectdata )
			end

			
				bullet.Src 	= ent:LocalToWorld( Vector(-1200,1000,600) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
				
				
				
				
				
				bullet.Src 	= ent:LocalToWorld( Vector(-1200,-1000,600) )
				bullet.Dir = (trace.HitPos - bullet.Src):GetNormalized()

				local effectdata = EffectData()
				effectdata:SetStart( Vector(0,0,255) )
				effectdata:SetOrigin( bullet.Src )
				effectdata:SetNormal( ent:GetForward() )
				effectdata:SetEntity( ent )
				util.Effect( "lvs_muzzle_colorable", effectdata )

				ent:LVSFireBullet( bullet )
				

			
			
		end
		weapon.OnSelect = function( ent ) ent:EmitSound("physics/metal/weapon_impact_soft3.wav") end
		weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/imperial/overheat.wav") end
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
			local Col = (ent:AngleBetweenNormal( ent:GetAimVector(), ent:GetForward() ) > 60) and COLOR_RED or COLOR_WHITE

			local Pos2D = ent:GetEyeTrace().HitPos:ToScreen() 

			local base = ent:GetVehicle()
			base:PaintCrosshairCenter( Pos2D, Col )
			base:PaintCrosshairOuter( Pos2D, Col )
			base:LVSPaintHitMarker( Pos2D )
		end
	self:AddWeapon( weapon, 10 )
	
	
	
	

	
	
	
	
	
	
	end



ENT.FlyByAdvance = 0.75
ENT.FlyBySound = "lvs/vehicles/naboo_n1_starfighter/flyby.wav" 
ENT.DeathSound = "lvs/vehicles/generic_starfighter/crash.wav"

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/loop.wav",
		Pitch = 80,
		PitchMin = 0,
		PitchMax = 255,
		PitchMul = 40,
		FadeIn = 0,
		FadeOut = 1,
		FadeSpeed = 1.5,
		UseDoppler = true,
	},
}