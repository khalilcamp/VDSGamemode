CLASS.name = "Riot"
CLASS.faction = FACTION_ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgicga/tc13j/stone.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(200)
    client:SetHealth(200)
    client:SetArmor(200)
    client:SetMaxArmor(200)
    local weapons = {
        "rw_sw_stun_dc15s",
        "rw_sw_nade_stun",
        "ix_stunstick", -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_RIOT = CLASS.index