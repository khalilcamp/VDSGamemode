AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include("shared.lua")
function ENT:Initialize()
	self:SetModel( "models/starwars_bomb/starwars_bomb_cable.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

	self.phys = self:GetPhysicsObject()
	self.phys:EnableMotion(false)
	if (self.phys:IsValid()) then
		self.phys:Wake()
	end
	self.iscut = false
end

function ENT:OnTakeDamage()
	if self.iscut then return end
	self.iscut = true
	self:SetModel("models/starwars_bomb/starwars_bomb_cable_cut.mdl")
	self.bomb:CableCut(self)
end

function ENT:Use(ply)
	self.bomb:Use(ply)
end