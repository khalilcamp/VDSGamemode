
include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

ENT.PopulateEntityInfo = true
function ENT:OnPopulateEntityInfo(container)
	local text = container:AddRow("name")
	text:SetImportant()
	text:SetText( "Radio" )
	text:SizeToContents()

	local description = container:AddRow("description")
	description:SetBackgroundColor( Color(0, 0, 0, 155) )
	description:SetText( "Uma maquina com varias luzes piscando, possui uma tela para escolher uma música para tocar nela." )
	description:SizeToContents()
end
