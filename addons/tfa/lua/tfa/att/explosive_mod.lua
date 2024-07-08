if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Explosive Mod"
ATTACHMENT.ShortName = "E-M"
ATTACHMENT.Icon = "lvs/weapons/laserbeam.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Muda para munição explosiva",
    TFA.AttachmentColors["+"], "Adiciona dano explosivo",
    TFA.AttachmentColors["+"], "+350% dano",
    TFA.AttachmentColors["-"], "+400% Consumo de munição",
    TFA.AttachmentColors["-"], "-66% RPM",
    TFA.AttachmentColors["-"], "+220% Coice",
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = "weapons/star_wars_battlefront/common/exp_ord_rocket_small02.wav",
		["Damage"] = function(wep,stat) return stat*4.5 end,
		["RPM"] = function(wep,stat) return stat*0.33 end,
		["DamageType"] = DMG_DIRECT,
		["AmmoConsumption"] = 10,
		["KickUp"] = function(wep,stat) return stat*32/5 end,
		["KickDown"] = function(wep,stat) return stat*32/5 end,
	},
	
	["Secondary"] = {
		["ClipSize"] = 1,
	},

	["TracerName"] = "rw_sw_laser_yellow",

	["VElements"] = {
		["cell_mod"] = {
			["active"] = true
		},	
	},
	["WElements"] = {
		["cell_mod"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "sw_explosion"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end