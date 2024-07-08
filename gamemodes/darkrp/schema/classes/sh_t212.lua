CLASS.name = "TROOPER 212"
CLASS.faction = FACTION_212ST
CLASS.isDefault = true

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetModel("models/jajoff/sps/cgi212/tc13j/trooper.mdl")
	end
end

CLASS_T212 = CLASS.index