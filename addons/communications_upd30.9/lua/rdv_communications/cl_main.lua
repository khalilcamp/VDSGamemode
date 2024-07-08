surface.CreateFont( "RDV_COMMUNICATIONS_FontSmall", {
	font = "Montserrat",
    size = ScrW() * 0.009,
    antialias = true,
    extended = true,
} )

surface.CreateFont("RDV_COMMUNICATIONS_LABEL", {
	font = "Bebas Neue",
	extended = false,
	size = ScrW() * 0.0135,
})

--[[
--  Local Vars
--]]

local MUTED = false
local COMPLETE = false
local WAITING = false

local COL_1 = Color(0, 0, 0, 100)
local COL_3 = Color(41, 128, 185)
local COL_RED = Color(255,0,0)
local COL_OUTLINE = Color(122,132,137, 180)

--[[
--  Local Materials
--]]

local MIC_ICON = Material("rdv/communications/rdv_microphone.png", 'smooth')
local SPEAKER_ICON = Material("rdv/communications/speaker.png", 'smooth')
local ICON = Material("rdv/communications/rdv_person.png", 'smooth')

--[[
--  Local Functions
--]]

local function SendNotification(ply, msg)
    local CFG = RDV.COMMUNICATIONS.S_CFG
    local COL = Color(CFG.chatColor.r, CFG.chatColor.g, CFG.chatColor.b)

    RDV.LIBRARY.AddText(ply, COL, "["..CFG.chatPrefix.."] ", color_white, msg)
end

local blur = Material("pp/blurscreen")

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(color_white)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

