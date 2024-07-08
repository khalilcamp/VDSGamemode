surface.CreateFont("RDV_EVENTSYS_LABEL", {
	font = "Open Sans SemiBold",
	extended = false,
	size = ScrW() * 0.01,
})

local CLOCK = Material("rdv/objectives/clock.png", 'smooth')
local HEART = Material("rdv/objectives/heart.png", 'smooth')
local BACK = Material("rdv/objectives/background.png", 'smooth')

local function CreateDivider(PANEL, SP, TEXT)
	local w, h = PANEL:GetSize()

    local TLABEL = SP:Add("DLabel")
    TLABEL:Dock(TOP)
    TLABEL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    TLABEL:SetText(TEXT)
    TLABEL:SetFont("RDV_EVENTSYS_LABEL")
    TLABEL:SetTextColor(COL_1)
	TLABEL:SetMouseInputEnabled(true)
    TLABEL:SetAutoStretchVertical(true)
    TLABEL:SetTextColor(color_white)
    TLABEL.DoClick = function() end
end

net.Receive("RDV_EVENTS_OpenMenu", function()
    local OPTIONS = net.ReadTable()
    
    local F = vgui.Create("PIXEL.Frame")
    F:SetSize(ScrW() * 0.3, ScrH() * 0.5)
    F:Center()
    F:MakePopup(true)
    F:SetTitle(RDV.LIBRARY.GetLang(nil, "EVENT_addonLabel"))

    local SIDEBAR = F:CreateSidebar("livesCounter", nil)

    local P = vgui.Create("DPanel", F)
    P:Dock(FILL)
    P.Paint = function() end

    SIDEBAR:AddItem("livesCounter", RDV.LIBRARY.GetLang(nil, "EVENT_livesAndTimer"), "7SbRQJN", function()
        local DATA = table.Copy(RDV.EVENTS.LIVES)

        P:Clear()

        local w, h = F:GetSize()

        local SCROLL = vgui.Create("DScrollPanel", P)
        SCROLL:Dock(FILL)

        --[[
        --  Lives
        --]]

        local LIVES_C = vgui.Create( "PIXEL.Category", SCROLL )
        LIVES_C:Dock(TOP)
        LIVES_C:SetTitle( RDV.LIBRARY.GetLang(nil, "EVENT_livesCounter") )
        LIVES_C:DockPadding(w * 0.01, h * 0.01, w * 0.01, h * 0.01)

        CreateDivider(F, LIVES_C, RDV.LIBRARY.GetLang(nil, "EVENT_livesCount"))

        local LIVES = vgui.Create("DNumSlider", LIVES_C)
        LIVES:Dock(TOP)
        LIVES:SetMax(10000)
        LIVES:SetDecimals(0)
        LIVES.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end
        LIVES.OnValueChanged = function(s)
            DATA.LivesCount = s:GetValue()
        end

        if DATA.LivesCount then
            LIVES:SetValue(DATA.LivesCount)
        end
        
        CreateDivider(F, LIVES_C, RDV.LIBRARY.GetLang(nil, "EVENT_spawnNoLives"))

        local LABEL = vgui.Create("DLabel", LIVES_C)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end


        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
        

        local CHECK_LV = vgui.Create("PIXEL.Checkbox", CHECK_L)
        CHECK_LV:SetPos( (CHECK_L:GetWide() * 0.5 ) - ( CHECK_LV:GetWide() / 2 ) , ( CHECK_L:GetTall() * 0.5 ) + ( CHECK_LV:GetTall() / 2 ) )
        CHECK_LV.PaintOver = function(s, val)
            DATA.LivesSpawnEnabled = s:GetToggle()
        end
        CHECK_LV:SetMouseInputEnabled(true)

        if DATA and DATA.LivesSpawnEnabled then
            CHECK_LV:SetToggle(true)
        end

        --[[
        --  Timer
        --]]
        

        local LIVES_T = vgui.Create( "PIXEL.Category", SCROLL )
        LIVES_T:Dock(TOP)
        LIVES_T:SetTitle( RDV.LIBRARY.GetLang(nil, "EVENT_timerLabel") )
        LIVES_T:DockPadding(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        
        CreateDivider(F, LIVES_T, RDV.LIBRARY.GetLang(nil, "EVENT_timerLength"))

        local TIMER = vgui.Create("DNumSlider", LIVES_T)
        TIMER:Dock(TOP)
        TIMER:SetMax(10000)
        TIMER:SetDecimals(0)
        TIMER.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end
        TIMER.OnValueChanged = function(s)
            DATA.TimerCount = s:GetValue()
        end

        if DATA.TimerCount then
            TIMER:SetValue(DATA.TimerCount)
        end

        CreateDivider(F, LIVES_T, RDV.LIBRARY.GetLang(nil, "EVENT_spawnNoTime"))

        local LABEL = vgui.Create("DLabel", LIVES_T)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.1)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end


        local CHECK_L = vgui.Create("DLabel", LABEL)
        CHECK_L:SetMouseInputEnabled(true)
        CHECK_L:Dock(RIGHT)
        CHECK_L:SetText("")
        

        local CHECK_TM = vgui.Create("PIXEL.Checkbox", CHECK_L)
        CHECK_TM:SetPos( (CHECK_L:GetWide() * 0.5 ) - ( CHECK_TM:GetWide() / 2 ) , ( CHECK_L:GetTall() * 0.5 ) + ( CHECK_TM:GetTall() / 2 ) )
        CHECK_TM.PaintOver = function(s, val)
            DATA.TimerSpawnEnabled = s:GetToggle()
        end
        CHECK_TM:SetMouseInputEnabled(true)

        if DATA and DATA.TimerSpawnEnabled then
            CHECK_TM:SetToggle(true)
        end

        local SEND = vgui.Create("PIXEL.TextButton", P)
        SEND:Dock(BOTTOM)
        SEND:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_setLabel"))
        SEND:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        SEND.DoClick = function()
            net.Start("RDV_EVENTS_UpdateLives")
                net.WriteUInt( ( DATA.LivesCount or 0 ), 32)
                net.WriteBool( DATA.LivesSpawnEnabled )
                net.WriteUInt( ( DATA.TimerCount or 0 ), 32)
                net.WriteBool( DATA.TimerSpawnEnabled )
            net.SendToServer()
        end
    end )

    SIDEBAR:AddItem("otherOptions", RDV.LIBRARY.GetLang(nil, "EVENT_otherOptions"), "xxqWQb8", function()
        P:Clear()

        local w, h = F:GetSize()

        local SCROLL = vgui.Create("DScrollPanel", P)
        SCROLL:Dock(FILL)

        CreateDivider(F, SCROLL, RDV.LIBRARY.GetLang(nil, "EVENT_toggleLocked"))

        local LABEL = vgui.Create("DLabel", SCROLL)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.075)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end


        local LOCK = vgui.Create("PIXEL.TextButton", LABEL)
        LOCK:SetMouseInputEnabled(true)
        LOCK:Dock(RIGHT)
        LOCK:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        LOCK.DoClick = function(s)
            if OPTIONS.DoorsLocked then
                LOCK:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
            else
                LOCK:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
            end

            OPTIONS.DoorsLocked = !OPTIONS.DoorsLocked
        end 

        if OPTIONS.DoorsLocked then
            LOCK:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
        else
            LOCK:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
        end

        CreateDivider(F, SCROLL, RDV.LIBRARY.GetLang(nil, "EVENT_jamWeapons"))

        local LABEL = vgui.Create("DLabel", SCROLL)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.075)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end

        local JAMMING = vgui.Create("PIXEL.TextButton", LABEL)
        JAMMING:SetMouseInputEnabled(true)
        JAMMING:Dock(RIGHT)
        JAMMING:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        JAMMING.DoClick = function(s)
            if OPTIONS.WepJammed then
                JAMMING:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
            else
                JAMMING:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
            end

            OPTIONS.WepJammed = !OPTIONS.WepJammed
        end 

        if OPTIONS.WepJammed then
            JAMMING:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
        else
            JAMMING:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
        end

        --[[
        --  Flashlight Disabled
        --]]

        CreateDivider(F, SCROLL, RDV.LIBRARY.GetLang(nil, "EVENT_flashlightDisabled"))

        local LABEL = vgui.Create("DLabel", SCROLL)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.075)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end

        local FLASHLIGHT = vgui.Create("PIXEL.TextButton", LABEL)
        FLASHLIGHT:SetMouseInputEnabled(true)
        FLASHLIGHT:Dock(RIGHT)
        FLASHLIGHT:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        FLASHLIGHT.DoClick = function(s)
            if OPTIONS.FlashlightDisabled then
                FLASHLIGHT:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
            else
                FLASHLIGHT:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
            end

            OPTIONS.FlashlightDisabled = !OPTIONS.FlashlightDisabled
        end 

        if OPTIONS.FlashlightDisabled then
            FLASHLIGHT:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
        else
            FLASHLIGHT:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
        end

        --[[
        --  Spawn on Command Post
        --]]

        CreateDivider(F, SCROLL, RDV.LIBRARY.GetLang(nil, "EVENT_commandPostSpawn"))

        local LABEL = vgui.Create("DLabel", SCROLL)
        LABEL:SetText("")
        LABEL:SetHeight(h * 0.075)
        LABEL:Dock(TOP)
        LABEL:SetMouseInputEnabled(true)
        LABEL.Paint = function(s, w, h)
            local COL = PIXEL.CopyColor(PIXEL.Colors.Header)

            draw.RoundedBox(5, 0, 0, w, h, COL)
        end

        local COMMANDPOST = vgui.Create("PIXEL.TextButton", LABEL)
        COMMANDPOST:SetMouseInputEnabled(true)
        COMMANDPOST:Dock(RIGHT)
        COMMANDPOST:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
        COMMANDPOST.DoClick = function(s)
            if OPTIONS.commandPostSpawn then
                COMMANDPOST:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
            else
                COMMANDPOST:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
            end

            OPTIONS.commandPostSpawn = !OPTIONS.commandPostSpawn
        end 

        if OPTIONS.commandPostSpawn then
            COMMANDPOST:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_disableLabel"))
        else
            COMMANDPOST:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_enableLabel"))
        end

        local BUTTON = vgui.Create("PIXEL.TextButton", P)
        BUTTON:Dock(BOTTOM)
        BUTTON:SetText(RDV.LIBRARY.GetLang(nil, "EVENT_setLabel"))
        BUTTON.DoClick = function()
            net.Start("RDV_EVENTS_OptionsUpdated")
                net.WriteTable(OPTIONS)
            net.SendToServer()
        end
    end )
