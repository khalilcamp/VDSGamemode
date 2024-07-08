AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/heracles421/galactica_vehicles/mtt.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	//self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:EnableGravity(false)
	end

	self.ShadowParams = {}
	self:StartMotionController()

	local tr = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() + self:GetAngles():Forward() * 200,
		filter = self
	} )

	self.TargetPos = tr.HitPos
end

function ENT:PhysicsSimulate(phys, deltatime)
	phys:Wake()

	if self:GetPos():DistToSqr(self.TargetPos) < 10*10 then
		self.TargetPos = self:GetPos()

		if not self.Deployed then
			self:Deploy()
		end
		self.Deployed = true
	end

	self.ShadowParams.secondstoarrive = 1
	self.ShadowParams.pos = self.TargetPos
	self.ShadowParams.angle = self:GetAngles()
	self.ShadowParams.maxangular = 5000
	self.ShadowParams.maxangulardamp = 10000
	self.ShadowParams.maxspeed = 1000000
	self.ShadowParams.maxspeeddamp = 10000
	self.ShadowParams.dampfactor = 0.8
	self.ShadowParams.teleportdistance = 0
	self.ShadowParams.deltatime = deltatime
 
	phys:ComputeShadowControl(self.ShadowParams)
end

function ENT:AimGuns()
	local enemy = self:FindEnemy()
	if IsValid(enemy) then

		local ID1 = self:LookupAttachment( "muzzle_right_top" )
		local ID2 = self:LookupAttachment( "muzzle_right_bottom" )
		local ID3 = self:LookupAttachment( "muzzle_left_top" )
		local ID4 = self:LookupAttachment( "muzzle_left_bottom" )

		local Muzzle1 = self:GetAttachment( ID1 )
		local Muzzle2 = self:GetAttachment( ID2 )
		local Muzzle3 = self:GetAttachment( ID3 )
		local Muzzle4 = self:GetAttachment( ID4 )

		if not Muzzle1 or not Muzzle2 or not Muzzle3 or not Muzzle4 then return end

		local AimAnglesR = self:WorldToLocalAngles( (enemy:GetPos() - Muzzle1.Pos ):GetNormalized():Angle() )
		local AimAnglesL = self:WorldToLocalAngles( (enemy:GetPos() - Muzzle3.Pos ):GetNormalized():Angle() )

		self:SetPoseParameter("right_gun_pitch", AimAnglesR.p )
		self:SetPoseParameter("right_gun_yaw", AimAnglesR.y )

		self:SetPoseParameter("left_gun_pitch", AimAnglesL.p )
		self:SetPoseParameter("left_gun_yaw", AimAnglesL.y )
	end
end

function ENT:Shoot()
	if (self.NextShot or 0) < CurTime() then
		local enemy = self:FindEnemy()
		if IsValid(enemy) then

			local ID1 = self:LookupAttachment( "muzzle_right_top" )
			local ID2 = self:LookupAttachment( "muzzle_right_bottom" )
			local ID3 = self:LookupAttachment( "muzzle_left_top" )
			local ID4 = self:LookupAttachment( "muzzle_left_bottom" )

			local Muzzle1 = self:GetAttachment( ID1 )
			local Muzzle2 = self:GetAttachment( ID2 )
			local Muzzle3 = self:GetAttachment( ID3 )
			local Muzzle4 = self:GetAttachment( ID4 )

			if not Muzzle1 or not Muzzle2 or not Muzzle3 or not Muzzle4 then return end

			self.Mirror = not self.Mirror

			local gunAttachment = self.Mirror and Muzzle1 or Muzzle3

			local tr = util.TraceHull( {
				start = gunAttachment.Pos,
				endpos = gunAttachment.Pos + (enemy:LocalToWorld(enemy:OBBCenter()) - gunAttachment.Pos):GetNormalized() * 5000,
				filter = self,
				mins = Vector( -5, -5, -5 ),
				maxs = Vector( 5, 5, 5 ),
			} )

			if tr.Hit and (tr.Entity != enemy) then return end

			local ent = ents.Create("turbolaser")
			ent:SetKeyValue("Force", 5000)
			ent:SetKeyValue("Damage", 150)
			ent:SetKeyValue("Magnitude", 100)
		    ent:SetKeyValue("Colour", "Red")

			ent:SetPos( gunAttachment.Pos + self:GetForward() * 50 )
			ent:SetAngles( (enemy:LocalToWorld(enemy:OBBCenter()) - gunAttachment.Pos):Angle() )
			ent:Spawn()
			ent:Activate()

			self.NextShot = CurTime() + 1
		end
	end
end

function ENT:Think()
	self:Shoot()
	self:AimGuns()

	self:NextThink( CurTime() ) 
	return true
end

function ENT:PlayAnimation( animation, playbackrate )
	playbackrate = playbackrate or 1
	
	local anims = string.Implode( ",", self:GetSequenceList() )
	
	if not animation or not string.match( string.lower(anims), string.lower( animation ), 1 ) then return end
	
	local sequence = self:LookupSequence( animation )
	
	self:ResetSequence( sequence )
	self:SetPlaybackRate( playbackrate )
	self:SetSequence( sequence )
end

function ENT:Deploy()
	self:PlayAnimation("deploy_transport", 1)

	-- Primeira chamada de spawn após 10 segundos
	timer.Simple(10, function()
		if not IsValid(self) then return end
		self:SpawnNPCs()
	end)

	-- Cria um cronômetro para spawnar NPCs a cada 30 segundos após a primeira chamada
	timer.Create("SpawnNPCsTimer" .. self:EntIndex(), 30, 0, function()
		if not IsValid(self) then timer.Remove("SpawnNPCsTimer" .. self:EntIndex()) return end
		self:SpawnNPCs()
	end)
end

function ENT:SpawnNPCs()
	for i = 1, 12 do
		local ID = self:LookupAttachment("seat_00" .. ((i - 1) % 10 + 1))
		local Seat = self:GetAttachment(ID)

		if Seat then
			local Pos, Ang = LocalToWorld(Vector(10, -10, 0), Angle(90, 0, -90), Seat.Pos, Seat.Ang)
			if i >= 7 then
				Pos, Ang = LocalToWorld(Vector(-10, -10, 0), Angle(-90, 0, -90), Seat.Pos, Seat.Ang)
			end

			Pos = Pos + Vector(0, 0, (i % 2 == 0) and 0 or 15)

			local ent = ents.Create("dane_b1")
			ent:SetPos(Pos + Vector(15, 0, 0))
			ent:SetAngles(Ang)
			ent:Spawn()
		end
	end
end

function ENT:FindEnemy()
	local bestEnt
	local bestDist = 5000*5000
	for _, ply in ipairs(ents.FindInCone( self:GetPos(), self:GetAngles():Forward(), 5000, 0.9 )) do
		if not IsValid(ply) or not ply:IsPlayer() or ply:IsFlagSet( FL_NOTARGET ) then continue end

		if self:GetPos():DistToSqr(ply:GetPos()) < bestDist then
			bestEnt = ply
			bestDist = self:GetPos():DistToSqr(ply:GetPos())
		end
	end
	return bestEnt
end