function RDV.COMMUNICATIONS.Open(context)
    RDV.COMMUNICATIONS = RDV.COMMUNICATIONS or {}
    RDV.COMMUNICATIONS.OCCUPANTS = RDV.COMMUNICATIONS.OCCUPANTS or {}

    if IsValid(RDV.COMMUNICATIONS.PANEL) then
        RDV.COMMUNICATIONS.PANEL:Remove()
    end
    
    if context then
        if IsValid(RDV.COMMUNICATIONS.IDENT) then
            RDV.COMMUNICATIONS.IDENT:SetVisible(false)
        end
    end

    local w, h = ScrW(), ScrH()

    local COUNT = 0

    local commsLabel = RDV.LIBRARY.GetLang(nil, "COMMS_communicationsLabel")

    local PANEL = vgui.Create("DFrame")
    if context then
        PANEL:SetParent(g_ContextMenu)
    end
    PANEL:SetSize(w * 0.175, h * 0.4)
    PANEL:SetTitle("")
    PANEL:SetPos(w * 0.82, h * 0.04)
    PANEL:SetMouseInputEnabled(true)
    PANEL.Paint = function(self, w, h)
        DrawBlur(self, 6)

        surface.SetDrawColor( COL_OUTLINE )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.RoundedBox(0, 0, 0, w, h, COL_1)

        draw.SimpleText(commsLabel, "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.035, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    RDV.COMMUNICATIONS.PANEL = PANEL

    local w, h = PANEL:GetSize()

    local noChannels = RDV.LIBRARY.GetLang(nil, "COMMS_noChannels")
    local arrayOffline = RDV.LIBRARY.GetLang(nil, "COMMS_arrayOffline")

    local SCROLL = vgui.Create("RDV_LIBRARY_SCROLL", PANEL)
    SCROLL:DockMargin(w * 0.02, h * 0.02, w * 0.0225, h * 0.025)

    SCROLL:Dock(FILL)
    SCROLL.Paint = function(self, w, h)
        surface.SetDrawColor( COL_OUTLINE )
        surface.DrawOutlinedRect( 0, 0, w, h )

        if !RDV.COMMUNICATIONS.GetCommsEnabled(LocalPlayer()) then
            draw.SimpleText(arrayOffline, "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.4, COL_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        elseif COUNT <= 0 then
            draw.SimpleText(noChannels, "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    local MUTE = vgui.Create("DButton", PANEL)
    MUTE:Dock(BOTTOM)

    local TEXT = MUTED and RDV.LIBRARY.GetLang(nil, "COMMS_unmuteLabel") or RDV.LIBRARY.GetLang(nil, "COMMS_muteLabel")

    MUTE:SetText(TEXT)

    MUTE:DockMargin(0, 0, 0, h * 0.025)
    MUTE:SetFont("RDV_LIB_FRAME_TITLE")
    MUTE:SetTextColor(color_white)
    MUTE.DoClick = function()
        net.Start("RDV_COMMS_MUTE")
        net.SendToServer()

        MUTED = !MUTED

        local MUTED = MUTED
        local TEXT = MUTED and RDV.LIBRARY.GetLang(nil, "COMMS_unmuteLabel") or RDV.LIBRARY.GetLang(nil, "COMMS_muteLabel")

        MUTE:SetText(TEXT)

        if MUTED then
            SendNotification(LocalPlayer(), RDV.LIBRARY.GetLang(nil, "COMMS_mutedText"))
        else
            SendNotification(LocalPlayer(), RDV.LIBRARY.GetLang(nil, "COMMS_unmutedText"))
        end

        surface.PlaySound("reality_development/ui/ui_accept.ogg")
    end
    MUTE.Paint = function() end
    MUTE.OnCursorEntered = function(self)
        surface.PlaySound("reality_development/ui/ui_hover.ogg")

        self:SetTextColor(COL_3)
    end
    MUTE.OnCursorExited = function(self)
        self:SetTextColor(color_white)
    end

    local ROTATE = {
        [1] = Color(70, 70, 70, 70),
        [2] = Color(100, 100, 100, 70),
    }

    local CURRENT = 1

    if !RDV.COMMUNICATIONS.LIST then
        return PANEL
    end

    if !RDV.COMMUNICATIONS.GetCommsEnabled(LocalPlayer()) then
        return PANEL
    end

    local LActive = "("..RDV.LIBRARY.GetLang(nil, "COMMS_activeLabel")..")"
    local L_PASSIVE = "("..RDV.LIBRARY.GetLang(nil, "COMMS_passiveLabel")..")"

    for k, v in SortedPairs(RDV.COMMUNICATIONS.LIST) do
        local NAME = k

        if !RDV.COMMUNICATIONS.CanAccessChannel(LocalPlayer(), NAME) then
            continue
        end

        local PASSIVE = RDV.COMMUNICATIONS.GetPassiveChannels(LocalPlayer()) or {}

        COUNT = COUNT + 1
                 
        local LabelColor = ROTATE[CURRENT]

        if CURRENT == 1 then
            CURRENT = 2
        else
            CURRENT = 1
        end

        local LColor = v.Color

        local label = SCROLL:Add("DLabel")
        label:SetHeight(h * 0.1)
        label:Dock(TOP)
        label:SetMouseInputEnabled(true)
        label:SetFont("RDV_LIB_FRAME_TITLE")
        label:SetText("")

        label.Paint = function(self, w, h)
            local OCCUPANTS = RDV.COMMUNICATIONS.GetMemberCount(NAME)

            draw.RoundedBox(0, 0, 0, w, h, LabelColor)

            surface.SetDrawColor(color_white)
                surface.SetMaterial(ICON)
            surface.DrawTexturedRect(w * 0.9, h * 0.25, w * 0.08, h * 0.55)

            draw.SimpleText(OCCUPANTS, "RDV_LIB_FRAME_TITLE", w * 0.875, h * 0.5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            if PASSIVE[NAME] then
                draw.SimpleText(NAME.." "..L_PASSIVE, "RDV_LIB_FRAME_TITLE", w * 0.05, h * 0.5, LColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            elseif RDV.COMMUNICATIONS.GetActiveChannel(LocalPlayer()) == NAME then
                draw.SimpleText(NAME.." "..LActive, "RDV_LIB_FRAME_TITLE", w * 0.05, h * 0.5, LColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText(NAME, "RDV_LIB_FRAME_TITLE", w * 0.05, h * 0.5, LColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        label.DoClick = function(self)
            local MenuButtonOptions = DermaMenu() -- Creates the menu

            local ACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(LocalPlayer())
            local PASSIVE = RDV.COMMUNICATIONS.GetPassiveChannels(LocalPlayer()) or {}
            
            if !PASSIVE[NAME] and ( ACTIVE ~= NAME ) then
                local CFG = RDV.COMMUNICATIONS.S_CFG

                if ( table.Count(PASSIVE) ) < CFG.passiveChannelCount then
                    MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_setPassive"), function()
                        surface.PlaySound("buttons/blip1.wav")

                        net.Start("RDV_COMMS_SetPassive")
                            net.WriteString(k)
                            net.WriteBool(true)
                        net.SendToServer()
                    end)
                end
            elseif PASSIVE[NAME] and ( ACTIVE ~= NAME ) then 
                MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_disconnectPassive"), function()
                    surface.PlaySound("buttons/blip1.wav")

                    net.Start("RDV_COMMS_SetPassive")
                        net.WriteString(k)
                        net.WriteBool(false)
                    net.SendToServer()
                end)
            end

            if !PASSIVE[NAME] then
                if ( ACTIVE ~= NAME ) then
                    MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_connectLabel"), function()
                        surface.PlaySound("buttons/blip1.wav")

                        net.Start("RDV_COMMS_Connect")
                            net.WriteString(k)
                        net.SendToServer()
                    end)
                else
                    MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_disconnectLabel"), function()
                        net.Start("RDV_COMMS_Disconnect")
                        net.SendToServer()

                        surface.PlaySound("reality_development/ui/ui_denied.ogg")
                    end)
                end
            end

            if RDV.COMMUNICATIONS.GetMemberCount(NAME) > 0 then
                MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "COMMS_viewOccupants"), function()
                    if RDV.COMMUNICATIONS.GetMemberCount(NAME) <= 0 then
                        return
                    end

                    local MLIST = {}
                    local LIST = {}

                    local LOccupants = RDV.LIBRARY.GetLang(nil, "COMMS_channelOccupantsTitle", {
                        NAME,
                    })

                    local FRAME = vgui.Create("RDV_LIBRARY_FRAME")
                    FRAME:SetSize(ScrW() * 0.3, ScrH() * 0.4)
                    FRAME:Center()
                    FRAME:SetTitle(LOccupants)
                    FRAME:MakePopup(true)

                    local DermaListView = vgui.Create("DListView", FRAME)
                    DermaListView:Dock(FILL)
                    DermaListView:SetMultiSelect(false)
                    DermaListView:AddColumn(RDV.LIBRARY.GetLang(nil, "COMMS_nameLabel"))
                    DermaListView:AddColumn(RDV.LIBRARY.GetLang(nil, "COMMS_factionLabel"))
                    DermaListView:AddColumn(RDV.LIBRARY.GetLang(nil, "COMMS_typeLabel"))

                    DermaListView.OnRowSelected = function(self, rowind, row)
                        table.insert(MLIST, LIST[rowind])
                    end

                    for k, v in pairs(RDV.COMMUNICATIONS.Players) do
                        local P = Entity(k)

                        if !IsValid(P) or (v ~= NAME) then
                            continue
                        end

                        DermaListView:AddLine(P:Name(), team.GetName(P:Team()), RDV.LIBRARY.GetLang(nil, "COMMS_activeLabel")) -- Add lines
                    end 

                    for k, v in pairs(RDV.COMMUNICATIONS.PASSIVE) do
                        if v[NAME] then
                            local P = Entity(k)

                            if !IsValid(P) then continue end

                            local LINE = DermaListView:AddLine(P:Name(), team.GetName(P:Team()), RDV.LIBRARY.GetLang(nil, "COMMS_passiveLabel")) -- Add lines
                        end
                    end
                end)
            end

            MenuButtonOptions:Open() -- Open the menu AFTER adding your options
        end
    end

    return PANEL
end

hook.Add("RDV_COMMS_PostChannelConnect", "RDV.StartMuted.Implement", function(ply)
    if !IsValid(ply) then return end
    
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if CFG.startMuted and ( ply == LocalPlayer() ) then
        MUTED = true
    end
end )

net.Receive("RDV.COMMUNICATIONS.SendCommsMessage", function()
    local CLI = net.ReadUInt(8)

    CLI = Entity(CLI)

    if !IsValid(CLI) then
        return
    end

    local CHANNEL = RDV.COMMUNICATIONS.GetActiveChannel(CLI)

    if !CHANNEL then
        return
    end

    local MSG = net.ReadString()
    
    local COL = RDV.COMMUNICATIONS.LIST[CHANNEL].Color

    RDV.LIBRARY.AddText(LocalPlayer(), COL, "["..CHANNEL.."] ", team.GetColor(CLI:Team()), CLI:Name(), color_white, ": "..MSG)
end)

hook.Add("OnContextMenuClose", "RDV.COMMUNICATIONS.ContextMenuClose", function()
    if IsValid(RDV.COMMUNICATIONS.IDENT) then
        RDV.COMMUNICATIONS.IDENT:SetVisible(true)
    end
end)

hook.Add("OnContextMenuOpen", "RDV.COMMUNICATIONS.ContextMenuOpen", function(panel)
    local PANEL = RDV.COMMUNICATIONS.Open(true)

    if !IsValid(PANEL) then
        return
    end

    PANEL:ShowCloseButton(false)
end)

net.Receive("RDV_COMMS_Sync", function()
    local COUNT = net.ReadUInt(8)
    
    for i = 1, COUNT do
        local PLAYER = net.ReadUInt(8)
        
        if !IsValid(Entity(PLAYER)) then continue end

        local CHANNEL = net.ReadString()

        RDV.COMMUNICATIONS.Players[PLAYER] = CHANNEL

        RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] = RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] or 0
        RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] = RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] + 1

        hook.Run("RDV_COMMS_NetworkingComplete", Entity(PLAYER)) 
    end
