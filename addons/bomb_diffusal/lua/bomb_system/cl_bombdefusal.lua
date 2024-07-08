local frame
local col1 = Color(134, 235, 255, 255)
local col2 = Color(9, 125, 168, 100)

net.Receive("bomb_defusable_menu", function()
	if IsValid(frame) then
		frame:Remove()
	end

	frame = vgui.Create("DFrame")
	frame:SetSize(400, 200)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("")

	frame.Paint = function(s, w, h)
		surface.SetDrawColor(col2)
		surface.DrawRect(0, 0, w, h)
	end

	local remote = vgui.Create("DButton", frame)
	remote:SetSize(140, 40)
	remote:SetText("Remote")
	remote:SetPos(35, 80)
	remote:SetFont("DermaLarge")

	remote.DoClick = function()
		frame:Remove()
		net.Start("bomb_defusable_menu")
		net.WriteInt(1, 3)
		net.SendToServer()
	end

	remote.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(col1)
			s:SetTextColor(col2)
		else
			surface.SetDrawColor(col2)
			s:SetTextColor(col1)
		end

		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col1)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
	end

	local timeentry = vgui.Create("DTextEntry", frame)
	timeentry:SetSize(140, 40)
	timeentry:SetPos(215, 60)
	timeentry:SetNumeric(true)
	timeentry:SetFont("DermaLarge")

	timeentry.Paint = function(s, w, h)
		surface.SetDrawColor(col2)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col1)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
		s:DrawTextEntryText(col1, col2, col2)
	end

	local time = vgui.Create("DButton", frame)
	time:SetSize(140, 40)
	time:SetPos(215, 120)
	time:SetText("Timer")
	time:SetFont("DermaLarge")

	time.DoClick = function()
		frame:Remove()
		net.Start("bomb_defusable_menu")
		net.WriteInt(2, 3)
		net.WriteInt(tonumber(timeentry:GetValue()), 32)
		net.SendToServer()
	end

	time.Paint = function(s, w, h)
		if s:IsHovered() then
			surface.SetDrawColor(col1)
			s:SetTextColor(col2)
		else
			surface.SetDrawColor(col2)
			s:SetTextColor(col1)
		end

		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(col1)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
	end
end)

net.Receive("bomb_defusable_sound", function()
	local pos = net.ReadVector()
	local range1 = (BombSystem.radius * 4) ^ 2
	local range2 = (BombSystem.radius * 12) ^ 2
	local dist = LocalPlayer():GetPos():DistToSqr(pos)

	if dist < range1 then
		surface.PlaySound("ambient/explosions/explode_2.wav")
	elseif dist < range2 then
		surface.PlaySound("ambient/explosions/exp3.wav")
	end
end)