CLASS.name = "TROOPER 501"
CLASS.faction = FACTION_501ST
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi501/tc13j/trooper.mdl")
	end
end

CLASS_T501 = CLASS.index