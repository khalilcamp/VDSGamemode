ITEM.name = "Maquina de Escrever Funcional"
ITEM.description = "Uma máquina com teclas para produzir caracteres alfabéticos, números e símbolos tipográficos, um de cada vez, em papel inserido em torno de um rolo."
ITEM.model = "models/niksacokica/tech/tech_triplazer_console.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "misc"
ITEM.price = 350

ITEM.functions.Use = {
	name = "Usar",
	OnClick = function(item)
		vgui.Create("ixTypewriter")
	end,
	OnRun = function(item)
		return false
	end,
	OnCanRun = function(item)
		return IsValid(item.entity)
	end
}