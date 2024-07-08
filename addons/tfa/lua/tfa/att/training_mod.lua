if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Training Mod"
ATTACHMENT.ShortName = "T-M"
ATTACHMENT.Icon = "entities/att/trd_mod.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Balas de treino", 
    TFA.AttachmentColors["-"], "Sem dano",
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Damage"] = function(wep,stat) return stat*0.0 end,
	},
	["TracerName"] = "rw_sw_laser_orange",
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "rw_sw_impact_orange"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end
