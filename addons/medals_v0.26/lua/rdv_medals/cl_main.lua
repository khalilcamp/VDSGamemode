surface.CreateFont("RDV_MEDALS_LABEL", {
	font = "Bebas Neue",
	extended = false,
	size = ScrW() * 0.0135,
})

surface.CreateFont("RDV_MEDALS_OVERHEAD", {
	font = "Bebas Neue",
	extended = false,
	size = 35,
})

local NoInfo = true
local PAGE = 1
local WAIT = false

local function CreateDivider(PANEL, SP, TEXT)
	local w, h = PANEL:GetSize()

    local TLABEL = SP:Add("DLabel")
    TLABEL:Dock(TOP)
    TLABEL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    TLABEL:SetText(TEXT)
    TLABEL:SetFont("RDV_MEDALS_LABEL")
    TLABEL:SetTextColor(COL_1)
	TLABEL:SetMouseInputEnabled(true)
end

local function SendNotification(P, MSG)
    RDV.LIBRARY.AddText(P, Color(255,0,0), "[MEDALS] ", color_white, MSG)

end

local function DisplayMedals(SCROLL, DATA, P, PAGE, ADMIN)
    SCROLL:Clear()

    local w, h = SCROLL:GetSize()
    
    local PRIM = RDV.MEDALS.GetPrimary(P)

    local HOVERED = {}
    local DIS_PMEDAL = false
    
    if P == LocalPlayer() then
        DIS_PMEDAL = true
    end
    
    NoInfo = true

    for k, v in ipairs(DATA) do
        NoInfo = false

        local ICON
        local PRIMARY

        local CACHE = RDV.MEDALS.CACHE_LIST[v.NAME]
        local CFG = RDV.MEDALS.LIST[CACHE]

        if !CFG then continue end

        local G_NAME = v.GIVER

        local BUT = SCROLL:Add("DLabel")

        local GIVER = player.GetBySteamID64( v.GIVER)

        if IsValid(GIVER) then 
            G_NAME = GIVER:Name() 
        else
            steamworks.RequestPlayerInfo( v.GIVER, function( steamName )
                if steamName ~= "" then G_NAME = steamName end
            end )
        end

        BUT:SetSize(w, h * 0.125)
        BUT:SetText("")
        BUT:Dock(TOP)
        BUT:DockMargin(w * 0.01, 0, w * 0.01, h * 0.01)
        BUT:SetMouseInputEnabled(true)
        BUT.PaintOver = function(s, w, h)
            local COL = RDV.LIBRARY.GetConfigOption("LIBRARY_outlineTheme")

            local LANG = RDV.LIBRARY.GetLang(nil, "MED_givenBy", {
                G_NAME,
            })

            local TXT = v.NAME.." ("..v.TIME..")"

            if IsValid(PRIMARY) then
                if PRIMARY:IsHovered() then COL = RDV.LIBRARY.GetConfigOption("LIBRARY_hoverTheme") end
            end

            draw.SimpleText(TXT, "RDV_LIB_FRAME_TITLE", w * 0.2, h * 0.35, COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(LANG, "RDV_LIB_FRAME_TITLE", w * 0.2, h * 0.65, COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(COL)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        BUT.DoRightClick = function(s)
            if !RDV.MEDALS.CFG.Admins[LocalPlayer():GetUserGroup()] then SendNotification(LocalPlayer(), RDV.LIBRARY.GetLang(nil, "MED_noPerms")) return end

            local MenuButtonOptions = DermaMenu()

            MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "MED_deleteLabel"), function()
                if !isnumber(v.UID) then return end

                net.Start("RDV_MEDALS_PDELETE")
                    net.WritePlayer(P)
                    net.WriteUInt(v.UID, 32)
                net.SendToServer()

                BUT:Remove()
            end)
            MenuButtonOptions:Open()
        end

        if DIS_PMEDAL then
            PRIMARY = vgui.Create("NCS_MEDALS_TextButton", BUT)
            PRIMARY:SetText("")
            PRIMARY:Dock(RIGHT)
            PRIMARY:SetWide(PRIMARY:GetWide() * 1.75)
            PRIMARY:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)

            PRIMARY.PaintOver = function(s, w, h)
                local COL
    
                if s:IsHovered() then
                    COL = RDV.LIBRARY.GetConfigOption("LIBRARY_hoverTheme")
                else
                    COL = RDV.LIBRARY.GetConfigOption("LIBRARY_outlineTheme")
                end

                if PRIM and ( PRIM == v.UID ) then
                    draw.SimpleText("Main", "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.5, COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                else
                    draw.SimpleText("Set Main", "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.5, COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end
            PRIMARY.DoClick = function(s)
                if ( PRIM == v.UID ) then return end

                net.Start("RDV_MEDALS_SetPrimary")
                    net.WriteUInt(v.UID, 32)
                net.SendToServer()

                surface.PlaySound(RDV.LIBRARY.GetConfigOption("LIBRARY_clickSound"))

                PRIM = v.UID
            end
            
        end

        if CFG.ICON then
            ICON = vgui.Create("NCS_MEDALS_IMGUR", BUT)
            ICON:SetParent(BUT)
            ICON:Dock(LEFT)
            ICON:SetImgurID(CFG.ICON)
            ICON:SetWide(BUT:GetWide() * 0.2)

        end
    end

    for i = 1, 2 do
        local NEXT = SCROLL:Add("NCS_MEDALS_TextButton")
        NEXT:SetText("")
        NEXT:SetTall(NEXT:GetTall() * 2)
        NEXT:Dock(TOP)
        NEXT:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)

        NEXT.PaintOver = function(s, w, h)
            local COL

            if s:IsHovered() then
                COL = RDV.LIBRARY.GetConfigOption("LIBRARY_hoverTheme")
            else
                COL = RDV.LIBRARY.GetConfigOption("LIBRARY_outlineTheme")
            end

            if i == 1 then
                draw.SimpleText("Next Page: "..(PAGE + 1), "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.5, COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("Last Page: "..(PAGE - 1), "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.5, COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
        NEXT.DoClick = function(s)
            net.Start("RDV_MEDALS_RETRIEVE")
                if i == 1 then
                    net.WriteUInt((PAGE + 1), 16)
                else
                    net.WriteUInt((PAGE - 1), 16)
                end

                if !ADMIN then
                    net.WriteBool(false)
                else
                    net.WriteBool(true)
                    net.WritePlayer(P)
                end
            net.SendToServer()

            WAIT = function(DATA)
                if i == 1 then
                    DisplayMedals(SCROLL, DATA, P, (PAGE + 1), ADMIN)
                else
                    DisplayMedals(SCROLL, DATA, P, (PAGE - 1), ADMIN)
                end
            end

            surface.PlaySound(RDV.LIBRARY.GetConfigOption("LIBRARY_clickSound"))
        end
    end
end

local function DisplayPlayers(SCROLL)
    SCROLL:Clear()

    local w, h = SCROLL:GetSize()

    local HOVERED = {}

    NoInfo = true

    for k, v in ipairs(player.GetAll()) do
        NoInfo = false

        local E_PLAYER = v

        local BUT = SCROLL:Add("NCS_MEDALS_TextButton")
        BUT:SetSize(w, h * 0.125)
        BUT:SetText(v:Name())
        BUT:Dock(TOP)
        BUT:DockMargin(w * 0.01, 0, w * 0.01, h * 0.01)
        BUT:SetTextColor(color_white)
        BUT:SetFont("RDV_LIB_FRAME_TITLE")

        BUT.DoClick = function(self)
            local MenuButtonOptions = DermaMenu()

            MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "MED_seeMedals"), function()
                net.Start("RDV_MEDALS_RETRIEVE")
                    net.WriteUInt(0, 16)
                    net.WriteBool(true)
                    net.WritePlayer(v)
                net.SendToServer()

                WAIT = function(DATA)
                    DisplayMedals(SCROLL, DATA, v, 0, true)
                end
            end)

            MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "MED_giveMedal"), function()                
                SCROLL:Clear()

                local w, h = SCROLL:GetSize()
                
                for k, v in pairs(RDV.MEDALS.LIST) do
                    local BUT_GIVE
                    local ICON

                    local BUT = SCROLL:Add("DLabel")
                    BUT:SetSize(w, h * 0.125)
                    BUT:SetText("")
                    BUT:Dock(TOP)
                    BUT:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
                    BUT:SetMouseInputEnabled(true)

                    BUT.Paint = function(s, w, h)
                        local COL

                        if BUT_GIVE:IsHovered() then
                            COL = RDV.LIBRARY.GetConfigOption("LIBRARY_hoverTheme")
                        else
                            COL = RDV.LIBRARY.GetConfigOption("LIBRARY_outlineTheme")
                        end
            
                        local TXT = v.Name

                        surface.SetDrawColor(COL)
                        surface.DrawOutlinedRect(0,0,w,h)
            
                        draw.SimpleText(TXT, "RDV_LIB_FRAME_TITLE", w * 0.2, h * 0.5, COL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)            
                    end

                    BUT_GIVE = vgui.Create("NCS_MEDALS_TextButton", BUT)
                    BUT_GIVE:SetText("")
                    BUT_GIVE:Dock(RIGHT)
                    BUT_GIVE:SetWide(BUT_GIVE:GetWide() * 1.75)
                    BUT_GIVE:DockMargin(w * 0.01, h * 0.01, w * 0.01, h * 0.01)
            
                    BUT_GIVE.PaintOver = function(s, w, h)
                        local COL
                
                        if s:IsHovered() then
                            COL = RDV.LIBRARY.GetConfigOption("LIBRARY_hoverTheme")
                        else
                            COL = RDV.LIBRARY.GetConfigOption("LIBRARY_outlineTheme")
                        end
                            
                        draw.SimpleText(RDV.LIBRARY.GetLang(nil, "MED_giveLabel"), "RDV_LIB_FRAME_TITLE", w * 0.5, h * 0.5, COL, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    BUT_GIVE.DoClick = function(s)
                        net.Start("RDV_MEDALS_GIVE")
                            net.WritePlayer(E_PLAYER)
                            net.WriteUInt(k, 16)
                        net.SendToServer()


                        DisplayPlayers(SCROLL)

                        surface.PlaySound("rdv/new/activate.mp3")
                    end

                    if v.ICON then
                        ICON = vgui.Create("NCS_MEDALS_IMGUR", BUT)
                        ICON:Dock(LEFT)
                        ICON:SetWide(BUT:GetWide() * 0.2)
                        ICON:SetImgurID(v.ICON)
                    end
                end
            end)

            surface.PlaySound("rdv/new/activate.mp3")

            MenuButtonOptions:Open()
        end
    end
