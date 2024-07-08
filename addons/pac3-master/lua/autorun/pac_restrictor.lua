-- add/change rank names here in the same format
local ranks = {
	["Jedi"] = true,
	["owner"] = true,
	["superadmin"] = true,
    ["Vip"] = true,
    ["GameMaster"] = true
}
hook.Add("PrePACConfigApply", "PACRankRestrict", function(ply)
	if not ranks[ply:GetUserGroup()] then
              return false,"Insufficient rank to use PAC."
        end
end)