AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.BaseClass.Initialize(self)

	self:SetSkin(1)
	self:SetBodygroup(1, 1)
	self:SetBodygroup(2, 1)
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

	return ent
end

function ENT:SpawnCables()
	self.BaseClass.SpawnCables(self)
	self.ready = true
end


function ENT:Defuse()
	if not self.ready then return end
	self.ready = false
	self:EmitSound("weapons/slam/mine_mode.wav")

	for v, _ in pairs(self.cables) do
		if not IsValid(v) then continue end
		v:Remove()
	end

	self:Reset()
end

function ENT:Explode()
	if not self.ready then return end
	self.ready = false
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	util.Effect("HelicopterMegaBomb", effectdata)
	util.ScreenShake(self:GetPos(), 50, 50, 2, 50)
	self:EmitSound("ambient/explosions/explode_1.wav")
	self:Reset()
end

function ENT:Reset()
	if not IsValid(self) then return end

	for v, _ in pairs(self.cables) do
		if not IsValid(v) then continue end
		v:Remove()
	end

	self.curexpected = nil
	self.cables = {}
	self.ready = false

	timer.Simple(1.5, function()
		if not IsValid(self) then return end
		self:SpawnCables()
	end)
end