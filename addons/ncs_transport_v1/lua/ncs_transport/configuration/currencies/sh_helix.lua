local OBJ = NCS_TRANSPORT.RegisterCurrency("helix")

function OBJ:AddMoney(p, amount)
    if amount > 0 then
        p:GetCharacter():GiveMoney(amount)
    else
        p:GetCharacter():TakeMoney(amount)
    end
end

function OBJ:CanAfford(p, amount)
    if not p:GetCharacter():HasMoney(amount) then
        return false
    else
        return true
    end
end

function OBJ:FormatMoney(amount)
    return ix.currency.Get(amount)
end