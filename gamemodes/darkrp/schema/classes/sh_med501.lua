CLASS.name = "Médico 501ST"
CLASS.faction = FACTION_501ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi501/tc13j/medic.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(150)
    client:SetHealth(150)
    client:SetArmor(150)
    client:SetMaxArmor(150)
    local weapons = {
        "weapon_defibrilator",  -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_MED501 = CLASS.index