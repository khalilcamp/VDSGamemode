local materials = {}
local grabbingMaterials = {}

function NCS_LOADOUTS.GetImgur(id, callback, useproxy, matSettings)
    if materials[id] then return callback(materials[id]) end

    file.CreateDir("ncs/")
    if file.Exists("ncs/" .. id .. ".png", "DATA") then
        materials[id] = Material("../data/ncs/" .. id .. ".png", matSettings or "noclamp smooth mips")
        return callback(materials[id])
    end

    http.Fetch(useproxy and "https://proxy.duckduckgo.com/iu/?u=https://i.imgur.com" or "https://i.imgur.com/" .. id .. ".png",
        function(body, len, headers, code)
            if len > 2097152 then
                materials[id] = Material("nil")
                return callback(materials[id])
            end

            file.Write("ncs/" .. id .. ".png", body)
            materials[id] = Material("../data/ncs/" .. id .. ".png", matSettings or "noclamp smooth mips")

            return callback(materials[id])
        end,
        function(error)
            if useproxy then
                materials[id] = Material("nil")
                return callback(materials[id])
            end
            return NCS_LOADOUTS.GetImgur(id, callback, true)
        end
    )
end

function NCS_LOADOUTS.DrawImgur(x, y, w, h, imgurId, col)
    col = col or color_white

    if not materials[imgurId] then
        if grabbingMaterials[imgurId] then return end
        grabbingMaterials[imgurId] = true

        NCS_LOADOUTS.GetImgur(imgurId, function(mat)
            materials[imgurId] = mat
            grabbingMaterials[imgurId] = nil
        end)

        return
    end

    surface.SetMaterial( materials[imgurId] )
        surface.SetDrawColor( col.r, col.g, col.b, col.a )
    surface.DrawTexturedRect(x, y, w, h)
end