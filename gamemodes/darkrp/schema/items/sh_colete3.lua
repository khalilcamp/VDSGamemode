-- Item Statistics

ITEM.name = "Bateria Pesada"
ITEM.description = "Um colete junto a um conjunto de placas pesadas, prontas para resistir armamentos pesados, com a totalidade de +80 de AP."
ITEM.price = 400
ITEM.category = "Equipamentos"

-- Item Configuration

ITEM.model = "models/starwars/items/shield_large.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 2
ITEM.height = 2

-- Item Custom Configuration

ITEM.ArmorAmount = 80
ITEM.Volume = 80
ITEM.bDropOnDeath = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Restaurar PCV",
    icon = "darkrpg/hud/armor_icon.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player

        if ( ply:IsValid() and ( ply:Armor() < ply:GetMaxArmor() ) ) then
            return true
        else
            return false
        end
    end,
    OnRun = function(itemTable)
        local ply = itemTable.player
        ix.chat.Send(ply, "me", "carregou uma "..itemTable.name.." em sua armadura.", false)
        ply:Lock()
        ply:SetAction("Carregamento "..itemTable.name.."...", 4, function()
            ply:SetArmor(math.min(ply:Armor() + itemTable.ArmorAmount, ply:GetMaxArmor()))
            ply:EmitSound("starwars/items/shield.wav", itemTable.Volume)

            ply:Notify("Você carregou um "..itemTable.name.." em sua armadura e você ganhou mais blindagem PCV.")
            ply:UnLock()
            return true
        end)
    end
}

ITEM.functions.ApplyTarget = {
    name = "Restaurar PCV alvo",
    icon = "darkrpg/hud/armor_icon.png",
    OnCanRun = function(itemTable)
        local ply = itemTable.player
        local data = {}
            data.start = ply:GetShootPos()
            data.endpos = data.start + ply:GetAimVector() * 96
            data.filter = ply
        local target = util.TraceLine(data).Entity

        if ( IsValid(target) and target:IsPlayer() ) and ( target:Armor() < target:GetMaxArmor() ) then
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
                ix.chat.Send(ply, "me", "carregar uma "..itemTable.name.." na pessoa à sua frente.", false)
                ply:Lock()
                target:Lock()
                ply:SetAction("Carregando "..itemTable.name.."...", 4, function()
                    ply:EmitSound("starwars/items/shield.wav", itemTable.Volume)
                    target:EmitSound("starwars/items/shield.wav", itemTable.Volume)
                    target:SetArmor(math.min(target:Armor() + itemTable.ArmorAmount, target:GetMaxArmor()))

                    ply:Notify("Você carregou um "..itemTable.name.." na armadura de seus alvos e eles ganharam a blindagem PCV.")
                    target:Notify(ply:Nick().." carregou um "..itemTable.name.." em sua armadura e você ganhou mais blindagem PCV.")
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
