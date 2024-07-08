NCS_PERMAWEAPONS.CURRENCIES = {}

function NCS_PERMAWEAPONS.RegisterCurrency(NAME)
    NCS_PERMAWEAPONS.CURRENCIES[NAME] = {}

    return NCS_PERMAWEAPONS.CURRENCIES[NAME]
end

function NCS_PERMAWEAPONS.CurrencyExists(NAME)
    if not NCS_PERMAWEAPONS.CURRENCIES[NAME] then
        return false
    else
        return true
    end
end

--[[
    Currency Functions.
--]]

function NCS_PERMAWEAPONS.AddMoney(ply, currency, amount)
    if !currency then
        currency = NCS_PERMAWEAPONS.CFG.currency
    end

    local TAB = NCS_PERMAWEAPONS.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.AddMoney) then
        return false
    end

    TAB:AddMoney(ply, amount)
end

function NCS_PERMAWEAPONS.CanAfford(ply, currency, amount)
    if !currency then
        currency = NCS_PERMAWEAPONS.CFG.currency
    end

    local TAB = NCS_PERMAWEAPONS.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.CanAfford) then
        return false
    end

    amount = tonumber(amount)
    
    return TAB:CanAfford(ply, amount)
end

function NCS_PERMAWEAPONS.FormatMoney(currency, amount)
    if !currency then
        currency = NCS_PERMAWEAPONS.CFG.currency
    end
    
    local TAB = NCS_PERMAWEAPONS.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.FormatMoney) then
        return false
    end

    amount = tonumber(amount)

    return TAB:FormatMoney(amount)
end