end )

local lastTick = 0

net.Receive("RDV_EVENTS_UpdateLives", function()
    local LivesCount = net.ReadUInt(32)
    local LivesSpawnEnabled = net.ReadBool()
    local TimerCount = net.ReadUInt(32)
    local TimerSpawnEnabled = net.ReadBool()

    RDV.EVENTS.LIVES = {
        LivesSpawnEnabled = LivesSpawnEnabled,
        LivesCount = LivesCount,
        TimerSpawnEnabled = TimerSpawnEnabled,
        TimerCount = TimerCount,
        MaxLives = LivesCount,
        MaxTimer = TimerCount,
    }

    lastTick = CurTime() + 1
end )

hook.Add("Think", "RDV_EVENTS_Think", function()
    if lastTick and lastTick > CurTime() then return end

    local DATA = RDV.EVENTS.LIVES
    if !DATA.TimerCount then return end

    DATA.TimerCount = math.max(DATA.TimerCount - 1, 0)

    lastTick = CurTime() + 1
end )

local C_BLUE = Color(50, 105, 168, 200)
local C_RED = Color(255,0,0, 200)

hook.Add("HUDPaint", "RDV_EVENTS_HUD", function()
    local AD = RDV.EVENTS.CFG.ADJUST

    local DATA = RDV.EVENTS.LIVES

    local MAXL = DATA.MaxLives
    local LIVES = ( DATA.LivesCount or 0 )

    local W, H = ScrW(), ScrH()

    --[[-------------------------------
        Lives
    --]]-------------------------------
    
    local MOVE = false
    if MAXL and ( MAXL > 0 ) and LIVES and isnumber(LIVES) then
        local LPER = (LIVES / MAXL) * 100

            --Background
        surface.SetDrawColor(color_white)
        surface.SetMaterial(BACK)
        surface.DrawTexturedRect(W * 0.01 + (W * AD.W), (H * 0.01) + (H * AD.H), W * 0.1, H * 0.025)

        surface.SetDrawColor(C_RED)
        surface.DrawRect(W * 0.01 + (W * AD.W), (H * 0.01) + (H * AD.H), W * 0.001 * LPER / 100 * 100, H * 0.025)


        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(W * 0.01 + (W * AD.W), (H * 0.01) + (H * AD.H), W * 0.1, H * 0.025)

        surface.SetDrawColor(color_white)
            surface.SetMaterial(HEART)
        surface.DrawTexturedRect(W * 0.0125 + (W * AD.W), (H * 0.012) + (H * AD.H), W * 0.01, H * 0.02)

        draw.SimpleText(LIVES.." / "..MAXL, "RDV_EVENTSYS_LABEL", W * 0.12 + (W * AD.W), (H * 0.02) + (H * AD.H), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    else
        MOVE = true
    end

    
    --[[-------------------------------
        Timer
    --]]-------------------------------

    local TIMER = ( DATA.TimerCount or 0 )
    local MAXT = DATA.MaxTimer

    if MAXT and ( MAXT > 0 ) and TIMER and isnumber(TIMER) then
        local TPER = (TIMER / MAXT) * 100
        
        surface.SetDrawColor(color_white)
        surface.SetMaterial(BACK)
        surface.DrawTexturedRect(W * 0.01 + (W * AD.W), (H * (MOVE and 0.01 or 0.04)) + (H * AD.H), W * 0.1, H * 0.025)
        
        surface.SetDrawColor(C_BLUE)
        surface.DrawRect(W * 0.01 + (W * AD.W), (H * (MOVE and 0.01 or 0.04)) + (H * AD.H), W * 0.001 * TPER / 100 * 100, H * 0.025)

        surface.SetDrawColor(color_white)
        surface.DrawOutlinedRect(W * 0.01 + (W * AD.W), (H * (MOVE and 0.01 or 0.04)) + (H * AD.H), W * 0.1, H * 0.025)

        surface.SetDrawColor(color_white)
            surface.SetMaterial(CLOCK)
        surface.DrawTexturedRect(W * 0.0125 + (W * AD.W), (H * (MOVE and 0.012 or 0.042)) + (H * AD.H), W * 0.01, H * 0.02)

        draw.SimpleText(math.Clamp(TIMER, 0, 9999), "RDV_EVENTSYS_LABEL", W * 0.12 + (W * AD.W), (H * (MOVE and 0.02 or 0.05)) + (H * AD.H), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

end)