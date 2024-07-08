CLASS.name = "Bruto"
CLASS.faction = FACTION_GM
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi21s/tc13j/chester.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(800)
    client:SetHealth(800)
    client:SetArmor(300)
    client:SetMaxArmor(300)
    client:SetRunSpeed(150)
    local weapons = {
        "weapon_lscs_forcepike",
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_BRU = CLASS.index