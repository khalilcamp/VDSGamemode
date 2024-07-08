
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "Ordem Jedi"
FACTION.description = "Os guardiões da paz e prosperidade, os Jedi agora são apenas soldados nessa guerra sem fim, mas a luz ainda está presente nos momentos mais sombrios por mais que nem todos vejam."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(140, 29, 118)
FACTION.weapons = {"mvp_hands", "weapon_lscs", "weapon_fists"}
FACTION.models = {
    "models/player/jedi/human.mdl",
    "models/player/jedi/togruta.mdl", 
    "models/player/jedi/trandoshan.mdl", 
    "models/player/jedi/twilek.mdl", 
    "models/player/jedi/twilek2.mdl", 
    "models/player/jedi/umbaran.mdl", 
    "models/player/jedi/zabrak.mdl", 
}
FACTION.pay = 10

FACTION.charImage = "materials/karman/ui/medic2.png"
FACTION.backgroundMusic = "karman/kamino2.mp3"

function FACTION:OnSpawn(client)
    client:SetMaxHealth(600)
    client:SetHealth(600)
    client:SetRunSpeed(500)
    client:SetArmor(50)
    client:SetMaxArmor(50)
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
FACTION_JEDI = FACTION.index
FACTION.canSeeWaypoints = true
