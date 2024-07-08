
ITEM.name = "Ração Militar"
ITEM.model = Model("models/niksacokica/items/shop_stand_set_crate05.mdl")
ITEM.description = "Um conjunto de suprimentos para sobrevivencia, usando muito por forças militares mas pode ser comprado por civis e outros."
ITEM.price = 175
ITEM.items = {"medica3", "bebida2", "bebida2", "ar2ammo2"}
ITEM.bDropOnDeath = true

ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		for k, v in ipairs(itemTable.items) do
			if (!character:GetInventory():Add(v)) then
				ix.item.Spawn(v, client)
			end
		end

		character:GiveMoney(ix.config.Get("rationTokens", 25))
		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}
