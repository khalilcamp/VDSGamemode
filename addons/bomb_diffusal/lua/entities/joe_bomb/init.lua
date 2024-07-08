AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/starwars_bomb/starwars_bomb.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.phys = self:GetPhysicsObject()

	if not IsValid(self.phys) then
		-- make a sphere collider if the physics object is invalid
		self:PhysicsInitSphere(20)
		self.phys = self:GetPhysicsObject()
	end

	self.phys:EnableMotion(false)
	self.phys:Wake()
	self.timetilexplosion = false
	self.defused = false
	self.activated = false
	self.cables = {}
	self:SpawnCables()
	self:SetBodygroup(3, 1)
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if (not tr.Hit) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 10
	local SpawnAng = ply:EyeAngles()
	SpawnAng.p = 0
	SpawnAng.y = SpawnAng.y - 20
	local ent = ents.Create(ClassName)
	ent:SetPos(SpawnPos)
	ent:SetAngles(SpawnAng)
	ent:Spawn()
	ent:Activate()

	if IsValid(ply) then
		ply.lastdefbomb = ent
		net.Start("bomb_defusable_menu")
		net.Send(ply)
	end

	return ent
end

function ENT:SpawnCables()
	local tbl = table.Random(BombSystem.codes)

	for number, data in pairs(tbl) do
		local ent = ents.Create("joe_cable")
		ent:SetPos(self:LocalToWorld(data.pos))
		ent:SetAngles(self:GetAngles() - data.ang)
		ent:SetColor(BombSystem.colors[data.col])

		ent.data = {
			pos = data.pos,
			ang = data.ang
		}

		ent.cut = data.cut
		ent.bomb = self
		ent:Spawn()
		ent:Activate()
		ent:SetUnPresetColor(data.col)
		self.cables[ent] = true
		constraint.NoCollide(self, ent, 0, 0)
	end
end

function ENT:CableCut(cable)
	if self.defused then return end
	if self:GetBodygroup(1) == 0 then return end

	timer.Simple(1, function()
		if not IsValid(self) then return end

		if cable.cut == false then
			self:Explode()

			return
		end

		if not isnumber(cable.cut) then
			self:Defuse()

			return
		end

		self.curexpected = self.curexpected or 1

		if cable.cut ~= self.curexpected then
			self:Explode()

			return
		end

		for v, _ in pairs(self.cables) do
			if not v.cut or not isnumber(v.cut) then continue end

			if v.cut > self.curexpected then
				self.curexpected = self.curexpected + 1

				return
			end
		end

		self:Defuse()
	end)
end

function ENT:Use()
	if self:GetBodygroup(1) == 1 then return end
	self:SetBodygroup(1, 1)
	local ent = ents.Create("prop_physics")
	ent:SetModel("models/starwars_bomb/hatch.mdl")
	ent:SetCollisionGroup(11)
	ent:SetPos(self:LocalToWorld(Vector(-16, -4.9, 21)))
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:Activate()
	ent:GetPhysicsObject():SetVelocity(ent:GetRight() * -50 + ent:GetForward() * -50)

	timer.Simple(3, function()
		if not IsValid(ent) then return end
		ent:Remove()
	end)
end

function ENT:Defuse()
	self.defused = true
	self.activated = false
	self:SetBodygroup(3, 1)
	self:EmitSound("weapons/slam/mine_mode.wav")
end

function ENT:ActivateBomb()
	if self.defused then return end
	self.activated = true
	self:SetBodygroup(3, 0)
	self:EmitSound("weapons/slam/mine_mode.wav")
end

function ENT:DeactivateBomb()
	self.activated = false
	self:SetBodygroup(3, 1)
	self:EmitSound("weapons/slam/mine_mode.wav")
end

function ENT:HandleActivation(ply, typ, time)
	if typ == 1 and IsValid(ply) then
		ply:Give("remote_trigger")
		ply.activebombs = ply.activebombs or {}
		ply.activebombs[self] = true
	elseif typ == 2 then
		time = time or 60
		self.timetilexplosion = CurTime() + time
	end

	self:ActivateBomb()
end

function ENT:GetDistanceMult(pos)
	return pos:DistToSqr(self:GetPos()) / (BombSystem.radius ^ 2)
end

function ENT:Explode()
	if not self.activated then return end
	if self.exploding then return end
	self.exploding = true
	local pos1 = self:GetPos()
	ParticleEffect("explosion_huge", pos1, Angle(0, 0, 0))
	util.ScreenShake(self:GetPos(), 50, 50, 2, BombSystem.radius * 4)
	BombSystem:MakeBombSound(self:GetPos())
	local dmg = DamageInfo()
	dmg:SetAttacker(self)
	dmg:SetInflictor(self)

	for k, v in pairs(ents.FindInSphere(pos1, BombSystem.radius)) do
		if not IsValid(v) then continue end
		if v == self then continue end
		if v:GetClass() == "joe_cable" then continue end

		if v:GetClass() == "joe_bomb" then
			v:Explode()
			continue
		end

		local pos2 = v:GetPos()
		dmg:SetDamage(math.Clamp(BombSystem.damage - self:GetDistanceMult(pos2) * BombSystem.damage, 0, BombSystem.damage))
		dmg:SetDamageForce(-(pos1 - v:GetPos()) * (500 - self:GetDistanceMult(pos2) * 500))
		v:TakeDamageInfo(dmg)
	end

	self:Remove()
end

function ENT:OnRemove()
	for v, _ in pairs(self.cables) do
		if not IsValid(v) then continue end
		v:Remove()
	end
end

function ENT:OnTakeDamage(dmginfo)
	if self.defused then return end
	if not dmginfo:IsExplosionDamage() then return end
	self:Explode()

	return true
end

function ENT:Think()
	for v, _ in pairs(self.cables) do
		v:SetPos(self:LocalToWorld(v.data.pos))
		v:SetAngles(self:GetAngles() - v.data.ang)
	end

	self:NextThink(CurTime())
	if self.defused or self.exploding then return true end
	if not self.timetilexplosion then return true end

	if self.timetilexplosion < CurTime() then
		self:Explode()

		return
	end
end