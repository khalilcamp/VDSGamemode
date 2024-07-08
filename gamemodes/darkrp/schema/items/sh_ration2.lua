
ITEM.name = "Cache de Munições"
ITEM.model = Model("models/niksacokica/containers/crate_weapon_01.mdl")
ITEM.description = "Uma caixa de munições variadas, pode ser aberta."
ITEM.price = 175
ITEM.items = {"ar2ammo2", "ar2ammo2", "ar2ammo", "rocketammo", "rocketammo", "blaster1"}
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

		character:GiveMoney(ix.config.Get("rationTokens", 0))
		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}
