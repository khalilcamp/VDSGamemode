util.AddNetworkString("bomb_defusable_menu")

net.Receive("bomb_defusable_menu", function(_, ply)
	if not IsValid(ply.lastdefbomb) then return end
	local typ = net.ReadInt(3)
	if typ < 1 or typ > 2 then return end
	local time = net.ReadInt(32) or nil
	ply.lastdefbomb:HandleActivation(ply, typ, time)
end)

util.AddNetworkString("bomb_defusable_sound")

function BombSystem:MakeBombSound(pos)
	net.Start("bomb_defusable_sound")
	net.WriteVector(pos)
	net.Broadcast()
end

--[[
{
    [1] = {
        [1] = {
            col = Color(255,0,0),
            pos = Vector(0,0,0),
            ang = Angle(0,0,0),
            cut = true or 1/2/3
        },
    },
}
]]
BombSystem.codes = {}

function BombSystem:AddCombination(tbl)
	table.insert(BombSystem.codes, tbl)
end

--[[
if there is one yellow wire and atleast 1 blue wire and no black wire, cut the red and then the blue one.
if there are two yellow ones and a green wire, cut the left yellow one and the black one.
if there are two yellow ones and a blue wire, cut the orange and then the blue wire.
if there is no green wire and one red wire, cut the blue wire.
if there is one yellow and one black wire, cut the green wire, then the black and then the yellow wire.
if there is a red wire, a yellow and a white wire and cut the red one.
]]
BombSystem:AddCombination({
	[1] = {
		col = "Yellow", -- yellow
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = false
	},
	[2] = {
		col = "Blue", -- blue
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = 2
	},
	[3] = {
		col = "Green", -- green
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = false
	},
	[4] = {
		col = "Red", -- red
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = 1
	},
})

BombSystem:AddCombination({
	[1] = {
		col = "Blue", -- blue
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = 2
	},
	[2] = {
		col = "Yellow", -- yellow
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = false
	},
	[3] = {
		col = "Orange", -- orange
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = 1
	},
	[4] = {
		col = "Yellow", -- yellow
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = false
	},
})

BombSystem:AddCombination({
	[1] = {
		col = "Yellow", -- yellow
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = false
	},
	[2] = {
		col = "Green", -- green
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = false
	},
	[3] = {
		col = "Yellow", -- yellow
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = 1
	},
	[4] = {
		col = "Black", -- black
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = 2
	},
})

BombSystem:AddCombination({
	[1] = {
		col = "Red", -- red
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = false
	},
	[2] = {
		col = "White", -- white 
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = false
	},
	[3] = {
		col = "Blue", -- blue
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = true
	},
	[4] = {
		col = "Black", -- black
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = false
	},
})

BombSystem:AddCombination({
	[1] = {
		col = "Black", -- black
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = 2
	},
	[2] = {
		col = "Green", -- green
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = 1
	},
	[3] = {
		col = "Orange", -- orange
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = false
	},
	[4] = {
		col = "Yellow", -- yellow
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = 3
	},
})

BombSystem:AddCombination({
	[1] = {
		col = "Red", -- red
		pos = Vector(-11, -5, 19),
		ang = Angle(10, 30, -40),
		cut = 1
	},
	[2] = {
		col = "Green", -- green
		pos = Vector(-16, 0, 16),
		ang = Angle(-50, 190, 0),
		cut = false
	},
	[3] = {
		col = "Yellow", -- yellow
		pos = Vector(-15, 0, 16),
		ang = Angle(0, -110, 30),
		cut = false
	},
	[4] = {
		col = "White", -- white
		pos = Vector(-9, -7, 18),
		ang = Angle(0, -290, -40),
		cut = 2
	},
})