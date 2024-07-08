function ENT:SetPoseParameterTurret( weapon )
	

	
	--if  not weapon:GetAI() then return end
	
	if not IsValid(self:GetTurretSeat()) or not IsValid(self:GetTurretDriver()) then return end

	local Pod = self:GetTurretSeat()
	local Driver = self:GetTurretDriver()

	local EyeAngles = Pod:WorldToLocalAngles( Driver:EyeAngles() )
	
	local TracePlane = util.TraceLine( {
		start = EyeAngles:Up() * 100,
		endpos = (EyeAngles:Up() * 100 + EyeAngles:Forward() * 50000),
		filter = {self}
	} )

	local Pos,Ang = WorldToLocal( Vector(0,0,0), (TracePlane.HitPos):GetNormalized():Angle(), Vector(0,0,0), self:GetAngles() )
	
	self.cannon_pitch = self.cannon_pitch and math.ApproachAngle( self.cannon_pitch, Ang.p, 100 * FrameTime() ) or 0 -- 100 * FrameTime() = aimrate
	self.cannon_yaw = self.cannon_yaw and math.ApproachAngle( self.cannon_yaw, Ang.y, 100 * FrameTime() ) or 0
	
	local TargetAng = Angle(Ang.p,Ang.y,0)
	TargetAng:Normalize() 

	local  pmin, pmax = self:GetPoseParameterRange(self:LookupPoseParameter( "frontcannon_pitch" ))
	local  ymin, ymax = self:GetPoseParameterRange(self:LookupPoseParameter( "frontcannon_yaw" ))

	local p = TargetAng.p or 0
	if TargetAng.p <= pmin then
			p = pmin 
	elseif TargetAng.p >= pmax then
			p = pmax
	end

	local y = TargetAng.y or 0
	if TargetAng.y <= ymin then
			y = ymin
	elseif TargetAng.y >= ymax then
			y = ymax
	end
	
	self:ManipulateBoneAngles(self:LookupBone("frontcannon"), Angle(0,0,p-1) )
	self:ManipulateBoneAngles(self:LookupBone("frontcannonrotation"), Angle(y,0,0) )
	
	self.Cable:ManipulateBoneAngles(self.Cable:LookupBone("frontcannon"), Angle(0,0,p) )
	self.Cable:ManipulateBoneAngles(self.Cable:LookupBone("frontcannonrotation"), Angle(y,0,0) )

end

function ENT:InitTurret()
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/protontorpedo.png")
	weapon.Ammo = 40
	weapon.Delay = 0.5
	weapon.HeatRateUp = 2
	weapon.HeatRateDown = 0.5
	weapon.OnOverheat = function( ent ) end
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if base:GetIsCarried() then ent:SetHeat( 0 ) return true end

		base:PlayAnimation( "frontcannon_fire" )

		local ID = base:LookupAttachment( "frontcannon" )
		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local Driver = self:GetTurretDriver()

		local projectile = ents.Create( "lvs_ut-at_missle" )
		projectile:SetPos( Muzzle.Pos )
		projectile:SetAngles( Muzzle.Ang:Up():Angle() )
		projectile:SetParent( ent )
		projectile:SetDamage(800)
		projectile:Spawn()
		projectile:Activate()
		projectile:SetAttacker( IsValid( Driver ) and Driver or self )
		projectile:SetEntityFilter( ent:GetCrosshairFilterEnts() )
		projectile:Enable()

		ent:EmitSound("ut-at_cannon_fire")
	end

	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()
		
		if not IsValid( base ) then return end

		base:SetPoseParameterTurret( ent )
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
			local radius = 1000
			local viewbone = base:GetAttachment(base:LookupAttachment( "frontcannon"))

			view.origin = viewbone.Pos + Vector(0,0,10)
			
			local Zoom = ply:KeyDown( IN_ATTACK2 ) or ply:KeyDown( IN_ZOOM )
			local Rate = FrameTime() * 5
				
			base.Zoomin = isnumber( base.Zoomin ) and base.Zoomin + math.Clamp((Zoom and 1 or 0) - base.Zoomin,-Rate,Rate) or 0
			view.fov = 75 - 30 * base.Zoomin

			radius = radius * (1 - base.Zoomin) + 100 * base.Zoomin

			view.angles.x = viewbone.Ang.z -90
			view.angles.y = viewbone.Ang.y -90


			local TargetOrigin = view.origin - view.angles:Forward() * radius  + view.angles:Up() * radius * 0.2
			local WallOffset = 4

			local tr = util.TraceHull( {
				start = view.origin,
				endpos = TargetOrigin,
				filter = function( e )
					local c = e:GetClass()
					local collide = not c:StartWith( "prop_physics" ) and not c:StartWith( "prop_dynamic" ) and not c:StartWith( "prop_ragdoll" ) and not e:IsVehicle() and not c:StartWith( "gmod_" ) and not c:StartWith( "player" ) and not e.LFS
					
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

		local ID = base:LookupAttachment( "frontcannon" )
		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local dir = Muzzle.Ang:Up()
		local pos = Muzzle.Pos

		local trace = util.TraceLine( {
			start = pos,
			endpos = (pos + dir * 50000),
			filter = function( entity ) 
				--if base:GetCrosshairFilterLookup()[ entity:EntIndex() ] or entity:GetClass():StartWith( "lvs_protontorpedo" ) then
				--	return false
				--end

				return true
			end,
		} )

		local Pos2D = trace.HitPos:ToScreen()

		self:PaintCrosshairCenter( Pos2D )
		self:PaintCrosshairOuter( Pos2D )
		self:LVSPaintHitMarker( Pos2D )
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/vehicles/atte/overheat.mp3", 85) end
	self:AddWeapon( weapon, 2 )
end