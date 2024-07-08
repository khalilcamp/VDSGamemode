if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Bi-Pod OFF"
ATTACHMENT.ShortName = "BP-OFF"
ATTACHMENT.Icon = "entities/att/bipod_off.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
}

ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["bipod_off"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["bipod_off"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
end

function ATTACHMENT:Detach(wep)
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
