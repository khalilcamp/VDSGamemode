ITEM.name = "Seringa de Infusão Bacta"
ITEM.model = "models/niksacokica/equipment/eqp_stimpack.mdl"
ITEM.description = "A seringa de infusão Bacta oferece rápida cicatrização de feridas por meio de uma fórmula concentrada de bacta. Projetado para eficiência e facilidade de uso sob fogo, ele estabiliza rapidamente ferimentos e combate toxinas, garantindo que as tropas imperiais permaneçam prontas para a batalha."
ITEM.category = "Medicina"

ITEM.functions.Stabilize = { 
	name = "Estabilizar",
	tip = "Estabilize o personagem alvo.",
	icon = "icon16/user_add.png",
	OnRun = function(item)
		local player = item.player
		local trace = player:GetEyeTraceNoCursor()
		local target = trace.Entity

		if(!target.ixPlayer) then
			player:Notify("Você deve estar olhando para um jogador!")
			return false
		end
	
		player:SetAction("estabilizando", 10)
		player:DoStaredAction(target, function()
			hook.Run("Revive", target.ixPlayer)
		end, 10)

	end,

	OnCanRun =  function(item)
		local ent = item.player:GetEyeTraceNoCursor().Entity
		
		return ent:IsRagdoll()
	end
}
