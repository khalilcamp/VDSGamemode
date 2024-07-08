ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "cable"
ENT.Author = "Joe"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Joe"

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "UnPresetColor")
end