ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Command Archive Console"
ENT.AuthorName = ""
ENT.Category = "[RDV] Datapad"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Editable = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 1, "HackConsoleModel", {
        KeyName = "HackConsoleModel",
        Edit = {
            type = "String",
        }
    })

   	if SERVER then
		self:NetworkVarNotify( "HackConsoleModel", function(name, old, new)
			self:SetModel(new)
		end)
	end
end