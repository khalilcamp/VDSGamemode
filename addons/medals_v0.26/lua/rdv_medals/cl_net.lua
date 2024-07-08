net.Receive("RDV_MEDALS_CREATE", function()
    local UID = net.ReadUInt(32)
    local NAME = net.ReadString()
    local IMGUR = net.ReadString()
    local MAX = net.ReadUInt(8)
    local CASH = net.ReadUInt(32)

    RDV.MEDALS.Register(NAME, {
        ID = UID,
        ICON = IMGUR,
        REWARD = (CASH or 0),
        MAX = ( MAX or 0 ),
        COLOR = Color(226,230,28),
    })
end )

net.Receive("RDV_MEDALS_SendPayload", function()
    local LEN = net.ReadUInt(32)
    local DATA = net.ReadData(LEN)

    local UNCOMP = util.Decompress(DATA)

	if (!UNCOMP) then
		return
	end

	local FINAL = util.JSONToTable(UNCOMP)

    for k, v in pairs(FINAL) do
        RDV.MEDALS.Register(v.Name, {
            ID = k,
            ICON = v.ICON,
            REWARD = ( v.REWARD or 0 ),
            MAX = ( v.MAX or 0),
            COLOR = Color(226,230,28),
        })
    end
end )

net.Receive("RDV_MEDALS_DELETE", function()
    local UID = net.ReadUInt(32)
    local M_NAME = RDV.MEDALS.LIST[UID]

    if !M_NAME then return end

    RDV.MEDALS.LIST[UID] = nil
    RDV.MEDALS.CACHE_LIST[M_NAME] = nil
end )