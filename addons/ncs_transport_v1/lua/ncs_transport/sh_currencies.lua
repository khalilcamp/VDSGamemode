NCS_TRANSPORT.CURRENCIES = {}

function NCS_TRANSPORT.RegisterCurrency(NAME)
    NCS_TRANSPORT.CURRENCIES[NAME] = {}

    return NCS_TRANSPORT.CURRENCIES[NAME]
end

function NCS_TRANSPORT.CurrencyExists(NAME)
    if not NCS_TRANSPORT.CURRENCIES[NAME] then
        return false
    else
        return true
    end
end

--[[
    Currency Functions.
--]]

function NCS_TRANSPORT.AddMoney(ply, currency, amount)
    if !currency then
        currency = NCS_TRANSPORT.CONFIG.currency
    end

    local TAB = NCS_TRANSPORT.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.AddMoney) then
        return false
    end

    TAB:AddMoney(ply, amount)
end

function NCS_TRANSPORT.CanAfford(ply, currency, amount)
    if !currency then
        currency = NCS_TRANSPORT.CONFIG.currency
    end

    local TAB = NCS_TRANSPORT.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.CanAfford) then
        return false
    end

    amount = tonumber(amount)
    
    return TAB:CanAfford(ply, amount)
end

function NCS_TRANSPORT.FormatMoney(currency, amount)
    if !currency then
        currency = NCS_TRANSPORT.CONFIG.currency
    end
    
    local TAB = NCS_TRANSPORT.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.FormatMoney) then
        return false
    end

    amount = tonumber(amount)

    return TAB:FormatMoney(amount)
end