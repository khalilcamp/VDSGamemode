-- ╔═╗╔═╦═══╦═══╗───────────────────────
-- ║║╚╝║║╔═╗║╔═╗║───────────────────────
-- ║╔╗╔╗║║─║║╚══╗───────────────────────
-- ║║║║║║║─║╠══╗║──By MacTavish <3──────
-- ║║║║║║╚═╝║╚═╝║───────────────────────
-- ╚╝╚╝╚╩══╗╠═══╝───────────────────────
-- ────────╚╝───────────────────────────

MQS.UIEffectSV = {}

MQS.UIEffectSV["Cinematic camera"] = function(data, ply)
	ply.MQScampos = data.pos
	if timer.Exists("MQSPVS" .. ply:UserID()) then
		timer.Remove("MQSPVS" .. ply:UserID())
	end

	timer.Create("MQSPVS" .. ply:UserID(), data.time, 1, function()
		if IsValid(ply) then
			ply.MQScampos = nil
		end
	end)
end

net.Receive("MQS.UIEffect", function(l, ply)
	if MQS.SpamBlock(ply,.5) then return end

	local bytes_number = net.ReadInt(32)
	local compressed_data = net.ReadData(bytes_number)
	local data = MQS.TableDecompress(compressed_data)

	if not data.name then return end

	if MQS.UIEffectSV[data.name] then
		MQS.UIEffectSV[data.name](data, ply)
	end
end)

net.Receive("MQS.StartTask", function(l, ply)
	if MQS.SpamBlock(ply,1) then return end

	local id = net.ReadString()
	local snpc = net.ReadBool()
	local npc

	if not snpc then
		npc = net.ReadInt(16)
	else
		npc = net.ReadString()
	end

	MQS.StartTask(id, ply, npc)
end)

concommand.Add("mqs_start", function(ply, cmd, args)
	local force = MQS.IsAdministrator(ply)
	if force and args[2] then
		ply = Player(args[2])
	end
	MQS.StartTask(args[1], ply, nil, force)
end)

concommand.Add("mqs_fail", function(ply, cmd, args)
	if not MQS.IsAdministrator(ply) then return end
	MQS.FailTask(ply, "Manual stop")
end)

concommand.Add("mqs_skip", function(ply, cmd, args)
	if not MQS.IsAdministrator(ply) and args[1] and tonumber(args[1]) then return end
	MQS.UpdateObjective(ply, tonumber(args[1]))
end)

concommand.Add("mqs_stop", function(ply, cmd, args)
	local q = MQS.HasQuest(ply)

	if MQS.GetNWdata(ply, "loops") and not MQS.Quests[q.quest].reward_on_time and MQS.GetNWdata(ply, "loops") > 0 then
		MQS.TaskSuccess(ply)
		return
	end

	if MQS.Quests[q.quest].stop_anytime then
		MQS.FailTask(ply, MSD.GetPhrase("quest_abandon"))
	end
end)

hook.Add("PlayerSay", "MQS.PlayerSay", function(ply, text)
	if string.lower(text) == "/mqs" then
		net.Start("MQS.OpenEditor")
		net.Send(ply)

		return ""
	end
end)

hook.Add("PlayerSpawn", "MQS.PlayerSpawn", function(ply)
	local q = MQS.HasQuest(ply)
	if not q then return end

	timer.Simple(0, function()
		if IsValid(ply) and ply.EventData and ply.EventData.SpawnPoint then
			ply:SetPos(ply.EventData.SpawnPoint[1])
			ply:SetAngles(ply.EventData.SpawnPoint[2])
		end
	end)
end)

hook.Add("SetupPlayerVisibility", "MQS.LoadCam", function(ply, pViewEntity)
	if ply.MQScampos then
		AddOriginToPVS(ply.MQScampos)
	end
end)

hook.Add("VC_engineExploded", "MQS.VC.engineExploded", function(ent, silent)
	if IsValid(ent) and ent.isMQS and MQS.ActiveTask[ent.isMQS].vehicle == ent:EntIndex() and IsValid(MQS.ActiveTask[ent.isMQS].player) then
		MQS.FailTask(MQS.ActiveTask[ent.isMQS].player, MSD.GetPhrase("vehicle_bum"))
	end
end)

hook.Add("canDropWeapon", "MQS.DarkRP.canDropWeapon", function(ply, weapon)
	if weapon.MQS_weapon then
		return false
	end
end)

function MQS.StartTask(tk, ply, npc, force)
	local can_start, error_str = MQS.CanStartTask(tk, ply, npc, force)

	if not can_start then
		MQS.SmallNotify(error_str, ply, 1)

		return
	end

	local task = MQS.Quests[tk]

	local q_id = table.insert(MQS.ActiveTask, {
		task = tk,
		player = ply,
		misc_ents = {},
		vehicle = nil
	})

	MQS.TaskCount[tk] = MQS.TaskCount[tk] and MQS.TaskCount[tk] + 1 or 1

	if task.looped then
		MQS.ActiveTask[q_id].loop = 0
		MQS.SetNWdata(ply, "loops", 0)
	else
		MQS.SetNWdata(ply, "loops", nil)
	end

	MQS.SetNWdata(ply, "active_quest", tk)
	MQS.SetNWdata(ply, "active_questid", q_id)
	ply.EventData = {}
	MQS.UpdateObjective(ply, 1, tk, q_id)

	if task.do_time then
		MQS.SetNWdata(ply, "do_time", CurTime() + task.do_time)
	else
		MQS.SetNWdata(ply, "do_time", nil)
	end

	MQS.Notify(ply, task.name, task.desc, 1)
	MQS.DataShare()
