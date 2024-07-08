if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Westar M5 Scope"
ATTACHMENT.ShortName = "RS2"
ATTACHMENT.Icon = "entities/att/s3.png"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Zoom x6", 
    --TFA.AttachmentColors["-"], "", 
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["scope_base"] = {
			["active"] = true
		},
		["scope2"] = {
			["active"] = true
		},
		["scope2_ret"] = {
			["active"] = true
		},
		["ammo_counter_s2"] = {
			["active"] = true
		},
		["iron"] = {
			["active"] = false
		}
	},

	["WElements"] = {
		["scope_base"] = {
			["active"] = true
		},
		["scope2"] = {
			["active"] = true
		},
		["iron"] = {
			["active"] = false
		}
	},

	["Primary"] = {
		["IronAccuracy"] = 0.0005,
	},

	["Secondary"] = {
		["ScopeZoom"] = function(wep, val) return 6 end
	},

	["BlowbackVector"] = Vector(0,-0.5,0),
	["IronSightsPos"] = function( wep, val ) return wep.Scope2Pos or val, true end,
	["IronSightsAng"] = function( wep, val ) return wep.Scope2Ang or val, true end,
	["IronSightTime"] = function( wep, val ) return val * 1.5 end,
	["IronSightMoveSpeed"] = function(stat) return stat * 0.8 end,
	["RTOpaque"] = true,
	["RTMaterialOverride"] = -1,
	["RTScopeAttachment"] = -1,
	["IronSightsSensitivity"] = 0.25,
}
local shadowborder = 500
local cd = {}
local myret
local myshad
local debugcv = GetConVar("cl_tfa_debug_rt")

ATTACHMENT.FOV = fov
ATTACHMENT.Reticule = "#sw/visor/sw_ret_redux_blue"