CLASS.name = "Artilheiro de Campo"
CLASS.faction = FACTION_212ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi212/tc13j/trooper.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(150)
    client:SetHealth(150)
    client:SetArmor(150)
    client:SetMaxArmor(150)
    local weapons = {
        "mortar_constructor",
        "mortar_range_finder",
        "turret_placer",  -- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_ART = CLASS.index