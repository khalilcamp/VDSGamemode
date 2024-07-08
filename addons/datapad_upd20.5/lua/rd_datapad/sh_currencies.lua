NCS_DATAPAD.CURRENCIES = {}

function NCS_DATAPAD.RegisterCurrency(NAME)
    NCS_DATAPAD.CURRENCIES[NAME] = {}

    return NCS_DATAPAD.CURRENCIES[NAME]
end

function NCS_DATAPAD.CurrencyExists(NAME)
    if not NCS_DATAPAD.CURRENCIES[NAME] then
        return false
    else
        return true
    end
end

--[[
    Currency Functions.
--]]

function NCS_DATAPAD.AddMoney(ply, currency, amount)
    if !currency then
        currency = NCS_DATAPAD.CONFIG.CurrencySystemSelected
    end

    local TAB = NCS_DATAPAD.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.AddMoney) then
        return false
    end

    TAB:AddMoney(ply, amount)
end

function NCS_DATAPAD.CanAfford(ply, currency, amount)
    if !currency then
        currency = NCS_DATAPAD.CONFIG.CurrencySystemSelected
    end

    local TAB = NCS_DATAPAD.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.CanAfford) then
        return false
    end

    return TAB:CanAfford(ply, amount)
end

function NCS_DATAPAD.FormatMoney(currency, amount)
    if !currency then
        currency = NCS_DATAPAD.CONFIG.CurrencySystemSelected
    end
    
    local TAB = NCS_DATAPAD.CURRENCIES[currency]

    if not TAB or not isfunction(TAB.FormatMoney) then
        return false
    end

    return TAB:FormatMoney(amount)
end