end

local function CreateMedal(UID)
    local DATA = RDV.MEDALS.LIST[UID]

    if UID and !DATA then return end

    local FRAME = vgui.Create("NCS_MEDALS_FRAME")
    FRAME:SetSize(ScrW() * 0.3, ScrH() * 0.4)
    FRAME:Center()
    FRAME:MakePopup()

    local D_SCROLL = vgui.Create("DScrollPanel", FRAME)
    D_SCROLL:Dock(FILL)

    CreateDivider(FRAME, D_SCROLL, RDV.LIBRARY.GetLang(nil, "MED_nameLabel"))

    local NAME = D_SCROLL:Add("DTextEntry")
    NAME:Dock(TOP)

    if DATA and DATA.Name then
        NAME:SetValue(DATA.Name)
    end

    CreateDivider(FRAME, D_SCROLL, RDV.LIBRARY.GetLang(nil, "MED_iconLinkLabel"))

    local ICON = D_SCROLL:Add("DTextEntry")
    ICON:Dock(TOP)

    if DATA and DATA.ICON then
        ICON:SetValue(DATA.ICON)
    end

    CreateDivider(FRAME, D_SCROLL, RDV.LIBRARY.GetLang(nil, "MED_maxAmountLabel"))

    local MAX = D_SCROLL:Add("DTextEntry")
    MAX:Dock(TOP)
    MAX:SetNumeric(true)

    if DATA and DATA.MAX then
        MAX:SetValue(DATA.MAX)
    end

    CreateDivider(FRAME, D_SCROLL, RDV.LIBRARY.GetLang(nil, "MED_cashLabel"))

    local CASH = D_SCROLL:Add("DTextEntry")
    CASH:Dock(TOP)
    CASH:SetNumeric(true)

    if DATA and DATA.REWARD then
        CASH:SetValue(DATA.REWARD)
    end

    local CONFIRM = vgui.Create("DButton", FRAME)
    CONFIRM:Dock(BOTTOM)
    CONFIRM:SetText(RDV.LIBRARY.GetLang(nil, "MED_createLabel"))
    CONFIRM.DoClick = function(s)
        local RNAME = NAME:GetValue()
        local IMGUR = ICON:GetValue()

        if RNAME == "" or IMGUR == "" then return end

        net.Start("RDV_MEDALS_CREATE")
            if UID then
                net.WriteBool(true)
                net.WriteUInt(UID, 32)
            else
                net.WriteBool(false)
            end

            net.WriteString(RNAME)
            net.WriteString(IMGUR)
            net.WriteUInt( (tonumber(MAX:GetValue()) or 0 ), 8 )
            net.WriteUInt( (tonumber(CASH:GetValue()) or 0 ), 32 )
        net.SendToServer()

        FRAME:Remove()
    end
