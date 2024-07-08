
ITEM.name = "Cartão de ID Republicano"
ITEM.model = Model("models/gibs/metal_gib4.mdl")
ITEM.description = "Um cartão com ID republicana #%s, atribuído a %s."

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"))
end
