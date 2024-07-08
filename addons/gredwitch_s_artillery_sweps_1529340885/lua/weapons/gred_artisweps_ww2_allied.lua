AddCSLuaFile()

SWEP.Base 						= "gred_artisweps_base"

SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true

SWEP.Category					= "Gredwitch's SWEPs"
SWEP.Author						= "Gredwitch"
SWEP.PrintName					= "[AS]WW2 Allied Binoculars"

function SWEP:InitChoices()
	self.Choices = {
		{
			name = "Artillery Strike",
			sound = "VO_WW2_ALLIED_ARTILLERY_HE",
			func = function(ply,tr)
				timer.Simple(10,function()
					gred.STRIKE.ARTILLERY(ply,tr,"ARTILLERY","ARTILLERY",math.random(14,16),105,"HE",600,3700)
				end)
			end
		},
		{
			name = "Smoke Artillery Strike",
			sound = "VO_WW2_ALLIED_ARTILLERY_SMOKE",
			func = function(ply,tr)
				timer.Simple(10,function()
					gred.STRIKE.ARTILLERY(ply,tr,"ARTILLERY","ARTILLERY",math.random(14,16),105,"Smoke",600)
				end)
			end
		},
		{
			name = "Mortar Strike",
			sound = "VO_WW2_ALLIED_ARTILLERY_HE",
			func = function(ply,tr)
				timer.Simple(10,function()
					gred.STRIKE.ARTILLERY(ply,tr,"MORTAR","MORTAR",math.random(10,12),81,"HE",600,400)
				end)
			end
		},
	}
end