end

function MQS.TaskReward(ply, quest)
	if MQS.Quests[quest].reward then
		for k, v in pairs(MQS.Quests[quest].reward) do
			if MQS.Rewards[k].check and MQS.Rewards[k].check() then continue end
			MQS.Rewards[k].reward(ply, v)
		end
	end
end

function MQS.OnTastStoped(ply, q, quest)
	MQS.TaskCount[q.quest] = MQS.TaskCount[q.quest] - 1

	if MQS.ActiveTask[q.id].ents then
		for k, v in pairs(MQS.ActiveTask[q.id].ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end
	end

	if MQS.ActiveTask[q.id].misc_ents then
		for k, v in pairs(MQS.ActiveTask[q.id].misc_ents) do
			local ent = ents.GetByIndex(v)

			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end
	end

	if MQS.ActiveTask[q.id].vehicle then
		local ent = Entity(MQS.ActiveTask[q.id].vehicle)

		timer.Simple(5, function()
			if IsValid(ent) and ent.IsMQS then
				SafeRemoveEntity(ent)
			end
		end)
	end

	if IsValid(ply) then
		net.Start("MQS.UIEffect")
			net.WriteString("Quest End")
			net.WriteTable({id = q.id, uid = ply:UserID()})
		net.Broadcast()

		for _, wep in pairs(ply:GetWeapons()) do
			if IsValid(wep) and wep.MQS_weapon then
				ply:StripWeapon(wep:GetClass())
			end
		end

		if ply.MQS_restore then
			ply.MQS_restore = nil
			MQS.Events["Restore All Weapons"](nil, ply)
		end

		ply.MQS_oldWeap = nil
		ply.EventData = nil
	end

	MQS.ActiveTask[q.id] = nil
end

function MQS.FailTask(ply, reason, q)
	if not q then
		q = MQS.HasQuest(ply)
	end

	if not q then return end
	local quest = MQS.Quests[q.quest]

	if IsValid(ply) and quest.cool_down_onfail or quest.cool_down then
		if ply and quest.cooldow_perply then
			if not ply.MQSdata.Stored.CoolDown then
				ply.MQSdata.Stored.CoolDown = {}
			end

			local qs = ply.MQSdata.Stored.CoolDown
			qs[q.quest] = os.time() + (quest.cool_down_onfail or quest.cool_down)
			MQS.SetNWStoredData(ply, "CoolDown", qs)
		else
			MQS.TaskQueue[q.quest] = CurTime() + (quest.cool_down_onfail or quest.cool_down)
		end
	end

	MQS.OnTastStoped(ply, q, quest)

	if IsValid(ply) then
		MQS.Notify(ply, MSD.GetPhrase("m_failed"), reason, 2)
		MQS.SetNWdata(ply, "active_quest", nil)
		MQS.SetNWdata(ply, "active_questid", nil)
	end

	MQS.DataShare()

	hook.Call("MQS.OnTaskFail", nil, ply, reason, q.quest, quest)
end

function MQS.TaskSuccess(ply)
	local q = MQS.HasQuest(ply)
	if not q.quest then return end
	local quest = MQS.Quests[q.quest]

	if quest.cool_down then
		if quest.cooldow_perply then
			if not ply.MQSdata.Stored.CoolDown then
				ply.MQSdata.Stored.CoolDown = {}
			end
			local qs = ply.MQSdata.Stored.CoolDown
			qs[q.quest] = os.time() + quest.cool_down

			MQS.SetNWStoredData(ply, "CoolDown", qs)
		else
			MQS.TaskQueue[q.quest] = CurTime() + quest.cool_down
		end
	end

	if not ply.MQSdata.Stored.QuestList then
		ply.MQSdata.Stored.QuestList = {}
	end

	local qs = ply.MQSdata.Stored.QuestList

	if qs[q.quest] then
		qs[q.quest] = qs[q.quest] + 1
	else
		qs[q.quest] = 1
	end

	MQS.SetNWStoredData(ply, "QuestList", qs)
	MQS.SetNWdata(ply, "active_quest", nil)
	MQS.SetNWdata(ply, "active_questid", nil)
	MQS.Notify(ply, MSD.GetPhrase("m_success"), quest.success, 3)
	MQS.TaskReward(ply, q.quest)
	MQS.OnTastStoped(ply, q, quest)
	MQS.DataShare()

	hook.Call("MQS.OnTaskSuccess", nil, ply, q.quest, quest, false)
end

function MQS.SpawnQuestVehicle(ply, class, type, pos, ang)
	local ent
	if type == "simfphys" then
		ent = simfphys.SpawnVehicleSimple(class, pos, ang)
	elseif type == "lfs" then
		ent = ents.Create(class)
		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
	else
		local vh_ls = list.Get("Vehicles")
		local veh = vh_ls[class]
		if (not veh) then return end
		ent = ents.Create(veh.Class)
		if not ent then return end
		ent:SetModel(veh.Model)

		if (veh and veh.KeyValues) then
			for k, v in pairs(veh.KeyValues) do
				ent:SetKeyValue(k, v)
			end
		end

		ent:SetAngles(ang)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
		ent.ClassOverride = veh.Class
	end

	if DarkRP and type ~= "lfs" then
		ent:keysOwn(ply)
		ent:keysLock()
	end

	return ent
end

function MQS.SpawnNPCs()
	for _, ent in ipairs(ents.FindByClass("mqs_npc")) do
		if IsValid(ent) then
			ent:Remove()
		end
	end

	if not MQS.Config.NPC.enable then return end

	for id, npc in pairs(MQS.Config.NPC.list) do
		local spawnpos = npc.spawns[string.lower(game.GetMap())]
		if not spawnpos then continue end
		local ent = ents.Create("mqs_npc")
		ent:SetModel(npc.model)
		ent:SetPos(spawnpos[1])
		ent:SetAngles(spawnpos[2])
		ent:SetNamer(npc.name)
		ent:SetUID(id)
		ent:SetUseType(SIMPLE_USE)
		ent:SetSolid(SOLID_BBOX)
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		if npc.bgr then
			for k, v in ipairs(npc.bgr) do
				ent:SetBodygroup(k, v)
			end
		end

		if npc.skin then
			ent:SetSkin(npc.skin)
		end
		ent:Spawn()
		if npc.sequence then
			ent:ResetSequence(npc.sequence)
			ent:SetCycle(0)
		end
	end
end

timer.Simple(2, function()
	MQS.SpawnNPCs()
end)

hook.Add("PostCleanupMap", "MQS.PostCleanupMap", function()
	MQS.SpawnNPCs()
end)

hook.Add("EntityTakeDamage", "MQS.EntityTakeDamage", function(target, dmginfo)
	if target:IsNPC() and target.is_quest_npc and not target.open_target then
		local attacker = dmginfo:GetAttacker()

		if IsValid(attacker) and attacker ~= MQS.ActiveTask[target.quest_id].player then
			dmginfo:ScaleDamage(0)
		end
	end
end)

hook.Add("PlayerDeath", "MQS.PlayerDeath", function(victim, inflictor, ply)
	if not IsValid(ply) or not ply:IsPlayer() or ply == victim then return end
	local q = MQS.HasQuest(ply)
	if not q then return end

	local task = MQS.Quests[q.quest]
	local obj_id = MQS.GetNWdata(ply, "quest_objective")
	local obj = task.objects[obj_id]

	if obj.type ~= "Kill random target" or obj.target_type ~= 2 or (obj.target_class and obj.target_class ~= "" and obj.target_class ~= team.GetName(victim:Team()) ) then return end

	if MQS.GetSelfNWdata(ply, "targets") and MQS.GetSelfNWdata(ply, "targets") > 1 then
		MQS.SetSelfNWdata(ply, "targets", MQS.GetSelfNWdata(ply, "targets") - 1)
	else
		MQS.SetSelfNWdata(ply, "targets", nil)
		MQS.UpdateObjective(ply)
	end

end)

hook.Add("OnNPCKilled", "MQS.OnNPCKilled", function(target, ply)
	if target.is_quest_npc and IsValid(MQS.ActiveTask[target.quest_id].player) then
		if MQS.ActiveTask[target.quest_id].npcs and MQS.ActiveTask[target.quest_id].npcs > 1 then
			MQS.ActiveTask[target.quest_id].npcs = MQS.ActiveTask[target.quest_id].npcs - 1
		else
			MQS.ActiveTask[target.quest_id].npcs = nil
			MQS.UpdateObjective(MQS.ActiveTask[target.quest_id].player)
		end
		return
	end

	if not IsValid(ply) then return end

	local q = MQS.HasQuest(ply)
	if not q then return end

	local task = MQS.Quests[q.quest]
	local obj_id = MQS.GetNWdata(ply, "quest_objective")
	local obj = task.objects[obj_id]

	if obj.type ~= "Kill random target" or obj.target_type ~= 1 or (obj.target_class and obj.target_class ~= "" and obj.target_class ~= target:GetClass() ) then return end

	if MQS.GetSelfNWdata(ply, "targets") and MQS.GetSelfNWdata(ply, "targets") > 1 then
		MQS.SetSelfNWdata(ply, "targets", MQS.GetSelfNWdata(ply, "targets") - 1)
	else
		MQS.SetSelfNWdata(ply, "targets", nil)
		MQS.UpdateObjective(ply)
	end
end)

function MQS.ProcessMission() end
function MQS.Process() end
function MQS.UpdateObjective() end