end

net.Receive("RDV_MEDALS_MENU", function()
    NoInfo = true

    local P = vgui.Create("NCS_MEDALS_FRAME")
    P:SetSize(ScrW() * 0.5, ScrH() * 0.6)
    P:Center()
    P:MakePopup()
    P:SetTitle(RDV.LIBRARY.GetLang(nil, "MED_titleName"))

    local S = vgui.Create("NCS_MEDALS_SIDEBAR", P)
    
    local w, h = P:GetSize()

    local SCROLL = vgui.Create("RDV_LIBRARY_SCROLL", P)
    SCROLL:Dock(FILL)
    SCROLL:DockMargin(w * 0.02, h * 0.02, w * 0.02, h * 0.02)
    SCROLL.PaintOver = function(s, w, h)
        if NoInfo then draw.SimpleText(RDV.LIBRARY.GetLang(nil, "MED_noInfo"), "RDV_MEDALS_LABEL", w * 0.5, h * 0.4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
    end

    if RDV.MEDALS.CFG.Admins[LocalPlayer():GetUserGroup()] then
        S:AddPage(RDV.LIBRARY.GetLang(nil, "MED_adminName"), "y8ISs06", function()
            SCROLL:Clear()

            NoInfo = true

            SCROLL.Think = function(ns)
                DisplayPlayers(SCROLL)

                ns.Think = function() end
            end
        end )
    end

    S:AddPage(RDV.LIBRARY.GetLang(nil, "MED_titleName"), "xvXWl1Y", function()
        SCROLL:Clear()

        NoInfo = true

        net.Start("RDV_MEDALS_RETRIEVE")
            net.WriteUInt(0, 16)
            net.WriteBool(false)
        net.SendToServer()

        WAIT = function(DATA)
            DisplayMedals(SCROLL, DATA, LocalPlayer(), 0, false)
        end
    end )

    if RDV.MEDALS.CFG.Admins[LocalPlayer():GetUserGroup()] then
        S:AddPage("Create", "t0jvlci", function()
            local function REFRESH()
                SCROLL:Clear()

                local LABEL = SCROLL:Add("DLabel")
                LABEL:Dock(TOP)
                LABEL:SetTall(LABEL:GetTall() * 1.5)
                LABEL:SetText("")
                LABEL:SetMouseInputEnabled(true)

                local ADD = LABEL:Add("DButton", LABEL)
                ADD:SetImage("icon16/add.png")
                ADD:Dock(LEFT)
                ADD:SetText("")
                ADD:SetWide(ADD:GetWide() * 0.4)

                local B_REFRESH = LABEL:Add("DButton", LABEL)
                B_REFRESH:SetImage("icon16/arrow_refresh.png")
                B_REFRESH:Dock(LEFT)
                B_REFRESH:SetText("")
                B_REFRESH:SetWide(B_REFRESH:GetWide() * 0.4)
                B_REFRESH.DoClick = function(s)
                    REFRESH()
                end

                ADD.DoClick = function(s)
                    CreateMedal()
                end

                --ADD:SetStretchToFit(false)

                local LIST = SCROLL:Add( "DListView" )
                LIST:Dock( TOP )
                LIST:SetTall(SCROLL:GetTall() * 0.75)
                LIST:SetMultiSelect( false )
                LIST:AddColumn( RDV.LIBRARY.GetLang(nil, "MED_nameLabel") )
                LIST:AddColumn( RDV.LIBRARY.GetLang(nil, "MED_uniqueIDLabel")  )

                LIST.OnRowRightClick = function(_, ID, LINE)
                    local MenuButtonOptions = DermaMenu()

                    MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "MED_editLabel"), function()
                        CreateMedal(LINE.UID)
                    end)

                    MenuButtonOptions:AddOption(RDV.LIBRARY.GetLang(nil, "MED_deleteLabel"), function()
                        net.Start("RDV_MEDALS_DELETE")
                            net.WriteUInt(LINE.UID, 32)
                        net.SendToServer()
                    end)

                    MenuButtonOptions:Open()
                end

                for k, v in pairs(RDV.MEDALS.LIST) do
                    local LINE = LIST:AddLine( v.Name, k )
                    LINE.UID = k
                end
            end

            REFRESH()
        end )
    end
