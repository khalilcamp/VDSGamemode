local path = "bomb/preset.txt"
BombSystem.preset = BombSystem.preset or false

function BombSystem:CreatePresetFiles()
	if not file.Exists("bomb/", "DATA") or not file.Exists(path, "DATA") then
		file.CreateDir("bomb/")
		file.Write(path, "")
	end

	local sel = file.Read(path, "DATA")
	if not sel or not BombSystem.presets[sel] then return end
	BombSystem.preset = sel
end

function BombSystem:ReadPresetFile()
	if not file.Exists(path, "DATA") then return end
	local sel = file.Read(path, "DATA")
	if not sel or not BombSystem.presets[sel] then return end
	BombSystem.preset = sel
end

function BombSystem:DoesBombFileExist()
	return file.Exists(path, "DATA")
end

function BombSystem:GetPreset()
	return BombSystem.preset
end

function BombSystem:SetPreset(name)
	if not BombSystem.presets[name] then return end
	file.Write(path, name)
	BombSystem.preset = name
end

function BombSystem:DeletePreset()
	file.Write(path, "")
	BombSystem.preset = false
end

BombSystem.presets = {
	["Deuteronopia"] = {
		Yellow = Color(255, 246, 58),
		Blue = Color(56, 96, 179),
		Green = Color(159, 146, 40),
		Red = Color(98, 91, 73),
		Orange = Color(193, 176, 18),
		Black = Color(0, 0, 0),
		White = Color(100, 100, 100),
	},
	["Protanopia"] = {
		Yellow = Color(255, 248, 56),
		Blue = Color(60, 98, 179),
		Green = Color(175, 159, 31),
		Red = Color(104, 95, 22),
		Orange = Color(176, 160, 33),
		Black = Color(0, 0, 0),
		White = Color(100, 100, 100),
	},
	["Tritanopia"] = {
		Yellow = Color(252, 227, 233),
		Blue = Color(17, 164, 197),
		Green = Color(97, 210, 250),
		Red = Color(254, 41, 107),
		Orange = Color(251, 106, 147),
		Black = Color(0, 0, 0),
		White = Color(100, 100, 100),
	},
	["Normal"] = {},
}

local frame
local background = Color(30, 30, 30)
local outline = Color(144, 0, 255)
local text = Color(255, 255, 255)
local selected = Color(100, 100, 100)
local notselected = Color(40, 40, 40)
local clsbtnclr = Color(255, 0, 0)

function BombSystem:OpenColorBlindMenu()
	if IsValid(frame) then
		frame:Remove()
	end

	local scrw, scrh = ScrW(), ScrH()
	frame = vgui.Create("DFrame")
	frame:SetSize(scrw * 0.25, scrh * 0.35)
	frame:Center()
	frame:SetTitle("")
	frame:MakePopup()
	frame:ShowCloseButton(false)

	frame.Paint = function(s, w, h)
		surface.SetDrawColor(background)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(outline)
		surface.DrawOutlinedRect(0, 0, w, h, scrw * 0.002)
		draw.SimpleText("TheJoe's Bomb - Colorblind Presets", "DermaLarge", w * 0.5, h * 0.05, tetx, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	local clsbtn = vgui.Create("DButton", frame)
	clsbtn:SetPos(scrw * 0.225, scrh * 0.006)
	clsbtn:SetText("X")
	clsbtn:SetColor(clsbtnclr)
	clsbtn:SetFont("DermaLarge")

	clsbtn.DoClick = function()
		frame:Remove()
	end

	clsbtn.Paint = function() end
	local addlist = vgui.Create("DScrollPanel", frame)
	addlist:SetPos(0, scrh * 0.05)
	addlist:SetSize(scrw * 0.25, scrh * 0.25)
	addlist:GetVBar():SetSize(0)

	for presetName, _ in pairs(BombSystem.presets) do
		local selectbtn = vgui.Create("DButton", addlist)
		selectbtn:SetSize(scrw * 0.2, scrh * 0.05)
		selectbtn:SetText("")
		selectbtn:Dock(TOP)
		selectbtn:DockMargin(scrw * 0.01, scrw * 0.0125, scrw * 0.01, 0)

		selectbtn.Paint = function(s, w, h)
			if BombSystem.preset and BombSystem.preset == presetName then
				surface.SetDrawColor(selected)
			else
				surface.SetDrawColor(notselected)
			end

			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor(outline)
			surface.DrawOutlinedRect(0, 0, w, h, scrw * 0.002)
			draw.SimpleText(presetName, "DermaLarge", w * 0.5, h * 0.5, text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		selectbtn.DoClick = function()
			if (BombSystem.preset and BombSystem.preset == presetName) or presetName == "Normal" then
				BombSystem:DeletePreset()
			else
				BombSystem:SetPreset(name)
			end

			frame:Remove()
		end
	end
end

hook.Add("InitPostEntity", "BombSystem:OpenColorblindMenu", function()
	if BombSystem:DoesBombFileExist() then
		BombSystem:ReadPresetFile()
	else
		BombSystem:CreatePresetFiles()
		BombSystem:OpenColorBlindMenu()
	end
end)

concommand.Add("bomb_colorblind", function()
	BombSystem:CreatePresetFiles()
	BombSystem:OpenColorBlindMenu()
end)