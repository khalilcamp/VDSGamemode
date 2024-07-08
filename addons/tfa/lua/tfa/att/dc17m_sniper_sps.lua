if not ATTACHMENT then

	ATTACHMENT = {}

end



ATTACHMENT.Name = "Sniper Module"

ATTACHMENT.ShortName = "S.M."
ATTACHMENT.Icon = "entities/att/sniper_module.png"
ATTACHMENT.Description = {"Eliminate Enemies From Range"
}



ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["sniper_module"] = {["active"] = true},
		["sniper_module_scope"] = {["active"] = true},
		["scope_hp1"] = {["active"] = true},
		["scope2_hp2"] = {["active"] = true},
	},

	["WElements"] = {
		["sniper_module"] = {["active"] = true},
		["ironsight"] = {["active"] = true},
	},

	["Primary"] = {
		["Sound"] = "w/dc17msniper.wav",
		["KickUp"] = function(wep,stat) return stat * 2 end,
		["KickDown"] = function(wep,stat) return stat * 2 end,
		["ClipSize"] = 10,
		["RPM"] = 145,
		["Damage"] = 185,
		["IronAccuracy"] = 0.0005,
},
		["IronSightsPos"] = Vector(-5.4, -15.5, 2),
		["IronSightsAng"] = function( wep, val ) return wep.ScopeAng or val, true end,
		["IronSightTime"] = function( wep, val ) return val * 1.20 end,
    	["IronSightMoveSpeed"] = function(stat) return stat * 0.9 end,
		["RTOpaque"] = true,
		["RTMaterialOverride"] = -1,
}

ATTACHMENT.Reticule = "cs574/scopes/dc17msniperret"
function ATTACHMENT:Attach(wep)

	wep:Unload()

end

function ATTACHMENT:Detach(wep)

	wep.ImpactEffect = "rw_sw_impact_blue"

	wep:Unload()

end

if not TFA_ATTACHMENT_ISUPDATING then

	TFAUpdateAttachments()

end

