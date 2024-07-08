include("shared.lua")
AddCSLuaFile()

function ENT:Draw()
    self:DrawModel()
end

function ENT:Initialize()
    NCS_SHARED.AddOverhead(self, {
        Accent = NCS_TRANSPORT.CONFIG.accentColor,
        Position = true, -- OBBMax or Head Position (you can also use a vector relative to the entities position.)
        Lines = {
            {
                Text = NCS_TRANSPORT.GetLang(nil, "travelVendor"), 
                Color = color_white,
                Font = "NCS_TRANSPORT_CoreOverhead",
            },
        }
    })
end

