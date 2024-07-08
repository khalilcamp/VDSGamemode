-- Item Statistics

ITEM.name = "Tubo de Bacta"
ITEM.description = "Um tubo com um líquido azul dentro, chamada bacta, essa substância é usada para fins medicinais já a um tempo, dando +35 de vida por uso."
ITEM.price = 45
ITEM.category = "Medicina"

-- Item Configuration

ITEM.model = "models/weapons/star_wars_battlefront/bacta.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.HealAmount = 35
ITEM.Volume = 80
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Tratar a si mesmo",
    icon = "materials/hud/med.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ( ply:Health() < ply:GetMaxHealth() ) ) and not ( ply:GetNWBool("ixHealing", false) == true ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        ix.chat.Send(ply, "me", "aplica um "..itemTable.name.." em si mesmo.", false)
        ply:SetNWBool("ixHealing", true)
        ply:SetAction("Aplicando "..itemTable.name.."...", 3, function()
            ply:SetHealth(math.min(ply:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medical", 0), ply:GetMaxHealth()))
            ply:EmitSound("starwars/items/bacta.wav", itemTable.Volume)

            ply:Notify("Você aplicou um "..itemTable.name.." em si mesmo e você ganhará saúde.")
            ply:SetNWBool("ixHealing", false)
            return true
        end)
    end
}

ITEM.functions.ApplyTarget = {
    name = "Tratar o alvo",
    icon = "materials/hud/med.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) and ( target:Health() < target:GetMaxHealth() ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) then
            if ( target:GetCharacter() ) then
                ix.chat.Send(ply, "me", "aplica um "..itemTable.name.." na pessoa à sua frente.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Aplicando "..itemTable.name.."...", 4, function()
                    ply:EmitSound("starwars/items/bacta.wav", itemTable.Volume)
                    target:EmitSound("starwars/items/bacta.wav", itemTable.Volume)
                    target:SetHealth(math.min(target:Health() + itemTable.HealAmount + ply:GetCharacter():GetAttribute("attribute_medical", 10), target:GetMaxHealth()))

                    ply:Notify("Você aplicou um "..itemTable.name.." em seu alvo e ele ganhou vida.")
                    target:Notify(ply:Nick().." aplicou um "..itemTable.name.." em você e você ganhou saúde.")
                    ply:UnLock()
                    target:UnLock()
                    return true
                end)
                return true
            end
        end

        return false
    end
}
