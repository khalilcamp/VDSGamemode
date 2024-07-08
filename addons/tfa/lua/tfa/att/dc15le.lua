if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "LE Mod"
ATTACHMENT.ShortName = "LE-M"
ATTACHMENT.Icon = "entities/att/le_mod.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change to LongRange Mod", 
    TFA.AttachmentColors["+"], "+100% Damages", 
    TFA.AttachmentColors["-"], "-50% RPM", 
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep,stat) return stat*2 end,
		["RPM"] = function(wep,stat) return stat/2 end,
		["RPM_Burst"] = function(wep,stat) return stat/2 end,
	},
}

function ATTACHMENT:Attach(wep)
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