end )

local function Disconnect(UID)
    local OLD = RDV.COMMUNICATIONS.Players[UID]

    if OLD then
        hook.Run("RDV_COMMS_PreChannelDisconnect", Entity(UID), OLD)


        RDV.COMMUNICATIONS.Players[UID] = false

        RDV.COMMUNICATIONS.OCCUPANTS[OLD] = RDV.COMMUNICATIONS.OCCUPANTS[OLD] or 1
        RDV.COMMUNICATIONS.OCCUPANTS[OLD] = RDV.COMMUNICATIONS.OCCUPANTS[OLD] - 1

        hook.Run("RDV_COMMS_PostChannelDisconnect", Entity(UID), OLD)
    end
end

net.Receive("RDV_COMMS_Disconnect", function()
    local PLAYER = net.ReadUInt(8)

    Disconnect(PLAYER)
end )

net.Receive("RDV_COMMS_Connect", function()
    local PLAYER = net.ReadUInt(8)

    Disconnect(PLAYER)

    local CHANNEL = net.ReadString()

    hook.Run("RDV_COMMS_PreChannelConnect", Entity(PLAYER), CHANNEL)

    RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] = RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] or 0
    RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] = RDV.COMMUNICATIONS.OCCUPANTS[CHANNEL] + 1

    RDV.COMMUNICATIONS.Players[PLAYER] = CHANNEL

    hook.Run("RDV_COMMS_PostChannelConnect", Entity(PLAYER), CHANNEL)
