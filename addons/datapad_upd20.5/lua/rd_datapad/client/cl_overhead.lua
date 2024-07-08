local SOVERHEADS = {}
local OVERHEADS = {}

surface.CreateFont("NCS_DATAPAD_OVERHEAD", {
    font = "Good Times Rg",
    extended = false,
    size = 40,
    weight = 500,
    blursize = 0,
    scanlines = 0,
    antialias = true
})

function NCS_DATAPAD.EditOverhead(ent, line, newval)
    if !OVERHEADS[ent] then return end

    local KEY = OVERHEADS[ent]
    local TAB = SOVERHEADS[KEY]

    if !TAB.Lines[line] then table.insert(TAB.Lines, newval) end

    if !TAB or !TAB.Lines or !TAB.Lines[line] then return end

    -- Improve Later
    local w, h = 0, 0

    local REMOVE = {}

    for k, v in ipairs(TAB.Lines) do
        if !v.Font then table.insert(REMOVE, k) continue end
        if !v.Text then table.insert(REMOVE, k) continue end

        surface.SetFont( v.Font )

        local nw, nh = surface.GetTextSize( v.Text )

        h = (h + nh)

        if nw > w then
            w = nw
        end
    end

    for k, v in ipairs(REMOVE) do
        table.remove(TAB.Lines, v)
    end

    TAB.w, TAB.h = (w + 20), (h + 5)
    --

    TAB.Lines[line] = newval
end

function NCS_DATAPAD.AddOverhead(ent, data)
    if !istable(data) or !data.Lines then return end
    if !data.Accent then data.Accent = Color(255,255,255) end
    if !data.Position then data.Position = true end

    if OVERHEADS[ent] then
        table.remove(SOVERHEADS, OVERHEADS[ent])
    end

    data.ENTITY = ent

    local w, h = 0, 0

    local REMOVE = {}

    for k, v in ipairs(data.Lines) do
        if !v.Font then table.insert(REMOVE, k) continue end
        if !v.Text then table.insert(REMOVE, k) continue end

        surface.SetFont( v.Font )

        local nw, nh = surface.GetTextSize( v.Text )

        h = (h + nh)

        if nw > w then
            w = nw
        end
    end

    for k, v in ipairs(REMOVE) do
        table.remove(data.Lines, v)
    end

    data.w, data.h = (w + 20), (h + 5)

    local KEY = table.insert(SOVERHEADS, data)

    OVERHEADS[ent] = KEY
end

local COL_1 = Color(0,0,0,180)
local COL_2 = Color(255,255,255)

hook.Add("PostDrawTranslucentRenderables", "NCS_DATAPAD.AddOverhead", function()
    for k, v in ipairs(SOVERHEADS) do
        local ENTITY = v.ENTITY

        if !IsValid(ENTITY) then table.remove(SOVERHEADS, k) continue end 

        if !v.Distance or !isnumber(v.Distance) then
            v.Distance = 20000
        end

        if ( ENTITY:GetPos():DistToSqr(LocalPlayer():GetPos()) > v.Distance ) then
            continue
        end

        local CENTER = ENTITY:OBBCenter()

        local w, h = (v.w or 0), (v.h or 0)

        local POS = v.Position

        if ( v.Position == true ) then
            local physBone = ENTITY:LookupBone("ValveBiped.Bip01_Head1") 
            local bone_pos
        
            if (physBone) then
                bone_pos = ENTITY:GetBonePosition(physBone) 
            end
        
            if (bone_pos) then
                POS = bone_pos + Vector(0, 0, 15) 
            else
                POS = ENTITY:LocalToWorld(Vector(CENTER.x, CENTER.y, ENTITY:OBBMaxs().z)) + Vector(0, 0, 10)
            end
        elseif isnumber(v.Position) then
            POS = ENTITY:GetPos() + Vector(0, 0, v.Position)
        end

        if !isvector(POS) then return end
        
        local ANG = Angle(0, Angle(0, (LocalPlayer():GetPos() - ENTITY:GetPos()):Angle().y + 90, 90).y, 90)

        cam.Start3D2D(POS, ANG, 0.1)
            draw.RoundedBox(0, -( w / 2 ), 0, w, h, COL_1)
            draw.RoundedBox(0, -( w / 2), h - (h / 12), w, (h / 12), v.Accent)

            for a, b in ipairs(v.Lines) do
                draw.SimpleText(b.Text, b.Font, 0, (a * 30) - 30, ( b.Color or COL_2 ), TEXT_ALIGN_CENTER)
            end
        cam.End3D2D()
    end
end )