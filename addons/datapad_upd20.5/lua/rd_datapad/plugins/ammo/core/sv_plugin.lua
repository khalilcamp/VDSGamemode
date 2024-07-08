local OBJ = NCS_DATAPAD.GetPlugin()

util.AddNetworkString("RDV_DATAPAD_purchaseAmmo")

net.Receive("RDV_DATAPAD_purchaseAmmo", function(len, ply)
    local TYPE = net.ReadUInt(8)

    local CFG = NCS_DATAPAD.CONFIG.AMMOLIST[TYPE]

    if !CFG then return end

    if NCS_DATAPAD.CanAfford(ply, nil, CFG.P) then
        ply:GiveAmmo(CFG.C, CFG.T)
        
        NCS_DATAPAD.AddMoney(ply, nil, -CFG.P)
    end
end)