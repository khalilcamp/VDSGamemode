resource.AddFile("resource/fonts/Lato-Regular.ttf")

util.AddNetworkString("ixDisplayUpdate")
util.AddNetworkString("ixDisplayInfo")
util.AddNetworkString("ixDisplayConfig")

local PLUGIN = PLUGIN

function PLUGIN:UpdateInfo(contents)
    -- netstream.Start(nil, "ixDisplayInfo", contents)
    net.Start("ixDisplayInfo")
        net.WriteTable(contents)
    net.Broadcast()

    self:SetData(contents)
end

function PLUGIN:PlayerInitialSpawn(client)
    local contents = self:GetData() or {}

    -- netstream.Start(client, "ixDisplayInfo", contents)
    net.Start("ixDisplayInfo")
        net.WriteTable(contents)
    net.Send(client)
end

local MAX_DISTANCE = 200

-- netstream.Hook("ixDisplayUpdate", function(client, contents)
net.Receive("ixDisplayUpdate", function(len, client)
    local contents = net.ReadTable()
    local found = false

    for _, ent in pairs(ents.FindByClass("ix_display_info")) do
        if client:GetPos():Distance(ent:GetPos()) < MAX_DISTANCE then
            found = true

            break
        end
    end

    if not found then return end

    PLUGIN:UpdateInfo(contents)
end)