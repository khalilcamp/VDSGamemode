local OBJ = NCS_TRANSPORT.RegisterCurrency("nutscript")

function OBJ:AddMoney(p, amount)
    if amount > 0 then
        p:getChar():giveMoney(amount)
    else
        p:getChar():takeMoney(amount)
    end
end

function OBJ:CanAfford(p, amount)
    if not p:getChar():hasMoney(amount) then
        return false
    else
        return true
    end
end

function OBJ:FormatMoney(amount)
    return nut.currency.get(amount)
end