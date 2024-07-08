CLASS.name = "Avanço"
CLASS.faction = FACTION_GM
CLASS.isDefault = false

function CLASS:OnSet(client)
    self:Setup(client)
end

function CLASS:Setup(client)
    client:SetMaxHealth(450)
    client:SetHealth(450)
    client:SetArmor(300) 
    client:SetMaxArmor(300)
    client:SetWalkSpeed(150)
    client:SetRunSpeed(200)
    
    local weapons = {
        "weapon_fists",
    }

    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end

    local character = client:GetCharacter()
    if character then
        character:SetModel("models/jajoff/sps/cgi21s/tc13j/marine_elite.mdl")
    end
end

function CLASS:OnSpawn(client)
    self:Setup(client)
end

CLASS_PES = CLASS.index

