
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "SPEC OPS"
FACTION.description = "Uma unidade de elite, feito para a GAR, eles tem sido a principal parte de de combate e infiltração em bases hostis."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(34, 181, 147)
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/jajoff/sps/alpha/tc13j/coloured_regular02.mdl"
}

FACTION.pay = 15
FACTION.charImage = "materials/karman/ui/medic2.png"
FACTION.backgroundMusic = "karman/kamino2.mp3"

function FACTION:OnSpawn(ply)
    ply:SetHealth(800)
    ply:SetMaxHealth(800)
    ply:SetArmor(300)
    ply:SetMaxArmor(300)
    ply:SetRunSpeed(500) 
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
FACTION_ARC = FACTION.index
FACTION.canSeeWaypoints = true
