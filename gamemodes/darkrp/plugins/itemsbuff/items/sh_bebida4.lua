-- Item Statistics

ITEM.name = "Fruta"
ITEM.description = "Uma fruta normal."
ITEM.price = 200
ITEM.category = "Bebidas e Comidas"

-- Item Configuration

ITEM.model = "models/food/shuura.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.bDropOnDeath = true
ITEM.illegal = true

-- Item Functions

ITEM.functions.Apply = {
    name = "Consumir",
    icon = "materials/hud/bebida.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        if char:GetData("ixHigh") then
            ix.chat.Send(ply, "me", "tu está meio cheio para mais um.", false)
            return false
        end

        ix.chat.Send(ply, "me", "comeria a comida no prato e estaria com cheiro bom.", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            local lastHealth = ply:Health()
            ply:Notify("Você consumiu um pouco de comida.")
            ply:Freeze(false)
            ply:SetHealth(ply:Health() + 10)
            ply:EmitSound(""..math.random(7,9)..".wav", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(1, function() ply:EmitSound("") end)
            char:SetData("ixHigh", true)
            timer.Simple(10, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetHealth(lastHealth)
                    ply:ViewPunch(Angle(-10, 0, 0))
                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}
