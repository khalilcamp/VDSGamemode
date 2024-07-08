local PANEL = {}

surface.CreateFont( "NCS_TRANSPORT_textEntry", {
	font = "Montserrat Medium",
	extended = false,
	size = ScreenScale(5),
} )

function PANEL:Init()
    self:SetFont("NCS_TRANSPORT_textEntry")
end

function PANEL:Paint(w, h)
    surface.SetDrawColor( Color(122,132,137, 180) )
    surface.DrawOutlinedRect( 0, 0, w, h )

    self:DrawTextEntryText(color_white, color_white, color_white)
end

vgui.Register( "NCS_TRANSPORT_TextEntry", PANEL, "DTextEntry" )