end )

RDV.COMMUNICATIONS.TemporaryChannels = {}

net.Receive("RDV.COMMUNICATIONS.CreateChannel", function()
    local TCOUNT = net.ReadUInt(8)
    local PCOUNT = net.ReadUInt(8)
    local NAME = net.ReadString()

    local TEAMS = {}
    local TEAMS_INT = {}

    local PLAYS = {}

    for i = 1, TCOUNT do
        local TEAM = net.ReadUInt(16)
        local TNAME = team.GetName(TEAM)

        table.insert(TEAMS, TNAME)
        table.insert(TEAMS_INT, TEAM)
    end

    for i = 1, PCOUNT do
        local PLAYER = net.ReadUInt(31)

        PLAYS[PLAYER] = true
    end
    
    local COMMS = RDV.COMMUNICATIONS

    COMMS:RegisterChannel(NAME, {
        Factions = TEAMS,
        Color = color_white,
        CustomCheck = function(ply)
            if !table.IsEmpty(PLAYS) and !PLAYS[ply:AccountID()] then
                return false
            end
        end,
    })

    local KEY = table.insert(RDV.COMMUNICATIONS.TemporaryChannels, {
        Name = NAME,
    })

    hook.Run("RDV_COMMS_ChannelCreated", KEY)
end)

net.Receive("RDV_COMMS_RemoveChannel", function()
    local CID = net.ReadUInt(8)

    local TEMP = RDV.COMMUNICATIONS.TemporaryChannels

    if TEMP and TEMP[CID] then
        local NAME = TEMP[CID].Name

        RDV.COMMUNICATIONS.TemporaryChannels[CID] = nil

        RDV.COMMUNICATIONS.LIST[NAME] = nil
    end
end)

hook.Add("RDV_COMMS_PostChannelDisconnect", "RDV.COMMUNICATIONS.ChannelLabel", function(ply, ACTIVE)
    if ply ~= LocalPlayer() then
        return
    end

    if IsValid(RDV.COMMUNICATIONS.VPANEL) then RDV.COMMUNICATIONS.VPANEL:Remove() end

    if IsValid(RDV.COMMUNICATIONS.IDENT) then
        RDV.COMMUNICATIONS.IDENT:Remove()
    end
end)

hook.Add("RDV_LIB_ConfigSyncComplete", "RDV_COMMS_WaitLoadLib", function(ply)
    COMPLETE = true

    if isfunction(WAITING) then
        WAITING()
    end
end)

