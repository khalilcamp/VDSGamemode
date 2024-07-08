if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Bi-Pod ON"
ATTACHMENT.ShortName = "BP-ON"
ATTACHMENT.Icon = "entities/att/bipod_on.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Perfect Accuracy",
    TFA.AttachmentColors["-"], "Não consegue se mover", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["bipod_on"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["bipod_on"] = {
			["active"] = true
		},
	},
	["Primary"] = {
		["KickUp"] = function(wep,stat) return stat*0.01 end,
		["KickDown"] = function(wep,stat) return stat*0.01 end,
		["Spread"] = function(wep,stat) return stat*0.01 end,
		["IronAccuracy"] = function(wep,stat) return stat*0.01 end,
	},
	["MoveSpeed"] = function(wep,stat) return stat*0.01 end,
	["IronSightsMoveSpeed"] = function(wep,stat) return stat*0.03 end,
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
