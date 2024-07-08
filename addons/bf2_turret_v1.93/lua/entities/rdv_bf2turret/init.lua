AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
include('shared.lua')

hook.Add("CheckValidSit", "RDV.BF2Turret.InvalidSit", function(ply, trace)	
	local ENTITY = trace.Entity

	if !IsValid(ENTITY) then return end

	local LIST = RDV.BF2_TURRET.GetVariants()

	if IsValid(ENTITY:GetParent()) and LIST[ENTITY:GetParent():GetClass()] then
		return false
	end

	if LIST[ENTITY:GetClass()] then
		return false
	end
end)

function ENT:Initialize()
	self:SetModel( "models/reality_development/bf2_furniture/misc/misc_blaster_turret_stand.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self:SetUseType(SIMPLE_USE)

	self.phys = self:GetPhysicsObject()
	self.phys:EnableMotion(false)
	if (self.phys:IsValid()) then
		self.phys:Wake()
	end
	
	self:SetHealth(500)
	self:SetMaxHealth(500)

	self.turret = ents.Create("prop_physics")
	self.turret:SetModel("models/reality_development/bf2_furniture/misc/misc_blaster_turret_head.mdl")
	self.turret:SetPos(self:GetPos())
	self.turret:SetAngles(self:GetAngles())
	self.turret:Spawn()
	self.turret:SetHealth(self:Health())
	self.turretphys = self.turret:GetPhysicsObject()
	self.turretphys:EnableMotion(false)
	self.turretphys:Wake()
	self.turret:SetParent(self)

	local CREATION = self:GetCreationID()

	timer.Simple(0, function()
		if IsValid(self:GetDeviant_TurretOwner()) then
			self:GetDeviant_TurretOwner().PLAYER_PLACEABLE_TURRET = self
		end
	end)

	self.bullseye = ents.Create("npc_bullseye")
	self.bullseye:SetPos(self:GetPos())
	self.bullseye:SetParent(self)
	self.bullseye:SetHealth(300)
	self.bullseye:Spawn()

	self.bullseye:CallOnRemove("RDV.DESTROY_TURRET",function(ent) 
		local vPoint = self:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint )
		util.Effect( "Explosion", effectdata )

		self:EmitSound("addoncontent/turret/undeploy.wav")

		self:Remove()
	end)

	if self.O_DESTRUCT then
		timer.Simple(self.O_DESTRUCT, function()
			if IsValid(self) then
				self.bullseye:Remove()
			end
		end)
	end
	
	for k, v in ipairs(ents.GetAll()) do
		if v:IsNPC() and v:GetClass() ~= "npc_bullseye" then
			v:AddEntityRelationship( self.bullseye, D_HT, 99 )
		end
	end

	self.shootcld = 0

	RDV.BF2_TURRET.TURRETS[self] = true

	local SPEED = RDV.LIBRARY.GetConfigOption("BF2Turret_rotationSpeed")

	if SPEED then
		self.O_ROTATION = SPEED
	end

	if !self.ATTDAMAGE then
		self.ATTDAMAGE = 5
	end
end

hook.Add("PlayerSpawnedNPC", "RDV.TURRET.HATE", function(ply, ent)
	if not ent:IsNPC() then return end

	if ent:GetClass() == "npc_bullseye" then
		return
	end

	for k, v in pairs(RDV.BF2_TURRET.TURRETS) do
		if k:IsValid() and k.E_NPC[ent:GetClass()] then
			ent:AddEntityRelationship( k.bullseye, D_HT, 99 )
		end
	end
end)

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos - tr.HitNormal * 0.1
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y + 90
	
	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:SetAngles( SpawnAng )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

function ENT:OnRemove()
	if not IsValid(self.turret) then return end
	self.turret:Remove()

	RDV.BF2_TURRET.TURRETS[self] = nil
end

function ENT:FindTarget()
	local ang = self:GetAngles()
	local pos = self:GetPos()
	if not self.target then
		local l = ents.FindInCone(pos, self:GetRight():GetNormalized(), 2000, math.cos(math.rad(90)))

		for k, v in ipairs(l) do
			if IsValid(v:GetParent()) and v:GetParent():GetClass() == "rdv_bf2turret" then
				continue
			end

			if v:IsNPC() or v:IsNextBot() or v:IsVehicle() or v.LFS or v:IsPlayer() then

				local tr = util.TraceLine( {
					start = self.turret:LocalToWorld(self.turret:OBBCenter()),
					endpos = v:LocalToWorld(v:OBBCenter()),
					filter = {self.turret, self},
					mask = MASK_BLOCKLOS_AND_NPCS,
				} )

				if not tr.Entity:IsValid() or tr.Entity ~= v then
					if !v.LFS or ( v.LFS and tr.Entity ~= v:GetParent() ) then
						continue
					end
				end
				
				if self.E_VEHIC[v:GetClass()] then self.target = v end
				if IsValid(v:GetParent()) and self.E_VEHIC[v:GetParent():GetClass()] then self.target = v:GetParent() end
				if ( v:IsNPC() or v:IsNextBot() ) and self.E_NPC[v:GetClass()] then self.target = v end
				if v:IsPlayer() and self.E_TEAMS[v:Team()] then self.target = v end
			end
		end
	else
		if not IsValid(self.target) or self.target:GetPos():DistToSqr(pos) > 2000 ^ 2 or ( !self.target.LFS and self.target:Health() < 1 ) then 
			self:TargetLost()
		end
	end
