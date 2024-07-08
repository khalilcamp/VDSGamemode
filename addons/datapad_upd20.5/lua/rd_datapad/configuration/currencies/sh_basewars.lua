local OBJ = NCS_DATAPAD.RegisterCurrency("basewars")

function OBJ:AddMoney(p, amount)
    p:GiveMoney(amount)
end

function OBJ:CanAfford(p, amount)
    return p:GetMoney() >= amount
end

function OBJ:FormatMoney(money)
    return string.Comma(money)
end