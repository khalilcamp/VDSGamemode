
FACTION.name = "|Legião 101st|"
FACTION.description = "Apenas um clone que acabou de chegar na base."
FACTION.color = Color(150, 125, 100, 255)
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.weapons = {"mvp_hands", "weapon_fists"}
FACTION.models = {
    "models/herm/ct/trooper/trooper.mdl"
}

function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_CADETE = FACTION.index
FACTION.canSeeWaypoints = true