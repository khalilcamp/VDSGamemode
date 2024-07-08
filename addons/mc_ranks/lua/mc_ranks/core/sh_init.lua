-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║╚═╝║╚══╗──By MacTavish <3──────
-- ║║║║║║╔╗╔╩══╗║───────────────────────
-- ║║║║║║║║╚╣╚═╝║───────────────────────
-- ╚╝╚╝╚╩╝╚═╩═══╝───────────────────────

local Ln = MSD.GetPhrase

MRS.PlayerStats["Max HP"] = {
	data = {100},
	icon = Material("mqs/icons/heart.png", "smooth"),
	limited = true,
	apply = function(ply, data)
		if not MRS.GetSelfNWdata(ply, "MaxHealth") then
			MRS.SetSelfNWdata(ply, "MaxHealth", ply:GetMaxHealth())
		end
		ply:SetHealth(data[1])
		ply:SetMaxHealth(data[1])
	end,
	revoke = function(ply)
		if MRS.GetSelfNWdata(ply, "MaxHealth") then
			if ply:Health() >= ply:GetMaxHealth() then
				ply:SetHealth(MRS.GetSelfNWdata(ply, "MaxHealth"))
			end
			ply:SetMaxHealth(MRS.GetSelfNWdata(ply, "MaxHealth"))
			MRS.SetSelfNWdata(ply, "MaxHealth", nil)
		end
	end,
	uisize = 5,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, "", Ln("e_value"), data[1], function(self, value)
			data[1] = tonumber(value) or 0
		end, true, nil, nil, true)
	end
}

MRS.PlayerStats["Max Armor"] = {
	data = {100, true},
	limited = true,
	icon = Material("mqs/map_markers/a5.png", "smooth"),
	apply = function(ply, data)
		if not MRS.GetSelfNWdata(ply, "MaxArmor") then
			MRS.SetSelfNWdata(ply, "MaxArmor", ply:GetMaxArmor())
		end
		ply:SetMaxArmor(data[1])
		if data[2] then
			ply:SetArmor(data[1])
		end
	end,
	revoke = function(ply)
		if MRS.GetSelfNWdata(ply, "MaxArmor") then
			if ply:Armor() >= ply:GetMaxArmor() then
				ply:SetArmor(MRS.GetSelfNWdata(ply, "MaxArmor"))
			end
			ply:SetMaxArmor(MRS.GetSelfNWdata(ply, "MaxArmor"))
			MRS.SetSelfNWdata(ply, "MaxArmor", nil)
		end
	end,
	uisize = 4,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, "", Ln("e_value"), data[1], function(self, value)
			data[1] = tonumber(value) or 0
		end, true, nil, nil, true)
		MSD.BoolSlider(panel, "static", nil, 1, 50, "Give armor on spawn", data[2], function(self, value)
			data[2] = value
		end)
	end
}

MRS.PlayerStats["Extra Armor"] = {
	data = {100},
	limited = true,
	icon = Material("mqs/map_markers/a1.png", "smooth"),
	apply = function(ply, data)
		ply:SetArmor(data[1])
	end,
	uisize = 5,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, "", Ln("e_value"), data[1], function(self, value)
			data[1] = tonumber(value) or 0
		end, true, nil, nil, true)
	end
}

MRS.PlayerStats["Give weapon"] = {
	data = {"weapon_pistol"},
	icon = Material("mqs/icons/pistol.png", "smooth"),
	apply = function(ply, data)
		local weapon = ply:Give(data[1])
		if IsValid(weapon) and weapon ~= NULL then
			weapon.MRS_weapon = true
		end
	end,
	uisize = 5,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, Ln("e_wep_class"), Ln("weapon_name") .. ":", data[1], function(self, value)
			data[1] = value
		end, true)
	end
}

MRS.PlayerStats["Give Ammo"] = {
	data = {
		[1] = "Pistol",
		[2] = 10,
	},
	icon = Material("mqs/icons/ammo.png", "smooth"),
	apply = function(ply, data)
		ply:GiveAmmo(data[2], data[1], false)
	end,
	buildUI = function(panel, data)
		local btn = MSD.ButtonIcon(panel, "static", nil, 1, 50, Ln("select_ammo") .. ": " .. language.GetPhrase("#" .. data[1] .. "_ammo"), Material("mqs/icons/ammo.png", "smooth"), function() end)
		btn.hovered = true

		MSD.TextEntry(panel, "static", nil, 1, 50, Ln("e_number"), Ln("amount_ammo") .. ":", data[2], function(self, value)
			data[2] = tonumber(value) or 0
		end, true, nil, nil, true)

		for _, ammo in ipairs(game.GetAmmoTypes()) do
			MSD.Button(panel, "static", nil, 3, 50, language.GetPhrase("#" .. ammo .. "_ammo"), function(self)
				data[1] = ammo
				btn:SetText(Ln("select_ammo") .. ": " .. language.GetPhrase("#" .. ammo .. "_ammo"))
			end)
		end
	end
}

