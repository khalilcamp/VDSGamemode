if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Destabilized Mod"
ATTACHMENT.ShortName = "D-M"
ATTACHMENT.Icon = "entities/att/des_mod.png"
ATTACHMENT.Description = { 
    TFA.AttachmentColors["="], "Change to Destabilized Rounds", 
    TFA.AttachmentColors["+"], "+100% RPM",
    TFA.AttachmentColors["+"], "-50% BurstDelay",
    TFA.AttachmentColors["-"], "-40% Damage",
}

ATTACHMENT.WeaponTable = {
	["Primary"] = {
		["Sound"] = "w/ci_light.wav",
		["Damage"] = function(wep,stat) return stat*0.4 end,
		["RPM"] = function(wep,stat) return stat*2 end,
		["RPM_Burst"] = function(wep,stat) return stat*2 end,
		["BurstDelay"] = function(wep,stat) return stat/2 end,
	},

	["TracerName"] = "rw_sw_laser_aqua",
	
	["VElements"] = {
		["destab1"] = {
			["active"] = true
		},	
		["destab2"] = {
			["active"] = true
		},	
		["destab3"] = {
			["active"] = true
		},	
	},

	["WElements"] = {
		["destab1"] = {
			["active"] = true
		},	
		["destab2"] = {
			["active"] = true
		},	
		["destab3"] = {
			["active"] = true
		},
	},
}

function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "rw_sw_impact_aqua"
	wep:Unload()
end

function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end