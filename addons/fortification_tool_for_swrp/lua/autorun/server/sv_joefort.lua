JoeFort = JoeFort or {}
--[[
JoeFort
JoeFort.structs
]]
util.AddNetworkString("JoeFort_UpdateTime")

function JoeFort:SpawnEnt(ply, wep)
	local data = JoeFort.structs[wep.selectcat][wep.selectnum]
	data.neededresources = data.neededresources or 100
	if JoeFort.Ressources - data.neededresources < 0 then return end
	JoeFort:SetRessourcePool(JoeFort.Ressources - data.neededresources)
	local trace = ply:GetEyeTrace()
	local ang = Angle(0, ply:GetAngles().y - 180 + wep.rotation, 0)
	local ent = ents.Create("joefort_buildent")

	if data.model then
		ent:SetModel(data.model)
	end

	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(ang)
	ent.buildtime = data.buildtime
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	phys:EnableMotion(false)
	phys:Wake()

	if data.OnBuildEntitySpawned ~= nil then
		data.OnBuildEntitySpawned(ply, ent)
	end

	timer.Simple(data.buildtime, function()
		if not IsValid(ent) then return end
		ent:Remove()
		local class = data.classname and data.classname ~= "" and data.classname or "prop_physics"
		local ent = ents.Create(class)

		if class == "prop_physics" then
			ent:SetModel(data.model)
		end

		local min = ent:OBBMins()
		ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
		ent:SetAngles(ang)
		ent.IsJoeFort = true

		ent.JoeFortData = {
			spawner = ply,
			health = data.health or 0,
			OnSpawn = data.OnSpawn or nil,
			OnDamaged = data.OnDamaged or nil,
			OnDestroyed = data.OnDestroyed or nil,
			ressources = data.neededresources
		}

		ent:Spawn()
		-- local tr = util.TraceLine( {
		--     start = ent:GetPos(),
		--     endpos = ent:GetUp() * -1000,
		--     filter = {ply}
		-- } )
		-- local min = ent:OBBMins()
		-- ent:SetPos( trace.HitPos - trace.HitNormal * min.z )
		ent:SetHealth(data.health or 0)
		local phys = ent:GetPhysicsObject()
		phys:EnableMotion(false)
		phys:Wake()
		ent:Activate()

		if data.OnSpawn ~= nil then
			data.OnSpawn(ply, ent)
		end
	end)
end

util.AddNetworkString("JoeFort_updatedata")
util.AddNetworkString("JoeFort_updateresourcepool")
local nospamt = {}

local function nospam(ply)
	local id = ply:SteamID64()

	if nospamt[id] ~= nil then
		if nospamt[id] < CurTime() then
			nospamt[id] = nil

			return true
		else
			return false
		end
	else
		nospamt[id] = CurTime() + 1

		return true
	end
end

net.Receive("JoeFort_updatedata", function(_, ply)
	if not nospam(ply) then return end
	local ent = net.ReadEntity()
	if not IsValid(ent) or ent:GetClass() ~= "fort_datapad" or ent:GetOwner() ~= ply then return end
	local cat = net.ReadString()
	if not cat or not JoeFort.structs[cat] then return end
	ent.selectcat = cat
	ent.selectnum = 1
	ent.selectmdl = JoeFort.structs[cat][1].model
end)

function JoeFort:SetRessourcePool(amount)
	if not amount then return end
	JoeFort.Ressources = amount
	net.Start("JoeFort_updateresourcepool")
	net.WriteInt(amount, 32)
	net.Broadcast()
end

net.Receive("JoeFort_updateresourcepool", function(_, ply)
	if not nospam(ply) or not ply:HasWeapon("fort_datapad_admin") then return end
	local amount = net.ReadInt(32)
	if not amount then return end
	JoeFort:SetRessourcePool(amount)
end)

hook.Add("EntityTakeDamage", "JoeFort:HandleDamage", function(ent, dmginfo)
	if not ent.IsJoeFort then return end
	local data = ent.JoeFortData
	if data.health == 0 then return true end

	if data.OnDamaged ~= nil then
		if data.OnDamaged(ent, data.spawner, dmginfo:GetAttacker(), dmginfo) ~= true then
			ent:SetHealth(ent:Health() - dmginfo:GetDamage())
		end
	else
		ent:SetHealth(ent:Health() - dmginfo:GetDamage())
	end

	if ent:Health() <= 0 then
		if data.OnDestroyed ~= nil then
			if data.OnDestroyed(ent, data.spawner, dmginfo:GetAttacker(), dmginfo) ~= true then
				ent:EmitSound("physics/concrete/concrete_break2.wav")
				local effectData = EffectData()
				effectData:SetOrigin(ent:GetPos())
				effectData:SetMagnitude(1)
				effectData:SetScale(1)
				effectData:SetRadius(2)
				util.Effect("Explosion", effectData)
				ent:Remove()
			end
		else
			ent:EmitSound("physics/concrete/concrete_break2.wav")
			local effectData = EffectData()
			effectData:SetOrigin(ent:GetPos())
			effectData:SetMagnitude(1)
			effectData:SetScale(1)
			effectData:SetRadius(2)
			util.Effect("Explosion", effectData)
			ent:Remove()
		end
	end

	return true
end)

