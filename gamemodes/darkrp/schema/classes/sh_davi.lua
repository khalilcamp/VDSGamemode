CLASS.name = "Davi"
CLASS.faction = FACTION_501ST
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi501/tc13j/arc_arf.mdl")
	end
end

function CLASS:OnSpawn(client)
    client:SetMaxHealth(250)
    client:SetHealth(250)
    client:SetArmor(200)
    client:SetMaxArmor(200)
    local weapons = {
    	"rw_sw_z6",
        "rw_sw_dual_dc17s",
        "rw_sw_valken38x",
    	"weapon_bactanade",
    	"weapon_bactainjector",
    	"weapon_defibrilator",-- Substitua por armas específicas    -- Substitua por armas específicas
    }

    -- Dar armas ao jogador
    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end
end

CLASS_DAVI = CLASS.index