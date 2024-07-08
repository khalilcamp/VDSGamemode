local OBJ = NCS_PERMAWEAPONS.RegisterCurrency("basewars")

function OBJ:AddMoney(p, amount)
    p:GiveMoney(amount)
end

function OBJ:CanAfford(p, amount)
    return p:GetMoney() >= amount
end

function OBJ:FormatMoney(money)
    return string.Comma(money)
end