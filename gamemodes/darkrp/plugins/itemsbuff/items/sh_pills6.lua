-- Item Statistics

ITEM.name = "Equipamento de Infiltração"
ITEM.description = "Equipamento projetada pelas maiores industrias da galáxia, com a visão de passar tropas por lugares complicados junto a uma camuflagem complexa e eficiênte."
ITEM.price = 300
ITEM.category = "Equipamentos"

-- Item Configuration

ITEM.model = "models/niksacokica/tech/tech_med_scanner.mdl"
ITEM.skin = 0

-- Item Inventory Size Configuration

ITEM.width = 1
ITEM.height = 1

-- Item Custom Configuration

ITEM.bDropOnDeath = true
ITEM.illegal = false

-- Item Functions

ITEM.functions.Apply = {
    name = "Usar",
    icon = "materials/hud/equip.png",
    OnRun = function(itemTable)
        local ply = itemTable.player
        local char = ply:GetCharacter()

        if char:GetData("ixHigh") then
            ix.chat.Send(ply, "me", "tu está com o efeito de um equipamento.", false)
            return false
        end


        ix.chat.Send(ply, "me", "abre a caixa e ligaria ele, o mesmo deixaria uma capa sobre o si mesmo..", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            ply:SetNoTarget(true) -- Ativa o modo Notarget para o jogador
            ply:Freeze(false)
            ply:EmitSound("everfall/equipment/radio/radio_static_republic_stop_01_05.mp3"..math.random(7,9).."everfall/equipment/radio/radio_static_republic_stop_01_05.mp3", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(1200, function() ply:EmitSound("everfall/equipment/radio/radio_static_republic_stop_01_05.mp3") end)
            char:SetData("ixHigh", true)
            
            -- Aplica o material transparente sobre o jogador
            ply:SetMaterial("models/shadertest/shader3")

            timer.Simple(1200, function()
                if ( char:GetData("ixHigh") ) then
                    ply:Notify("Seu efeito se desgastou...")
                    ply:SetNoTarget(false) -- Desativa o modo Notarget para o jogador
                    ply:ViewPunch(Angle(-10, 0, 0))

                    -- Remove o material aplicado sobre o jogador
                    ply:SetMaterial("")

                    char:SetData("ixHigh", nil)
                end
            end)
            return true
        end)
    end
}
