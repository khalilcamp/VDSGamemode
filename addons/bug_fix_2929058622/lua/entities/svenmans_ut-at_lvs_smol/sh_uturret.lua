function ENT:SetPoseParameterunderturret( weapon )
	
	--if not weapon:GetAI() then return end

	if not IsValid(self:GetUnderturretSeat()) or not IsValid(self:GetUnderturretDriver()) then return end

	local Pod = self:GetUnderturretSeat()
	local Driver = self:GetUnderturretDriver()

	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local TracePlane = util.TraceLine( {
		start = EyeAngles:Up() * 100,
		endpos = (EyeAngles:Up() * 100 + EyeAngles:Forward() * 50000),
		filter = {self}
	} )

	local Pos,Ang = WorldToLocal( Vector(0,0,0), (TracePlane.HitPos):GetNormalized():Angle(), Vector(0,0,0), self:GetAngles() )
	
	Pos = Pos + Vector(-50,0,-30)

	self.Uturret_pitch = self.Uturret_pitch and math.ApproachAngle( self.Uturret_pitch, Ang.p, 100 * FrameTime() ) or 0 -- 100 * FrameTime() = aimrate
	self.Uturret_yaw = self.Uturret_yaw and math.ApproachAngle( self.Uturret_yaw, Ang.y, 100 * FrameTime() ) or 0
	
	local TargetAng = Angle(self.Uturret_pitch,self.Uturret_yaw,0)
	TargetAng:Normalize() 
	
	self:SetPoseParameter("underturret_hight", TargetAng.p )
	self:SetPoseParameter("underturret_rotation", TargetAng.y )

end


