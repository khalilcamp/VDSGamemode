include("shared.lua")
AddCSLuaFile()

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    NCS_SHARED.AddOverhead(self, {
        Accent = NCS_PERMAWEAPONS.CFG.accent,
        Position = true, -- OBBMax or Head Position (you can also use a vector relative to the entities position.)
        Lines = {
            {
                Text = NCS_PERMAWEAPONS.GetLang(nil, "PMW_Overhead"), 
                Color = color_white,
                Font = "NCS_PMW_Overhead",
            },
        }
    })
end