hook.Add("RDV_COMMS_PostChannelConnect", "RDV.COMMUNICATIONS.ChannelLabel", function(P, CHANNEL)
    if P ~= LocalPlayer() then
        return
    end

    local function Create()
        if !CHANNEL then
            return
        end

        local w, h = ScrW(), ScrH()
        local NAME = CHANNEL

        if !RDV.COMMUNICATIONS.LIST or !RDV.COMMUNICATIONS.LIST[NAME] then
            return
        end

        local VCOLOR = RDV.COMMUNICATIONS.GetChannelColor(NAME)
        
        local LDisconnected = RDV.LIBRARY.GetLang(nil, "COMMS_disconnectedLabel")

        local PANEL = vgui.Create("DPanel")
        PANEL:SetSize(w * 0.175, h * 0.05)

        local CFG = RDV.COMMUNICATIONS.S_CFG

        local LOCATION = CFG.HUDLocation

        if LOCATION then
            PANEL:SetPos(w * 0.82, h * 0.01)
        else
            PANEL:SetPos(w * 0.005, h * 0.01)
        end

        PANEL:SetMouseInputEnabled(true)
        PANEL.Paint = function(self, w, h)
            if !NAME then return end

            local COUNT = RDV.COMMUNICATIONS.GetMemberCount(NAME)
            local ENABLED = RDV.COMMUNICATIONS.GetCommsEnabled(LocalPlayer())

            DrawBlur(self, 6)
        
            surface.SetDrawColor( COL_OUTLINE )
            surface.DrawOutlinedRect( 0, 0, w, h )

            surface.SetDrawColor(color_white)
                surface.SetMaterial(MIC_ICON)
            surface.DrawTexturedRect(w * 0.025, h * 0.175, w * 0.13, h * 0.675)

            draw.RoundedBox(0, 0, 0, w, h, COL_1)
            
            local LOccupants

            if ENABLED then
                LOccupants = RDV.LIBRARY.GetLang(nil, "COMMS_occupantsLabel", {
                    COUNT,
                })

                local LMuted = RDV.LIBRARY.GetLang(nil, "COMMS_mutedLabel")

                if MUTED then
                    draw.SimpleText(NAME.." "..LMuted, "RDV_LIB_FRAME_TITLE", w * 0.18, h * 0.35, VCOLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText(NAME, "RDV_LIB_FRAME_TITLE", w * 0.18, h * 0.35, VCOLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
                    draw.SimpleText(LOccupants, "RDV_COMMUNICATIONS_FontSmall", w * 0.18, h * 0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                else

                LOccupants = RDV.LIBRARY.GetLang(nil, "COMMS_occupantsLabel", {
                    "(N/A)",
                })

                draw.SimpleText(LDisconnected, "RDV_LIB_FRAME_TITLE", w * 0.18, h * 0.35, COL_RED, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(LOccupants, "RDV_COMMUNICATIONS_FontSmall", w * 0.18, h * 0.65, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        RDV.COMMUNICATIONS.IDENT = PANEL
    end

    if COMPLETE then 
        Create() 
    else
        WAITING = Create
    end
end)

hook.Add("PlayerStartVoice", "RDV_COMMUNICATIONS_VoiceIndicator2", function(ply)
    if ply == LocalPlayer() and MUTED then return end

    if !RDV.COMMUNICATIONS.GetCommsEnabled(LocalPlayer()) then return end
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if CFG.speakBindEnabled and !LocalPlayer():KeyDown(CFG.speakBindValue) then return end

    local PACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(ply)
    local LACTIVE = RDV.COMMUNICATIONS.GetActiveChannel(LocalPlayer())

    if LACTIVE and PACTIVE and ( PACTIVE == LACTIVE ) then
        local VCOLOR = RDV.COMMUNICATIONS.LIST[PACTIVE].Color

        local w, h = ScrW(), ScrH()

        if IsValid(g_VoicePanelList) then
            g_VoicePanelList:SetVisible(false)   
        end   

        -- DEVELOPMENT ONLY (REMOVE)
        --if IsValid(RDV.COMMUNICATIONS.VPANEL) then RDV.COMMUNICATIONS.VPANEL:Remove() end
        --

        if !IsValid(RDV.COMMUNICATIONS.VPANEL) then
            local PANEL = vgui.Create("DPanel")
            PANEL:SetSize(w * 0.16, h * 0.5)

            local CFG = RDV.COMMUNICATIONS.S_CFG

            local LOCATION = CFG.HUDLocation

            if LOCATION then
                PANEL:SetPos(w * 0.835, h * 0.065)
            else
                PANEL:SetPos(w * 0.005, h * 0.065)
            end

            
            PANEL.Paint = function(self, w, h)
            end
        
            local w, h = PANEL:GetSize()
    
            RDV.COMMUNICATIONS.VPANEL = PANEL
        end

        local LText = RDV.LIBRARY.GetLang(nil, "COMMS_connectionLost")
        local TEXT = LText

        local LAST = CurTime()
        local TCOLOR = team.GetColor(ply:Team())

        local SCROLL = RDV.COMMUNICATIONS.VPANEL

        local label = vgui.Create("DLabel", SCROLL)
        label:SetHeight(h * 0.045)
        label:SetFont("RDV_LIB_FRAME_TITLE")
        label:SetText("")
        label:Dock(TOP)

        label.Paint = function(self, w, h)
            if !IsValid(ply) then
                self:Remove()
                return
            end

            local ENABLED = RDV.COMMUNICATIONS.GetCommsEnabled(LocalPlayer())

            DrawBlur(self, 6)

            surface.SetDrawColor( COL_OUTLINE )
            surface.DrawOutlinedRect( 0, 0, w, h )
    
            draw.RoundedBox(0, 0, 0, w, h, COL_1)

            if ENABLED then
                draw.SimpleText(ply:Name(), "RDV_LIB_FRAME_TITLE", w * 0.2, h * 0.325, TCOLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.SimpleText(PACTIVE, "RDV_LIB_FRAME_TITLE", w * 0.2, h * 0.675, VCOLOR, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)


                surface.SetDrawColor(color_white)
                    surface.SetMaterial(SPEAKER_ICON)
                surface.DrawTexturedRect(w * 0.05, h * 0.253125, w * 0.0975, h * 0.50625)
            else
                if LAST < CurTime() then
                    if TEXT == LText.."..." then
                        TEXT = LText
                    else
                        TEXT = TEXT.."."
                    end

                    LAST = CurTime() + 1
                end

                draw.SimpleText(TEXT, "RDV_LIB_FRAME_TITLE", w * 0.25, h * 0.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        RDV.COMMUNICATIONS.VSCROLL_LABELS = RDV.COMMUNICATIONS.VSCROLL_LABELS or {}

        RDV.COMMUNICATIONS.VSCROLL_LABELS[ply] = label
    end
end)

hook.Add("PlayerEndVoice", "RDV.COMMUNICATIONS.VoiceIndicator", function(ply)
    RDV.COMMUNICATIONS.VSCROLL_LABELS = RDV.COMMUNICATIONS.VSCROLL_LABELS or {}

    local LABEL = RDV.COMMUNICATIONS.VSCROLL_LABELS[ply]

    if IsValid(LABEL) then
        LABEL:Remove()

        if !IsValid(g_VoicePanelList) then
            return
        end

        g_VoicePanelList:SetVisible(true)
    end
end)

local talking = false
net.Receive("RDV_COMMUNICATIONS_Talking", function(len, ply)
    if permissions.EnableVoiceChat and !permissions.IsGranted("voicerecord") then
        permissions.EnableVoiceChat(true)

        return
    end

    if !talking then
        talking = true

        if permissions.EnableVoiceChat then
            permissions.EnableVoiceChat(true)
        else
            RunConsoleCommand("+voicerecord")
        end
    else
        talking = false

        if permissions.EnableVoiceChat then
            permissions.EnableVoiceChat(false)
        else
            RunConsoleCommand("-voicerecord")
        end
    end
end)

--[[---------------------------------]]--
--  Halo Implementation
--[[---------------------------------]]--

hook.Add( "PreDrawHalos", "RDV.HALOS", function()
    local CFG = RDV.COMMUNICATIONS.S_CFG

    if !CFG.haloEnabled then return end

    local ID = RDV.COMMUNICATIONS.GetActiveChannel(LocalPlayer())

    if !ID then return end

    local TAB = {}

    for k, v in ipairs(player.GetAll()) do
        local C = RDV.COMMUNICATIONS.GetActiveChannel(v)

        if ( ID == C ) then
            table.insert(TAB, v)
        end
    end

    local COL = RDV.COMMUNICATIONS.GetChannelColor(ID)

    halo.Add( TAB, COL, 2, 2, 1, true, true )
end )