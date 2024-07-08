
ITEM.name = "Especial Coruscant"
ITEM.model = Model("models/props_junk/popcan01a.mdl")
ITEM.description = "Uma latinha de soda, mas é de uma edição especial, produzida em uma incrível fabrica na grande capital da galáxia, é apenas uma comida para consumo."
ITEM.category = "Consumables"
ITEM.skin = 2
ITEM.width = 1 -- Width and height refer to how many grid spaces this item takes up.
ITEM.height = 1

-- Items will be purchasable through the business menu. To disable the purchasing of this item, we specify ITEM.noBusiness.
ITEM.noBusiness = true

-- If you'd rather have the item only purchasable by a specific criteria, then you can specify it as such.
-- Make sure you haven't defined ITEM.noBusiness if you are going to be doing this.
--[[
ITEM.factions = {FACTION_POLICE} -- Only a certain faction can buy this.
ITEM.classes = {FACTION_POLICE_CHIEF} -- Only a certain class can buy this.
ITEM.flag = "z" -- Only a character having a certain flag can buy this.
]]

-- If the item is purchasable, then you'll probably want to set a price for it:
--[[
ITEM.price = 5
]]

-- You can define additional actions for this item as such:
ITEM.functions.Drink = {
	OnRun = function(item)
		-- IMPORTANT: Make sure you use "item" instead of "ITEM" here - these two are entirely different things!
		local client = item.player

		client:SetHealth(math.min(client:Health() + 30, client:GetMaxHealth()))
		-- Returning true will cause the item to be removed from the character's inventory.
		return true
	end
}
