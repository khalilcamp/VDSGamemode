ENT.Type = "anim"
ENT.Base = "base_anim"
 
ENT.PrintName= "Deployable Turret"
ENT.Author= "Joe, Redcoder, Nicolas"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "[RDV] BF2 Turret"
ENT.AutomaticFrameAdvance = true -- Must be set on client
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.O_ROTATION = 50

ENT.O_DESTRUCT = false

ENT.ATTDAMAGE = 5

ENT.E_TEAMS = {}

ENT.E_NPC = {}

ENT.E_VEHIC = {}

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 1, "Deviant_TurretOwner")
end