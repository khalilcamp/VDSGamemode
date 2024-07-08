if not ATTACHMENT then
	ATTACHMENT = {}
end

ATTACHMENT.Name = "Valken Scope"
ATTACHMENT.ShortName = "RS1"
ATTACHMENT.Description = { 
    --TFA.AttachmentColors["="], "", 
    TFA.AttachmentColors["+"], "Zoom x2", 
    --TFA.AttachmentColors["-"], "", 
}

ATTACHMENT.WeaponTable = {

	["VElements"] = {
		["scope1"] = {
			["active"] = true
		},
	},

	["WElements"] = {
		["scope1"] = {
			["active"] = true
		},
	},

	["Primary"] = {
		["IronAccuracy"] = 0.0005,
	},

	["Secondary"] = {
		["ScopeZoom"] = function(wep, val) return 2 end
	},

	["BlowbackVector"] = Vector(0,-0.75,0),
	["IronSightsPos"] = function( wep, val ) return wep.Scope1Pos or val, true end,
	["IronSightsAng"] = function( wep, val ) return wep.Scope1Ang or val, true end,
	["IronSightTime"] = function( wep, val ) return val * 1.5 end,
	["IronSightMoveSpeed"] = function(stat) return stat * 0.8 end,
	["RTOpaque"] = true,
	["RTScopeAttachment"] = -1,
	["IronSightsSensitivity"] = 0.1,
}

local shadowborder = 500
local cd = {}
local myret
local myshad
local debugcv = GetConVar("cl_tfa_debug_rt")

ATTACHMENT.FOV = fov
ATTACHMENT.Reticule = "#sw/visor/sw_ret_redux_blue"