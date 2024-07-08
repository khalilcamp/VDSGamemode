CLASS.name = "Escudeiro"
CLASS.faction = FACTION_GM
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi21s/tc13j/marine_officer.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(800)
    client:SetHealth(800)
    client:SetArmor(500)
    client:SetMaxArmor(500)
    client:SetRunSpeed(150)
    local weapons = {
        "rw_sw_shield_rep_dc17",
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_ESC = CLASS.index