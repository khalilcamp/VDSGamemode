CLASS.name = "TROOPER Fuzileiro"
CLASS.faction = FACTION_GM
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi21s/tc13j/marine.mdl")
	end
end

CLASS_TGM = CLASS.index