CLASS.name = "Engenheiro de Campo"
CLASS.faction = FACTION_212ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi212/tc13j/specialist.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(150)
    client:SetHealth(150)
    client:SetArmor(150)
    client:SetMaxArmor(150)
    local weapons = {
        "weapon_lvsrepair",
        "fort_datapad",  -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_ENG = CLASS.index