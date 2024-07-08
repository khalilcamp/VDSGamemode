-- Item Statistics

ITEM.name = "Tubo de Energia"
ITEM.description = "Um tubo de energia com a capacidade de gerar uma proteção para quem usa, tem efeito colateral se usar muitos, mas dá uma proteção de +800 de AP."
ITEM.price = 256
ITEM.category = "Drogas"

-- Item Configuration

ITEM.model = "models/bf2/compiled 0.34/damage.mdl"
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

        ix.chat.Send(ply, "me", "abre o injetor e colocaria em sua veia ele com um sentimento estranho..", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            local lastHealth = ply:Armor()
            ply:Notify("Você consumiu um pouco de medicamento.")
            ply:Freeze(false)
            ply:SetArmor(ply:Armor() + 800)
            ply:EmitSound("injector_1.wav"..math.random(7,9).."injector_1.wav", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(100, function() ply:EmitSound("injector_1.wav") end)
            char:SetData("ixHigh", true)
            timer.Simple(720, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetHealth(lastHealth)
                    ply:TakeDamage(75)
                    ply:ViewPunch(Angle(-10, 0, 0))
                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}
