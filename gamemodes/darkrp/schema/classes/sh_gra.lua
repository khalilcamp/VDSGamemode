CLASS.name = "Granadeiro"
CLASS.faction = FACTION_501ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi501/tc13j/heavy_officer.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(150)
    client:SetHealth(150)
    client:SetArmor(150)
    client:SetMaxArmor(150)
    local weapons = {
        "rw_sw_pinglauncher",
        "rw_sw_nade_thermalsw_emp_grenade",
        "rw_sw_nade_thermal",   -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_GRA = CLASS.index