MRS.PlayerStats["Salary bonus"] = {
	check = function()
		if not DarkRP then return true end
	end,
	data = {2,false,false},
	icon = Material("msd/icons/account-cash.png", "smooth"),
	apply = function(ply, data)
		if not MRS.GetSelfNWdata(ply, "SalaryBonus") then
			MRS.SetSelfNWdata(ply, "SalaryBonus", ply:getDarkRPVar("salary"))
		end
		if data[2] and not data[3] then
			ply:setSelfDarkRPVar("salary", data[1])
			return
		end
		local sal = RPExtraTeams[ply:Team()] and RPExtraTeams[ply:Team()].salary or 0
		if data[3] then
			ply:setSelfDarkRPVar("salary", sal * data[1])
			return
		end
		ply:setSelfDarkRPVar("salary", sal + data[1])
	end,
	revoke = function(ply)
		if MRS.GetSelfNWdata(ply, "SalaryBonus") then
			ply:setSelfDarkRPVar("salary", MRS.GetSelfNWdata(ply, "SalaryBonus"))
			MRS.SetSelfNWdata(ply, "SalaryBonus", nil)
		end
	end,
	uisize = 3,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, Ln("e_number"), Ln("salary_value") .. ":", data[1], function(self, value)
			data[1] = tonumber(value) or 0
		end, true, nil, nil, true)
		local sld = MSD.DTextSlider(panel, "static", nil, 1, 50, Ln("salary_set"), Ln("salary_add"), data[2], function(self, value)
			data[2] = value
		end)
		sld.disabled = data[3]
		MSD.BoolSlider(panel, "static", nil, 1, 50, Ln("salary_multiply"), data[3], function(self, value)
			data[3] = value
			sld.disabled = value
		end)
	end
}

MRS.PlayerStats["GAS Job Whitelist"] = {
	data = {},
	check = function()
		if not GAS or not GAS.JobWhitelist then return true end
	end,
	icon = Material("msd/icons/account.png", "smooth"),
	limited = true,
	apply = function(ply, data)
		for id, en in pairs(data) do
			if not en then continue end
			if GAS.JobWhitelist:IsWhitelisted( ply, id, true ) then continue end
			GAS.JobWhitelist:AddToWhitelist( id, GAS.JobWhitelist.LIST_TYPE_STEAMID, ply:AccountID())
		end
	end,
	buildUI = function(panel, data)
		for id, tm in SortedPairsByMemberValue(team.GetAllTeams(), "Name", true) do
			if not tm.Joinable then continue end

			MSD.BoolSlider(panel, "static", nil, 1, 50, tm.Name, data[id] or false, function(self, var)
				data[id] = var or nil
			end)
		end
	end
}

MRS.PlayerStats["Set BodyGroup"] = {
	data = {1, 0},
	icon = Material("msd/icons/account-cowboy-hat.png", "smooth"),
	limited = true,
	apply = function(ply, data)
		if data[3] then
			local mlist = string.Replace(data[3], " ", "")
			mlist = string.Replace(mlist, "\n", "")
			mlist = string.Explode(";", mlist)
			local found

			for k,v in pairs(mlist) do
				print(ply:GetModel(), v)
				if ply:GetModel() == v then
					found = true
					break
				end
			end

			if not found then return end
		end

		local bg = data[1]
		if not tonumber(bg) then
			bg = ply:FindBodygroupByName( bg )
		end

		ply:SetBodygroup(bg, data[2])
	end,
	buildUI = function(panel, data)
		MSD.TextEntry(panel, "static", nil, 1, 50, Ln("e_value"), "Bodygroup id or name", data[1], function(self, value)
			data[1] = value
		end, true)

		MSD.TextEntry(panel, "static", nil, 1, 50,  Ln("e_value"), "Bodygroup. Starts from 0", data[2], function(self, value)
			data[2] = tonumber(value) or 0
		end, true, nil, nil, true)

		MSD.TextEntry(panel, "static", nil, 1, 200,  "Apply only to this model list (put ; after each model). " .. Ln("e_blank_dis"), "", data[3] or "", function(self, value)
			if value == "" or value == " " then data[3] = nil return end
			data[3] = value
		end, true, nil, true)
	end
}