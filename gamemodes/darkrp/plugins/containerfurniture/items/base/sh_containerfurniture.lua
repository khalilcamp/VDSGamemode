ITEM.name = "Base Container Furniture"
ITEM.description = "A cool description"
ITEM.price = 0
ITEM.flag = ""
ITEM.category = "Depositos"
ITEM.width = 1
ITEM.weight = 2
ITEM.height = 2
-- Inventory Model
ITEM.model = "models/Items/item_item_crate.mdl"

--[[Container model

 MAKE SURE YOU HAVE REGISTER A CONTAINER IN HELIX/PLUGINS/CONTAINERS/sh_definitions.lua

--]]
ITEM.ContainerModel = "models/props_junk/wood_crate001a.mdl"

ITEM.functions.Use = {
	name = "Colocar",
	icon = "icon16/anchor.png",
	OnRun = function(item)
		local client = item.player

		hook.Run("ContainerFurnitureSpawn", item)
		return true
	end
}
