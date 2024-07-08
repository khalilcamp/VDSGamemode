CLASS.name = "Guarda"
CLASS.faction = FACTION_ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgicga/tc13j/rys.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(200)
    client:SetHealth(200)
    client:SetArmor(200)
    client:SetMaxArmor(200)
    local weapons = {
        "rw_sw_shield_rep", -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_GUA = CLASS.index