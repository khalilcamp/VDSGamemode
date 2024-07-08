CLASS.name = "Keller"
CLASS.faction = FACTION_GM
CLASS.isDefault = false

function CLASS:OnSet(client)
    self:Setup(client)
end

function CLASS:Setup(client)
    client:SetMaxHealth(800)
    client:SetHealth(800)
    client:SetArmor(500) 
    client:SetMaxArmor(500)
    client:SetWalkSpeed(200)
    client:SetRunSpeed(250)
    
    local weapons = {
        "weapon_fists",
    }

    for _, weapon in ipairs(weapons) do
        client:Give(weapon)
    end

    local character = client:GetCharacter()
    if character then
        character:SetModel("models/jajoff/sps/cgi21s/tc13j/keller2.mdl")
    end
end

function CLASS:OnSpawn(client)
    self:Setup(client)
end

CLASS_PES = CLASS.index

