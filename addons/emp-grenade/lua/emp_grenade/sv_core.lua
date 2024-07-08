util.AddNetworkString("EMPGrenade.MotionBlur")

EMPGrenade.entityfunctionality = {}
function EMPGrenade:AddCustomEntFunc(class, time, startf, thinkf, endf)
    EMPGrenade.entityfunctionality[class] = {
        cooldown = time or 5,
        startfunc = startf,
        think = thinkf or nil,
        endfunc = endf or nil,
    }
end


EMPGrenade:AddCustomEntFunc("lfs_class", nil, function(ent) ent:StopEngine() end, nil, nil)
EMPGrenade:AddCustomEntFunc("trigger_multiple", nil, function(ent) ent:Fire("Disable") end, nil, function(ent) ent:Fire("Enable") end)
EMPGrenade:AddCustomEntFunc("func_brush", nil, function(ent) ent:Fire("Disable") end, nil, function(ent) ent:Fire("Enable") end)
EMPGrenade:AddCustomEntFunc("env_laser", nil, function(ent) ent:Fire("TurnOff") end, nil, function(ent) ent:Fire("TurnOn") end)
EMPGrenade:AddCustomEntFunc("env_beam", nil, function(ent) ent:Fire("TurnOff") end, nil, function(ent) ent:Fire("TurnOn") end)
EMPGrenade:AddCustomEntFunc("func_tanktrain", nil, function(ent) ent:Fire("Stop") end, nil, function(ent) ent:Fire("Resume") end)
EMPGrenade:AddCustomEntFunc("shield_class", nil, function(ent) if ent:GetSequence() == 3 then ent:CloseShield() end end)


local shieldclasses = {
    ["shield_1"] = true,
    ["shield_2"] = true,
    ["shield_3"] = true,
    ["shield_4"] = true,
    ["shield_5"] = true,
}

EMPGrenade.disabledents = {}
function EMPGrenade:DisableEntUse(ent,class)
    local data = EMPGrenade.entityfunctionality[class]
    if not data or not IsValid(ent) then return end
    if EMPGrenade.disabledents[ent] then return end
    data.endtime = CurTime() + data.cooldown
    EMPGrenade.disabledents[ent] = data
    if data.startfunc != nil then data.startfunc(ent) end
end

function EMPGrenade:HandleShock(ent,entpos)
	local EntsInRange = ents.FindInSphere( entpos, 150 )

	for k, v in ipairs(EntsInRange) do
    	if not IsValid(v) then continue end
        local isnpc = v:IsNPC() or v:IsNextBot()
        local isply = v:IsPlayer()

        local hkbl = hook.Run("EMPGrenade:ShockedEnt", v, entpos)
        if hkbl == true then continue end

		if isnpc or isply then
			if not EMPGrenade:IsDroid(v:GetModel()) then 		
				if isply then		
					net.Start("EMPGrenade.MotionBlur")
					net.Send(v)
				end
				continue 
			end
				
			local dmg = DamageInfo()
			local ow = ent:GetOwner()

			dmg:SetDamage( EMPGrenade:CalculateDamage(v) )
			dmg:SetAttacker( ow and ow or ent )
			dmg:SetInflictor(ent)
			dmg:SetDamageType( DMG_SHOCK ) 
			v:TakeDamageInfo( dmg )
		else
			local class = v:GetClass()
            if EMPGrenade.entityfunctionality[class] then 
                EMPGrenade:DisableEntUse(v,class)
                continue
            end

            if v.GetlfsLockedStatus != nil then 
                EMPGrenade:DisableEntUse(v,"lfs_class")
            elseif shieldclasses[class] then
                EMPGrenade:DisableEntUse(v,"shield_class")
            end

		end
	end
end

local cld = 0
hook.Add("Think", "EMPGrenade:Think", function()
if cld > CurTime() then return end
cld = CurTime() + 1
if not EMPGrenade.disabledents or table.Count(EMPGrenade.disabledents) <= 0 then return end
    for ent,data in pairs(EMPGrenade.disabledents) do
        if not IsValid(ent) then EMPGrenade.disabledents[ent] = nil continue end -- ent invalid
        if data.endtime <= CurTime() then -- time over
            if data.endfunc != nil then data.endfunc(ent) end 
            EMPGrenade.disabledents[ent] = nil 
            continue 
        end
        if data.think != nil then data.think(ent) end
    end
end)