if not ATTACHMENT then
	ATTACHMENT = {}
end



ATTACHMENT.Name = "Grenade Launcher Module"
ATTACHMENT.ShortName = "G.L.M."
ATTACHMENT.Icon = "entities/att/grenade_module.png"
ATTACHMENT.Description = {
}



ATTACHMENT.WeaponTable = {
	["VElements"] = {
		["grenade_module"] = {["active"] = true},
	},
	["WElements"] = {
		["grenade_module"] = {["active"] = true},
	},
	["Primary"] = {
		["Sound"] = "everfall/weapons/dc-17m/launcher/blasters_dc17m_laser_altfire_close_var_03.mp3",
		["DamageType"] = function(wep,stat) return bit.bor( stat or 0, DMG_BLAST ) end,	
		["KickUp"] = function(wep,stat) return stat * 4 end,
		["KickDown"] = function(wep,stat) return stat * 4 end,
		["Damage"] = 400,
		["Ammo"] = "ar2",
		["ClipSize"] = 1,
		["RPM"] = 200,
	},
}



function ATTACHMENT:Attach(wep)
	wep.ImpactEffect = "Explosion"
	wep:Unload()
end



function ATTACHMENT:Detach(wep)
	wep.ImpactEffect = "rw_sw_impact_blue"
	wep:Unload()
end

if not TFA_ATTACHMENT_ISUPDATING then
	TFAUpdateAttachments()
end