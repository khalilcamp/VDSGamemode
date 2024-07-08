ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Datapad"
ENT.AuthorName = ""
ENT.Category = "[RDV] Datapad"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Editable = true

function ENT:SetupDataTables()
    self:NetworkVar( "String", 0, "EntryTitle", {
        KeyName = "EntryTitle",
        Edit = {
            type = "String",
        }
    })

    self:NetworkVar( "String", 1, "EntryDescription", {
        KeyName = "EntryDescription",
        Edit = {
            type = "String",
        }
    })

end