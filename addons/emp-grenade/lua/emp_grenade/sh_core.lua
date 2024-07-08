hook.Add( "Initialize", "EMPGrenade.Ammo", function()
	game.AddAmmoType( {
		name = "emp_grenade",
        dmgtype = DMG_BLAST,
	} )
end )

local identifiers = {
    "droid",
    "b1",
    "b2",
    "magma",
  	"aqua",
  	"bx",
}

local mdlcache = {}
function EMPGrenade:IsDroid(model)
    if not model or not isstring(model) then return end

    if mdlcache[model] != nil then return mdlcache[model] end -- cache
    if EMPGrenade.ModelOverride[model] then -- config
        return EMPGrenade.ModelOverride[model] != false and true or false
    end
    
    for k,v in pairs( identifiers ) do
        if string.find(model, v) then
            mdlcache[model] = true
            return true
        end
    end

    mdlcache[model] = false
    return false
end

function EMPGrenade:CalculateDamage(ent)
    if not ent or not IsValid(ent) then return end
    local model = ent:GetModel()
    if not model then return end
    local dmg = EMPGrenade.damage
    local cfg = EMPGrenade.ModelOverride[model]

    if cfg != nil then -- config override
        if isnumber(cfg) then return cfg end
        if cfg then return ent:Health() end
        return 0
    end

    if isnumber(dmg) then return dmg end
    if dmg then return ent:Health() end
    return 0
end