end )

net.Receive("RDV_MEDALS_RETRIEVE", function(len, ply)
    local DATA = {}

    for i = 1, 6 do
        local UID = net.ReadUInt(32)
        local MEDAL = net.ReadUInt(16)
        local GIVER = net.ReadString()
        local TIME = net.ReadString()

        DATA[i] = {
            UID = UID,
            NAME = RDV.MEDALS.GetName(MEDAL),
            GIVER = GIVER,
            TIME = TIME,
        }
    end

    if WAIT and isfunction(WAIT) then WAIT(DATA) end
end )

local D = {}
hook.Add("HUDPaint", "RDV_RDV_MEDALS_DisplayNormal", function()
    if RDV.MEDALS.CFG.Overhead then return end

    local T = LocalPlayer():GetEyeTrace().Entity

	if IsValid(T) and T:IsPlayer() then
		local DIST = LocalPlayer():GetPos():Distance(T:GetPos())

		if T != LocalPlayer() then
            local P_MEDAL = T:GetNWInt("RDV_MEDALS_MedID")

            local CACHE = RDV.MEDALS.LIST[P_MEDAL]

            if !CACHE then return end

            local COLOR = CACHE.COLOR
            local ICON = CACHE.ICON
            local MAT

            RDV.LIBRARY.GetImgur(ICON, function(mat)
                MAT = mat
            end)

            local ID = surface.GetTextureID(ICON)
            local TW, TH = surface.GetTextureSize(ID)

            surface.SetDrawColor( color_white )
            surface.SetMaterial( MAT )
            surface.DrawTexturedRect( ScrW() * 0.5 - (TW / 2), ScrH() * 0.25, 32, 32 )

            draw.SimpleText(CACHE.Name, "RDV_MEDALS_LABEL", ScrW() * 0.5, ScrH() * 0.3, (COLOR or color_white), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end )

hook.Add("PostDrawTranslucentRenderables", "RDV_MEDALS_DisplayOverhead", function()
    if !RDV.MEDALS.CFG.Overhead then return end

    local trace = LocalPlayer():GetEyeTrace().Entity

	if IsValid(trace) and trace:IsPlayer() then
		local distance = LocalPlayer():GetPos():Distance(trace:GetPos())
		local displayAng = LocalPlayer():EyeAngles()
		local displayPos = trace:GetPos() + Vector(0, 0, 80)

		if trace != LocalPlayer() then
            local P_MEDAL = trace:GetNWInt("RDV_MEDALS_MedID")

            local offset = Vector(0, 0, 80) 

            local physBone = trace:LookupBone("ValveBiped.Bip01_Head1") 
            local bone_pos
            local position

            if (physBone) then
                bone_pos = trace:GetBonePosition(physBone) 
            end

            if (trace:InVehicle()) then
                offset = Vector(0, 0, 118) 
            elseif (trace:Crouching()) then
                offset = Vector(0, 0, 54) 
            end

            if (bone_pos) then
                position = bone_pos + Vector(0, 0, 20) 
            else
                position = trace:GetPos() + offset
            end 
            
            if position then
                local CACHE = RDV.MEDALS.LIST[P_MEDAL]

                if !CACHE then return end

                local COLOR = CACHE.COLOR
                local ICON = CACHE.ICON
                local MAT

                RDV.LIBRARY.GetImgur(ICON, function(mat)
                    MAT = mat
                end)

                D[trace] = D[trace] or {
                    w = 0,
                    h = 0,
                }

                cam.Start3D2D(position, Angle(0, displayAng.y - 90, 90), 0.1)
                    surface.SetDrawColor( color_white )
                    surface.SetMaterial( MAT )
                    surface.DrawTexturedRect( -30, -20, 60, 60 )
                    
                    D[trace].w, D[trace].h = draw.SimpleText(CACHE.Name, "RDV_MEDALS_OVERHEAD", 0, 80, COLOR and COLOR or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                cam.End3D2D()
            end
        end
    end
end )

local N_DELAY = {}
hook.Add("PlayerTick", "RDV_MEDALS_NOTIFY", function(P)
    if !RDV.MEDALS.CFG.Reminder or ( RDV.MEDALS.CFG.Reminder <= 0 ) then return end

    if N_DELAY[LocalPlayer()] and N_DELAY[LocalPlayer()] > CurTime() then return end

    local LANG = RDV.LIBRARY.GetLang(nil, "MED_accessMedals")
    RDV.LIBRARY.AddText(LocalPlayer(), Color(255,0,0), "[MEDALS] ", color_white, LANG)

    N_DELAY[LocalPlayer()] = CurTime() + RDV.MEDALS.CFG.Reminder
end )