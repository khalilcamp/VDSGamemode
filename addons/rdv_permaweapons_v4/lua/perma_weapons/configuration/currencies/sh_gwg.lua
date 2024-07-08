local OBJ = NCS_PERMAWEAPONS.RegisterCurrency("gatewaygaming")

function OBJ:AddMoney(p, amount)
    p:AddBalance(amount)
end

function OBJ:CanAfford(p, amount)
    if p:GetBalance() >= amount then
        return true
    else
        return false
    end
end

function OBJ:FormatMoney(money)
    return string.Comma(money).."RC"
end