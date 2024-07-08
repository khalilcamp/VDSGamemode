
FACTION.name = "Chanceler"
FACTION.description = "O Chenceler da Republica."
FACTION.color = Color(255, 200, 100, 255)
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.pay = 5000
FACTION.models = {
	"models/player/gpalpatine.mdl"
}

function FACTION:GetDefaultName(client)
	return "Sheev Palpatine", true
end

function FACTION:OnSpawn(client)
    client:SetMaxHealth(9000)
    client:SetHealth(9000)
    client:SetRunSpeed(500)
    client:SetArmor(50000)
    client:SetMaxArmor(5000)
end

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_PALPATINE = FACTION.index
FACTION.canSeeWaypoints = true
