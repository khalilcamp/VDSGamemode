
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "|Legião 501st|"
FACTION.description = "Rápidos, com capacidade de sobrevivência e altamente eficazes a curta e média distância, os soldados avançam incansavelmente, abrindo caminho para o resto da unidade, a Legião 501st ou parte dela foi madada para essa exército, visando ser a ponta de lança do setor.."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(7, 3, 252)
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/jajoff/sps/cgi501/tc13j/trooper.mdl"
}


FACTION.charImage = "materials/karman/ui/trooper7.png"
FACTION.backgroundMusic = "ranz/clone_wars.mp3"

function FACTION:OnSpawn(ply)
    ply:SetHealth(200)
    ply:SetMaxHealth(200)
    ply:SetArmor(200)
    ply:SetMaxArmor(200)
    ply:SetRunSpeed(150) 
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
FACTION_501ST = FACTION.index
FACTION.canSeeWaypoints = true
