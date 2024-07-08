
--[[
	v v v Hilt v v v
]]
local hilt = {}
hilt.PrintName = "Samurai"
hilt.Author = "Ink"
hilt.id = "samurai"
hilt.mdl = "models/plo/cwa/sabers/samurai.mdl"
hilt.info = {
	ParentData = {
		["RH"] = {
			bone = "ValveBiped.Bip01_R_Hand",
			pos = Vector(3, -1.3, -7),
			ang = Angle(-90, 7, 10),
		},
		["LH"] = {
			bone = "ValveBiped.Bip01_L_Hand",
			pos = Vector(4.25, -1.5, 1),
			ang = Angle(8, 0, -10),
		},
	},
GetBladePos = function( ent ) 
        local blades = {
            [1] = {
                pos = ent:LocalToWorld( Vector(2, -0.7, -0.2) ),
                dir = ent:LocalToWorldAngles( Angle(-90, -7, 10) ):Up(),
            },
        }

        return blades
    end,
}
LSCS:RegisterHilt( hilt )