end

function ENT:TargetLost()
	self.target = nil
	self.returntocenter = CurTime() + 2
end

function ENT:Think()
	self:NextThink(CurTime())

	if not IsValid(self.turret) then self:Initialize() return true end

	self:FindTarget()
	self:TurnTurret()
	self:PitchTurret()

	if not IsValid(self.target) then
		self.returntocenter = self.returntocenter or 0

		if self.returntocenter >= CurTime() then
			self.TargetAng = 0
			self.TargetPitch = 0

			return true 
		end

		local ang = self.turret:GetAngles()
		local yaw = self:WorldToLocalYaw(ang.y).y
		if math.abs(self.TargetAng) ~= 70 then
			self.TargetAng = 70
		end
		if math.abs(math.Round(yaw)) >= 70 then
			self.TargetAng = -self.TargetAng

			self:EmitSound("addoncontent/turret/enemy_ding.ogg")
		end
	else
		if !self.target.LFS and self.target:Health() < 1 then 
			return true 
		end

		local EnemyAng = (self.target:LocalToWorld(self.target:OBBCenter()) - self.turret:LocalToWorld(Vector(0, -29.738224, 29.035156))):Angle()

		self.TargetAng = math.Clamp(self:WorldToLocalYaw(EnemyAng.y).y+90, -70, 70)
		
		if math.Clamp(self:WorldToLocalYaw(EnemyAng.y).y+90, -70, 70) ~= self:WorldToLocalYaw(EnemyAng.y).y+90 then self:TargetLost() return true end


		//Why tf does it only work if use the returned roll instead of pitch lmao? well it works so it's best not to question it
		self.TargetPitch = math.Clamp(self:WorldToLocalPitch(EnemyAng.p).r, -45, 45)

		if math.Clamp(self:WorldToLocalPitch(EnemyAng.p).r, -45, 45) ~= self:WorldToLocalPitch(EnemyAng.p).r then self:TargetLost() return true end


		if CurTime() > self.shootcld then
			local pos
			
			if self.shootcycle then
				pos = self.turret:LocalToWorld(Vector(-3.009195, -29.738224, 29.035156))
			else
				pos = self.turret:LocalToWorld(Vector(3.024153, -29.738283, 28.528320))
			end

			self:FireBullets({
                Attacker = self,
                Src = pos,
                Dir = self.turret:GetRight():GetNormalized(),
                Spread = Vector(0.01,0.01,0),
                Num = 1,
                Force = 0.1,
                Tracer = 1,
                Damage = (self.ATTDAMAGE or 5),
                TracerName = "rw_sw_laser_blue",

			})
			
			if self.shootcycle then
				self.shootcycle = false
			else
				self.shootcycle = true
			end
			self:EmitSound("addoncontent/turret/fire.wav")

			self.shootcld = CurTime() + 0.2
		end

		if !self.foundSound or self.foundSound < CurTime() then

			if !self.shootcld or self.shootcld < CurTime() then
				self:EmitSound("addoncontent/turret/enemy_ding.ogg")
				self.foundSound = CurTime() + 0.07
			end
		end
	end

	return true
end

function ENT:TurnTurret()
	local ang = self.turret:GetAngles()
	local yaw = ang.y
	self.TargetAng = self.TargetAng or 0
	
	if IsValid(self.target) then
		self.turret:SetAngles(Angle(ang.r, math.ApproachAngle(yaw, self:LocalToWorldYaw(self.TargetAng).y, FrameTime()* self.O_ROTATION), ang.p))
	else
		self.turret:SetAngles(Angle(ang.r, math.ApproachAngle(yaw, self:LocalToWorldYaw(self.TargetAng).y, FrameTime()* (self.O_ROTATION * 2)), ang.p))
	end
end

function ENT:PitchTurret()
	local ang = self.turret:GetAngles()
	local pitch = ang.p
	self.TargetPitch = self.TargetPitch or 0

	self.turret:SetAngles(Angle(ang.r, ang.y, math.ApproachAngle(pitch, self.TargetPitch, FrameTime()*self.O_ROTATION)))
end

function ENT:WorldToLocalYaw(yaw)
	local pos, ang = WorldToLocal( vector_origin, Angle(0, yaw, 0), vector_origin, self:GetAngles() )
	return ang
end

function ENT:LocalToWorldYaw(yaw)
	local pos, ang = LocalToWorld( vector_origin, Angle(0, yaw, 0), vector_origin, self:GetAngles() )
	return ang
end

function ENT:WorldToLocalPitch(pitch)
	local pos, ang = WorldToLocal( vector_origin, Angle(0, 0, pitch), vector_origin, self:GetAngles() )
	return ang
end

function ENT:LocalToWorldPitch(pitch)
	local pos, ang = LocalToWorld( vector_origin, Angle(0, 0, pitch), vector_origin, self:GetAngles() )
	return ang
end

hook.Add("PlayerDisconnected", "RDV.BF2_TURRET.DISCONNECTED", function(ply)
	local TURRET = ply.PLAYER_PLACEABLE_TURRET

	if IsValid(TURRET) then
		TURRET.bullseye:Remove()
	end
end)

hook.Add("PlayerDeath", "RDV.BF2_TURRET.DEATH", function(ply)
	local TURRET = ply.PLAYER_PLACEABLE_TURRET

	if IsValid(TURRET) and TURRET.RemoveOnDeath then
		TURRET.bullseye:Remove()
	end
end)