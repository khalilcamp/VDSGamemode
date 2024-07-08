include("shared.lua")
AddCSLuaFile()

local COL_GREEN = Color(0,255,0)
local COL_RED = Color(255,0,0)
local COL_OVERHEAD = Color(30,150,220)

local COL_1 = Color(0,0,0,180)
local w, h = 0, 0
local W2, H2 = 0, 0

function ENT:Draw()
    self:DrawModel()

    if self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200000 then
        return
    end

    local ENABLED = self:GetRelayEnabled()
    local COL = ENABLED and COL_GREEN or COL_RED
    local CFG = RDV.COMMUNICATIONS.S_CFG

    local ang = self:LocalToWorldAngles(Angle(0, 90, 90))
    local CENTER = self:OBBCenter()

    cam.Start3D2D(self:LocalToWorld(Vector(0, CENTER.y, self:OBBMaxs().z)) + Vector(0, 0, 10), ang, 0.1)
        draw.RoundedBox(0, -( w / 2 ), 0, w, h, COL_1)
        draw.RoundedBox(0, -( w / 2), h - (h / 12), w, (h / 12), COL_OVERHEAD)

        w, h = draw.SimpleText(RDV.LIBRARY.GetLang(nil, "COMMS_overheadName"), "RD_FONTS_CORE_OVERHEAD", 0, 0, color_white, TEXT_ALIGN_CENTER)

        if CFG.consoleHealthEnabled and self:Health() <= 0 then
            W2, H2 = draw.SimpleText("("..RDV.LIBRARY.GetLang(nil, "COMMS_damagedLabel")..")", "RD_FONTS_CORE_OVERHEAD", 0, 30, COL_RED, TEXT_ALIGN_CENTER)
        else
            local TXT = (ENABLED and RDV.LIBRARY.GetLang(nil, "COMMS_enabledLabel") or RDV.LIBRARY.GetLang(nil, "COMMS_disabledLabel"))

            W2, H2 = draw.SimpleText("("..TXT..")", "RD_FONTS_CORE_OVERHEAD", 0, 30, COL, TEXT_ALIGN_CENTER)
        end
    cam.End3D2D()

    w = w + W2 + 10
    h = h + H2 + 10
end