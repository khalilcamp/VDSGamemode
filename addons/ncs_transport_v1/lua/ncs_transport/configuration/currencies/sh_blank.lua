local OBJ = NCS_TRANSPORT.RegisterCurrency("blank")

function OBJ:AddMoney(p, amount)
    
end

function OBJ:CanAfford(p, amount)
    return true
end

function OBJ:FormatMoney(money)
    return string.Comma(money)
end