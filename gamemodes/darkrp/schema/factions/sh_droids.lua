
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "Droid"
FACTION.description = "Qualquer tipo de droid que a base precisa ou tem."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(235, 52, 168)
FACTION.weapons = {"mvp_hands"}
FACTION.models = {
    "models/translator/pm_protocol_translator.mdl",
	"models/inventory/pm_protocol_inventory.mdl",
	"models/vendor/pm_protocol_vendor.mdl",
	"models/ace/sw/r2.mdl",
	"models/ace/sw/r4.mdl",
	"models/ace/sw/r5.mdl",
}

FACTION.pay = 3


FACTION.charImage = "materials/karman/ui/medic2.png"
FACTION.backgroundMusic = "karman/kamino2.mp3"

function FACTION:OnSpawn(client)
    client:SetMaxHealth(120)
    client:SetHealth(120)
    client:SetArmor(120)
    client:SetMaxArmor(120)
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

-- You should define a global variable for this faction's index for easy access wherever you need. FACTION.index is
-- automatically set, so you can simclient assign the value.

-- Note that the player's team will also have the same value as their current character's faction index. This means you can use
-- client:Team() == FACTION_CITIZEN to compare the faction of the player's current character.
FACTION_DROID = FACTION.index
FACTION.canSeeWaypoints = true