include("shared.lua")
AddCSLuaFile()

local COL_1 = Color(255, 255, 255)

function ENT:Draw()
    self:DrawModel()

    local VAL = false

    if self:GetEntryTitle() and self:GetEntryTitle() ~= "" then
        VAL = true
    end

    NCS_DATAPAD.EditOverhead(self, 1, {
        Text = ( VAL and string.sub(self:GetEntryTitle(), 0, 20) or "Datapad" ), 
        Color = Color(255,255,255),
        Font = "NCS_DATAPAD_OVERHEAD",
    })
end

local COL_RED = Color(255,0,0, 255)

function ENT:Initialize()
    NCS_DATAPAD.AddOverhead(self, {
        Accent = Color(30,150,220),
        Position = true, -- OBBMax or Head Position (you can also use a vector relative to the entities position.)
        Lines = {
            {
                Text = "Datapad", 
                Color = Color(255,255,255),
                Font = "NCS_DATAPAD_OVERHEAD",
            }
        }
    })
end