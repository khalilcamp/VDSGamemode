function NCS_PERMAWEAPONS.CanUse(ply, wep)
    if !IsValid(ply) then return false end

    if !NCS_PERMAWEAPONS.WEAPONS[wep] then 
        return false 
    end

    local CAN = hook.Run("NCS_PMW_CanUseWeapon", ply, wep)
    if CAN == false then return false end

    local TAB = NCS_PERMAWEAPONS.WEAPONS[wep]

    if CAN == true then
        goto skipcheck
    end


    if ( TAB.TEAMS and !table.IsEmpty(TAB.TEAMS) ) and !TAB.TEAMS[team.GetName(ply:Team())] then return false end
    if TAB.LEVEL and RDV and RDV.SAL and RDV.SAL.GetLevel(ply) < TAB.LEVEL then return false end

    if TAB.RANKS and !table.IsEmpty(TAB.RANKS) then
        local B, R = nil, nil

        if RDV and RDV.RANK then
            B = RDV.RANK.GetPlayerRankTree(ply)
            R = RDV.RANK.GetPlayerRank(ply)
        elseif MRS then
            B = MRS.GetPlayerGroup(ply:Team())
            R = MRS.GetPlyRank(ply, B)
        end

        if TAB.RANKS[B] then
            if (TAB.RANKS[B] > R ) then return false end
        else
            return false
        end
    end

    ::skipcheck::

    return true
end

function NCS_PERMAWEAPONS.IsAdmin(P, CB)
    if NCS_PERMAWEAPONS.CFG.camienabled then
        CAMI.PlayerHasAccess(P, "[NCS] PermaWeapons", function(ACCESS)
            CB(ACCESS)
        end )
    else
        if NCS_PERMAWEAPONS.CFG.admins[P:GetUserGroup()] then
            CB(true)
        else
            CB(false)
        end
    end
end

hook.Add("Think", "NCS_PERMAWEAPONS_UpdateSale", function()
    for k, v in pairs(NCS_PERMAWEAPONS.WEAPONS) do
        if v.SALE and v.SALE["DURATION"] and ( v.SALE["DURATION"] < os.time() ) then 
            v.SALE = nil 
        end
    end
end )