function JoeFort:RepairEnt(ent, ply)
	local data = ent.JoeFortData
	local amount = data.ressources * (1 - (ent:Health() / data.health))

	if data.OnRepaired ~= nil then
		if data.OnRepaired(data.spawner, ply, ent, amount) ~= true then
			if JoeFort.Ressources - amount < 0 then
				ply:EmitSound("items/medshotno1.wav")

				return
			end

			JoeFort:SetRessourcePool(JoeFort.Ressources - amount)
			ent:SetHealth(ent.JoeFortData.health)
		end
	else
		if JoeFort.Ressources - amount < 0 then
			ply:EmitSound("items/medshotno1.wav")

			return
		end

		JoeFort:SetRessourcePool(JoeFort.Ressources - amount)
		ent:SetHealth(ent.JoeFortData.health)
	end
end

function JoeFort:RemoveEnt(ent, ply)
	local data = ent.JoeFortData
	local amount

	-- if entity is invincible, cause we cant divide 0/0
	if data.health <= 0 then
		amount = data.ressources
	else
		amount = data.ressources * (ent:Health() / data.health)
	end

	if data.OnRemoved ~= nil then
		if data.OnRemoved(data.spawner, ply, ent, amount) ~= true then
			JoeFort:SetRessourcePool(JoeFort.Ressources + amount)
			ent:EmitSound("physics/concrete/concrete_break2.wav")
			ent:Remove()
		end
	else
		JoeFort:SetRessourcePool(JoeFort.Ressources + amount)
		ent:EmitSound("physics/concrete/concrete_break2.wav")
		ent:Remove()
	end
end

hook.Add("KeyPress", "JoeFort:FusionCutter", function(ply, key)
	if key ~= IN_ATTACK and key ~= IN_ATTACK2 then return end
	if not ply:Alive() then return end
	local wep = ply:GetActiveWeapon()
	if not wep or not IsValid(wep) then return end
	local class = wep:GetClass() or nil
	if not class then return end
	if class ~= "alydus_fusioncutter" then return end
	if wep:GetNextPrimaryFire() > CurTime() then return end
	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) or not ent.IsJoeFort then return end

	if key == IN_ATTACK then
		if ent:Health() == ent.JoeFortData.health then
			ply:EmitSound("items/medshotno1.wav")
			wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay)

			return
		end

		-- copied from https://steamcommunity.com/sharedfiles/filedetails/?id=1700003070
		local plyEyeTrace = ply:GetEyeTrace()
		local vm = ply:GetViewModel()
		local bone = "ValveBiped.Grenade_body"
		local effectdata = EffectData()
		effectdata:SetOrigin(plyEyeTrace.HitPos)
		effectdata:SetMagnitude(3)
		effectdata:SetScale(5)
		effectdata:SetRadius(2)
		util.Effect("cball_explode", effectdata, true, true)
		sound.Play("HL1/ambience/port_suckin1.wav", plyEyeTrace.HitPos, 75, 100, 1)
		if not IsValid(vm) or not vm:LookupBone(bone) then return end
		local atch = vm:GetBoneMatrix(vm:LookupBone(bone))
		local pos, ang = vm:GetBonePosition(vm:LookupBone(bone)), vm:GetBoneMatrix(vm:LookupBone(bone)):GetAngles()
		local effectData = EffectData()
		effectData:SetOrigin(pos)
		util.Effect("MuzzleFlash", effectData, true, true)
		local effectData = EffectData()
		effectData:SetOrigin(pos)
		effectData:SetNormal(pos:GetNormalized())
		effectData:SetMagnitude(1)
		effectData:SetScale(1)
		effectData:SetRadius(2)
		util.Effect("Sparks", effectData)
		-- Credits go to Alydus
		JoeFort:RepairEnt(ent, ply)
	elseif key == IN_ATTACK2 and (ply:IsAdmin() or ent.JoeFortData.spawner == ply) then
		JoeFort:RemoveEnt(ent, ply)
	end

	wep:SetNextPrimaryFire(CurTime() + wep.Primary.Delay)
end)