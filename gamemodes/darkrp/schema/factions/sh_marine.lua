
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "|Divisão de Fuzileiros Galaticos|"
FACTION.description = "Rápidos, com capacidade de sobrevivência e altamente eficazes a curta e média distância, os soldados avançam incansavelmente, abrindo caminho para o resto da unidade, a divisão dos Galactic Marines ou parte dela foi madada para essa exército, visando ser a ponta de lança do setor.."
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.color = Color(84, 50, 168)
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/jajoff/sps/cgi21s/tc13j/marine.mdl"
}


FACTION.charImage = "materials/karman/ui/trooper7.png"
FACTION.backgroundMusic = "ranz/clone_wars.mp3"

function FACTION:OnSpawn(client)
    client:SetMaxHealth(300)
    client:SetHealth(300)
    client:SetArmor(200)
    client:SetMaxArmor(200)
  	client:SetWalkSpeed(100)
    client:SetRunSpeed(150)
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
FACTION_GM = FACTION.index
FACTION.canSeeWaypoints = true
