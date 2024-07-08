CLASS.name = "TROOPER ST"
CLASS.faction = FACTION_ST
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgicga/tc13j/trooper.mdl")
	end
end

CLASS_TST = CLASS.index