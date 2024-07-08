ITEM.name = "Datapad Para Anotações"
ITEM.model = "models/swcw_items/sw_datapad.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Um dispositivo feito para escrever e anotar coisas nele, pode também conter mensagens de alguém."
ITEM.category =  "Equipamentos"
ITEM.price = 0
ITEM.flag = "A"

ITEM.functions.use = {
	name = "Anotar",
	icon = "icon16/pencil.png",
	OnRun = function(item)
		local client = item.player
		local id = item:GetID()
		if (id) then
			netstream.Start(client, "receivePaper", id, item:GetData("PaperData") or "")
		end
		return false
	end
}

