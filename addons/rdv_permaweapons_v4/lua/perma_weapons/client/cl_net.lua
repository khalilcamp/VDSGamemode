net.Receive("NCS_PMW_SaveConfig", function()
    local BYTES = net.ReadUInt( 16 )
    local DATA = net.ReadData(BYTES)

    local DECOMPRESSED = util.Decompress(DATA)
    local TAB = util.JSONToTable(DECOMPRESSED)

    NCS_PERMAWEAPONS.CFG = TAB
end )

net.Receive("NCS_PERMAWEAPONS_UpdateSale", function(_, P)
    local CLASS = net.ReadString()
    local DISCOUNT = net.ReadUInt(32)
    local DURATION = net.ReadUInt(32)

    if !NCS_PERMAWEAPONS.WEAPONS[CLASS] then return end
    
    NCS_PERMAWEAPONS.WEAPONS[CLASS].SALE = {
        DURATION = DURATION,
        DISCOUNT = DISCOUNT,
    }
end )