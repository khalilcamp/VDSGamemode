
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "|Legião 212st|"
FACTION.description = "Uma unidade da legião 212st, retirada do regimento principal, essa unidade ainda corresponte ao Comandante Cody, mas está separada das operações principais da grande legião.."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(252, 128, 3)
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/jajoff/sps/cgi212/tc13j/trooper.mdl"
}


FACTION.charImage = "materials/karman/ui/trooper7.png"
FACTION.backgroundMusic = "karman/kamino2.mp3"

function FACTION:OnSpawn(client)
    client:SetMaxHealth(120)
    client:SetHealth(110)
    client:SetArmor(135)
    client:SetMaxArmor(135)
end
FACTION.pay = 10

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
FACTION_212ST = FACTION.index
FACTION.canSeeWaypoints = true
