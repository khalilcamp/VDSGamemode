local menu
local _contents

function PLUGIN:Think()
    if not menu or not IsValid(menu) then
        menu = vgui.Create("ixDisplayInfo")
        menu:Fill(_contents or {})
        -- menu:Fill({{title = "LoLxD", text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non urna accumsan, scelerisque lorem eu, convallis arcu. Pellentesque a malesuada nunc. Nam vel ullamcorper augue, id sagittis urna. Integer sagittis felis mi, porttitor aliquet leo interdum quis. Integer laoreet velit ullamcorper, volutpat dolor non, venenatis justo. Mauris vulputate ligula lacinia, tempus nunc posuere, placerat ex. Pellentesque faucibus sapien eget elit tempus, non imperdiet elit sollicitudin."}})
    end 
end

-- netstream.Hook("ixDisplayInfo", function(contents)
net.Receive("ixDisplayInfo", function(len)
    local contents = net.ReadTable()
    _contents = contents

    if IsValid(menu) then
        menu:Fill(contents)
    end
end)

concommand.Add("display_info_reload", function()
    if IsValid(menu) then
        menu:Remove()
    end
end)

local config

-- netstream.Hook("ixDisplayConfig", function()
net.Receive("ixDisplayConfig", function(len)
    if config and IsValid(config) then
        config:Remove()
    else
        config = vgui.Create("ixDisplayConfig")
        config:Fill(_contents)
    end
end)