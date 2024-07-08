-- Item Statistics

ITEM.name = "Equipamento de Escudo"
ITEM.description = "Um dispositvo que gera um escudo protetor a volta de quem usa ganha uma resistência de +200 de AP."
ITEM.price = 300
ITEM.category = "Equipamentos"

-- Item Configuration

ITEM.model = "models/niksacokica/tech/hand_held_device_generic.mdl"
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
            ix.chat.Send(ply, "me", "tu aplicaria o dispositvo.", false)
            return false
        end

        ix.chat.Send(ply, "me", "usa o dispositivo e geraria um escudo em sua volta..", false)
        ply:Freeze(true)
        ply:SetAction("Consumindo...", 3, function()
            local lastHealth = ply:Armor()
            ply:Notify("Você consumiu um pouco de medicamento.")
            ply:Freeze(false)
            ply:SetArmor(ply:Armor() + 200)
            ply:EmitSound("everfall/equipment/squad_shield/start_stop/gadgets_burstshield_start_var_01_02.mp3"..math.random(7,9).."everfall/equipment/squad_shield/start_stop/gadgets_burstshield_start_var_01_02.mp3", 80)
            ply:ViewPunch(Angle(-10, 0, 0))
            timer.Simple(200, function() ply:EmitSound("everfall/equipment/squad_shield/start_stop/gadgets_burstshield_start_var_01_02.mp3") end)
            char:SetData("ixHigh", true)
            timer.Simple(5, function()
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