function ENT:InitUnderTurret()
	
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/hmg.png")
	weapon.Ammo = 400
	weapon.Delay = 0.3
	weapon.HeatRateUp = 0.1
	weapon.HeatRateDown = 0.2
	weapon.OnOverheat = function( ent ) end
	weapon.Attack = function( ent )
		
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetIsCarried() then ent:SetHeat( 0 ) return true end

		local ID1 = base:LookupAttachment( "underturretL" )
		local ID2 = base:LookupAttachment( "underturretR" )

		local Muzzle1 = base:GetAttachment( ID1 )
		local Muzzle2 = base:GetAttachment( ID2 )

		if not Muzzle1 or not Muzzle2 then return end
		
		local FirePos = { 
			[1] = Muzzle1,
			[2] = Muzzle2
		}

		weapon.FireIndex = weapon.FireIndex and weapon.FireIndex + 1 or 1
	
		if weapon.FireIndex > #FirePos then
			weapon.FireIndex = 1
		end
		
		if not IsValid(base:GetUnderturretDriver()) or not IsValid(base:GetUnderturretSeat()) then return end

		local Driver = base:GetUnderturretDriver()
		local Pod = base:GetUnderturretSeat()

		self:EmitSound( "ut-at_turret_fire" )

		local Pos = FirePos[weapon.FireIndex].Pos
		local Dir = FirePos[weapon.FireIndex].Ang:Up()

		local gundir = Pod:WorldToLocalAngles( Driver:EyeAngles()):Forward()
		
		if math.deg( math.acos( math.Clamp( Dir:Dot( gundir ) ,-1,1) ) ) < 1 then
			Dir = gundir
		end

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.TracerName = "lvs_laser_blue_long"
		bullet.Force	= 10
		bullet.HullSize 	= 1
		bullet.Damage	= 25
		bullet.Velocity = 40000
		bullet.Attacker 	= Driver
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
		
	end

	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
		
		if not IsValid( base ) then return end

		base:SetPoseParameterunderturret( ent )
	end

	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()
		local view = {}
		view.origin = pos
		view.angles = angles
		view.fov = fov
		view.drawviewer = false

		if not IsValid( base ) then return view end

		if not pod:GetThirdPersonMode() then
			return view
		end
		
		if pod:GetThirdPersonMode() then

			local views = Vector(0,0,0)
			local radius = 75
			local viewbone = base:GetAttachment(base:LookupAttachment( "underturretL"))

			view.origin = viewbone.Pos + Vector(0,-7.59226,-30)
			
			local Zoom = ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ZOOM )
			local Rate = FrameTime() * 5
				
			base.Zoomin = isnumber( base.Zoomin ) and base.Zoomin + math.Clamp((Zoom and 1 or 0) - base.Zoomin,-Rate,Rate) or 0
			view.fov = 75 - 30 * base.Zoomin

			radius = radius * (1 - base.Zoomin) - 10 * base.Zoomin

			view.angles.x = viewbone.Ang.z -90
			view.angles.y = viewbone.Ang.y -90


			local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
			local WallOffset = 4
			
			local tr = util.TraceHull( {
				start = view.origin,
				endpos = TargetOrigin,
				filter = function( e )
					local c = e:GetClass()
					local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS and not pod:GetParent()
					
					return collide
				end,
				mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
				maxs = Vector( WallOffset, WallOffset, WallOffset ),
			} )
			
			view.origin = tr.HitPos
			
			if tr.Hit and not tr.StartSolid then
				view.origin = view.origin + tr.HitNormal * WallOffset
			end
			
		end
		
		return view
		
	end

	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetIsCarried() then return end

		local Pos,Ang = base:GetBonePosition(base:LookupBone("underturret"))


		local startpos = Pos
		local Trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + Ang:Up() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( ent ) if ent == self or ent:GetClass() == "lunasflightschool_missile" then return false end return true end
		} )
	
		local Pos2D = Trace.HitPos:ToScreen()
			
		self:PaintCrosshairCenter( Pos2D )
		self:PaintCrosshairOuter( Pos2D )
		self:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end

	self:AddWeapon( weapon, 7 )

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/bullet.png")
	weapon.Ammo = 100
	weapon.Delay = 1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.3
	weapon.OnOverheat = function( ent ) end
	weapon.Attack = function( ent )
		
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetIsCarried() then ent:SetHeat( 0 ) return true end

		local ID1 = base:LookupAttachment( "underturretL" )
		local ID2 = base:LookupAttachment( "underturretR" )

		local Muzzle1 = base:GetAttachment( ID1 )
		local Muzzle2 = base:GetAttachment( ID2 )

		if not Muzzle1 or not Muzzle2 then return end
		local FirePos = { 
			[1] = Muzzle1,
			[2] = Muzzle2
		}

		weapon.FireIndex = weapon.FireIndex and weapon.FireIndex + 1 or 1
	
		if weapon.FireIndex > #FirePos then
			weapon.FireIndex = 1
		end
		
		if not IsValid(base:GetUnderturretDriver()) or not IsValid(base:GetUnderturretSeat()) then return end

		local Driver = base:GetUnderturretDriver()
		local Pod = base:GetUnderturretSeat()

		self:EmitSound( "ut-at_turret_fire" )

		local Pos = FirePos[weapon.FireIndex].Pos
		local Dir = FirePos[weapon.FireIndex].Ang:Up()

		local gundir = Pod:WorldToLocalAngles( Driver:EyeAngles()):Forward()
		
		if math.deg( math.acos( math.Clamp( Dir:Dot( gundir ) ,-1,1) ) ) < 1 then
			Dir = gundir
		end

		local bullet = {}
		bullet.Src 	= Pos
		bullet.Dir 	= Dir
		bullet.Spread 	= Vector( 0.01,  0.01, 0 )
		bullet.TracerName = "lvs_laser_green_short"
		bullet.Force	= 100
		bullet.HullSize 	= 30
		bullet.Damage	= 150
		bullet.SplashDamage = 25
		bullet.SplashDamageRadius = 100
		bullet.Velocity = 8000
		bullet.Attacker 	= ent:GetDriver()
		bullet.Callback = function(att, tr, dmginfo)
			local effectdata = EffectData()
				effectdata:SetStart( Vector(0,255,0) ) 
				effectdata:SetOrigin( tr.HitPos )
			util.Effect( "lvs_laser_explosion", effectdata )
		end
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetStart( Vector(50,50,255) )
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle_colorable", effectdata )

		ent:TakeAmmo()
		
	end

	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
		
		if not IsValid( base ) then return end

		base:SetPoseParameterunderturret( ent )
	end

	weapon.CalcView = function( ent, ply, pos, angles, fov, pod )
		local base = ent:GetVehicle()
		local view = {}
		view.origin = pos
		view.angles = angles
		view.fov = fov
		view.drawviewer = false

		if not IsValid( base ) then return view end

		if not pod:GetThirdPersonMode() then
			return view
		end
		
		if pod:GetThirdPersonMode() then

			local views = Vector(0,0,0)
			local radius = 75
			local viewbone = base:GetAttachment(base:LookupAttachment( "underturretL"))

			view.origin = viewbone.Pos + Vector(0,-7.59226,-30)
			
			local Zoom = ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ZOOM )
			local Rate = FrameTime() * 5
				
			base.Zoomin = isnumber( base.Zoomin ) and base.Zoomin + math.Clamp((Zoom and 1 or 0) - base.Zoomin,-Rate,Rate) or 0
			view.fov = 75 - 30 * base.Zoomin

			radius = radius * (1 - base.Zoomin) - 10 * base.Zoomin

			view.angles.x = viewbone.Ang.z -90
			view.angles.y = viewbone.Ang.y -90


			local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
			local WallOffset = 4
			
			local tr = util.TraceHull( {
				start = view.origin,
				endpos = TargetOrigin,
				filter = function( e )
					local c = e:GetClass()
					local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS and not pod:GetParent()
					
					return collide
				end,
				mins = Vector( -WallOffset, -WallOffset, -WallOffset ),
				maxs = Vector( WallOffset, WallOffset, WallOffset ),
			} )
			
			view.origin = tr.HitPos
			
			if tr.Hit and not tr.StartSolid then
				view.origin = view.origin + tr.HitNormal * WallOffset
			end
			
		end
		
		return view
		
	end

	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetIsCarried() then return end

		local Pos,Ang = base:GetBonePosition(base:LookupBone("underturret"))


		local startpos = Pos
		local Trace = util.TraceHull( {
			start = startpos,
			endpos = (startpos + Ang:Up() * 50000),
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			filter = function( ent ) if ent == self or ent:GetClass() == "lunasflightschool_missile" then return false end return true end
		} )
	
		local Pos2D = Trace.HitPos:ToScreen()
			
		self:PaintCrosshairCenter( Pos2D )
		self:PaintCrosshairOuter( Pos2D )
		self:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end

	self:AddWeapon( weapon, 7 )
	
end