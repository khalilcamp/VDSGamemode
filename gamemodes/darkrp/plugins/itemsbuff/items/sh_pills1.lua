-- Item Statistics

ITEM.name = "Caixa de DeathSticks"
ITEM.description = "Uma caixa pequena, com varios deathsticks, não são tão bons assim para saúde, mas ajudam caso precise de algo."
ITEM.price = 250
ITEM.category = "Drogas"

-- Item Configuration

ITEM.model = "models/props_junk/cardboard_box004a.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.bDropOnDeath = true
ITEM.illegal = false

-- Item Functions

ITEM.functions.Apply = {
    name = "Consumir",
    icon = "materials/hud/droga.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        if ( math.random(1,4) == 4 ) and ( char:GetData("ixHigh") ) then
            ix.chat.Send(ply, "me", "cai no chão e morre lentamente devido à overdose.", false)
            ply:Notify("Você morreu de overdose!")
            ply:Kill()
            return false
        end

        ix.chat.Send(ply, "me", "abre uma pequena caixa e começa a fumar os sticks vermelhas.", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 1, function()
            local lastHealth = ply:Health()
            ply:Notify("Você consumiu um pouco de medicamento.")
            ply:Freeze(false)
            ply:SetHealth(ply:Health() + 150)
            ply:EmitSound(""..math.random(7,9).."", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(5, function() ply:EmitSound("") end)
            char:SetData("ixHigh", true)
            timer.Simple(20, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetHealth(lastHealth)
                    ply:TakeDamage(27)
                    ply:ViewPunch(Angle(-10, 0, 0))
                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}
