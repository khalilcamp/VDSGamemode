if CLIENT then
	resource.AddSingleFile("neuropol.ttf")
	surface.CreateFont( "ON_Droids24", {
		font = "neuropol", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 24,
		weight = 500,
		blursize = 0,
		scanlines = 3,
	} )
	surface.CreateFont( "ON_Droids12", {
		font = "neuropol", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 12,
		weight = 500,
		blursize = 0,
		scanlines = 3,
	} )
end