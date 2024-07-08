if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Stealth Mod"
ATTACHMENT.ShortName = "STLH-M"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change to Stealth Rounds", 

}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = Sound ("w/dc19.wav"),
	},
	["TracerName"] = "rw_sw_laser_black",
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "rw_sw_impact_black"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_black"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
