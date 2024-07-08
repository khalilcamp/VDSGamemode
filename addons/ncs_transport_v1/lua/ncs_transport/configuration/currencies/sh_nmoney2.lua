local OBJ = NCS_TRANSPORT.RegisterCurrency("nmoney2")

function OBJ:AddMoney(p, amount)
    local MONEY = tonumber(p:GetNWString( "WalletMoney", "0" ))

    p:SetNWString( "WalletMoney", tostring((MONEY + amount)) )
end

function OBJ:CanAfford(p, amount)
    local MONEY = p:GetNWString( "WalletMoney", "0" )

    return tonumber(MONEY) >= amount
end

function OBJ:FormatMoney(money)
    return string.Comma(money)
end