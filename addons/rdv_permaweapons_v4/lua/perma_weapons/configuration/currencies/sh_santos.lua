local OBJ = NCS_PERMAWEAPONS.RegisterCurrency("santos")

function OBJ:AddMoney(p, amount)
    p:AddMoney(amount)
end

function OBJ:CanAfford(p, amount)
    if not p:CanAfford(amount) then
        return false
    else
        return true
    end
end

function OBJ:FormatMoney(amount)
    return "$"..string.Comma(amount)
end