-- Item Statistics

ITEM.name = "Adrenalina"
ITEM.description = "Um pequeno tubo ejetor de adrenalina, que tem a capacidade de aumentar a velocidade de quem usa, e não tem efeitos colaterais mas o efeito acaba."
ITEM.price = 300
ITEM.category = "Drogas"

-- Item Configuration

ITEM.model = "models/bf2/compiled 0.34/energy.mdl"
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
            ix.chat.Send(ply, "me", "tu já está sobre efeito de algo mais.", false)
            return false
        end

        ix.chat.Send(ply, "me", "abre a injetor e colocaria ele no braço.", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            local lastSpeed = ply:GetRunSpeed() -- Salva a velocidade atual do jogador
            local newSpeed = math.min(ply:GetRunSpeed() + 100, 1000) -- Aumenta a velocidade em 100, limitando ao máximo de 1000
            ply:SetRunSpeed(newSpeed) -- Define a nova velocidade do jogador
            ply:Freeze(false)
            ply:EmitSound("starwars/items/bacta.wav"..math.random(7,9).."starwars/items/bacta.wav", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(35, function() ply:EmitSound("starwars/items/bacta.wav") end)
            char:SetData("ixHigh", true)
            timer.Simple(300, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetRunSpeed(lastSpeed) -- Restaura a velocidade do jogador para o valor anterior
                    ply:ViewPunch(Angle(-10, 0, 0))
                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}
