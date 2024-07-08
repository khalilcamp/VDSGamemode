local PLUGIN = PLUGIN
ITEM.name = "Algemas"
ITEM.description = "São compostos por duas partes, ligadas entre si por uma barra rígida. Cada metade tem um braço giratório que engata em uma catraca."
ITEM.price = 25
ITEM.model = "models/niksacokica/tech/hand_held_ravager_device.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()
		and !target:GetNetVar("tying") and !target:IsRestricted()) then
			local angDiff = math.AngleDifference(client:GetAngles().y, target:GetAngles().y)
			if not (angDiff > - 45 and angDiff < 45) then client:Notify("Você deve estar de frente para as costas deste jogador.") return false end

			itemTable.bBeingUsed = true

			client:SetAction("detaining", PLUGIN.time)

			client:DoStaredAction(target, function()
				target:SetCuffAnim(true)
				target:SetRestricted(true)
				target:SetNetVar("tying")
				target:SetNetVar("cuffs", true)
				target:NotifyLocalized("fTiedUp")

				itemTable:Remove()
			end, PLUGIN.time, function()
				client:SetAction()

				target:SetAction()
				target:SetNetVar("tying")

				itemTable.bBeingUsed = false
			end)

			target:SetNetVar("tying", true)
			target:SetAction("being detained", PLUGIN.time)
		else
			itemTable.player:NotifyLocalized("plyNotValid")
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
