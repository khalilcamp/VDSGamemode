-- Item Statistics

ITEM.name = "Stimpack de Pulo"
ITEM.description = "Um stimpack que tem capacidade de aumentar a altura de quem usa, embora que tenha uso temporário ainda é útil, e não tem consequências ao uso."
ITEM.price = 300
ITEM.category = "Drogas"

-- Item Configuration

ITEM.model = "models/niksacokica/equipment/eqp_stimpack_poison.mdl"
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

        if char:GetData("ixHigh") then
            ix.chat.Send(ply, "me", "tu está meio de outro efeito.", false)
            return false
        end

        ix.chat.Send(ply, "me", "injetaria o líquido.", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            local lastJumpPower = ply:GetJumpPower() -- Salva a altura do pulo atual do jogador
            local newJumpPower = math.min(ply:GetJumpPower() + 250, 600) -- Aumenta a altura do pulo em 50, limitando ao máximo de 600
            ply:SetJumpPower(newJumpPower) -- Define a nova altura do pulo do jogador
            ply:Freeze(false)
            ply:EmitSound("pills_4.wav"..math.random(7,9).."pills_4.wav", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(20, function() ply:EmitSound("pills_4.wav") end)
            char:SetData("ixHigh", true)
            timer.Simple(20, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetJumpPower(lastJumpPower) -- Restaura a altura do pulo do jogador para o valor anterior
                    ply:ViewPunch(Angle(-10, 0, 0))
                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}

