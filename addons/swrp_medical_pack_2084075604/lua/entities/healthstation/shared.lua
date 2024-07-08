AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Health Station"

ENT.Spawnable = true
ENT.Category = "Server Entities"

if SERVER then
function ENT:Initialize()
    self:SetModel("models/props/starwars/medical/bacta_dispenser_small.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetModelScale(self:GetModelScale())
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
        phys:EnableMotion(false)
    end
end

function ENT:Use(activator)
	if timer.Exists("HealthKitActivator") then self:EmitSound("WallHealth.Deny") return false end
	if activator:Health() >= activator:GetMaxHealth() then self:EmitSound("WallHealth.Deny") return false end

	activator:SetHealth(math.Clamp(activator:Health() + 100, 0, activator:GetMaxHealth()))

	self:EmitSound("items/smallmedkit1.wav")

	timer.Create("HealthKitActivator", 5, 1, function() end)
end
end