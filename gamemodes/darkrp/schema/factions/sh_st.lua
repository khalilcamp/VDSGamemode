
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "|ShockTrooper| Força de Segurança"
FACTION.description = "Um batalhão que está sendo direcionado para manter a segurança e negociações em zonas com civis ou de interesse, diretamente ordenada pelo Supremo Chanceler, os STs vão ser um dos suportes desse exército, e sobre qualquer informação muito importante, o alto comando deve ser contatado de imediato."
FACTION.isDefault = false
FACTION.color = Color(232, 9, 9)
FACTION.isGloballyRecognized = true
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/jajoff/sps/cgicga/tc13j/trooper.mdl"
}

FACTION.pay = 14


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
FACTION_ST = FACTION.index
FACTION.canSeeWaypoints = true