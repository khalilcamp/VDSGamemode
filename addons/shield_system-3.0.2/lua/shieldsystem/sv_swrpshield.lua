RunConsoleCommand("sv_tfa_bullet_penetration_power_mul", "0")

hook.Add("EntityTakeDamage", "SWRPShields:Effects", function(ent, dmginfo)
	if ent.isshield then
		local pos1 = dmginfo:GetDamagePosition()
		local pos2 = ent.gen:GetPos()

		if SWRPShield.shootoutofshield then
			local att = dmginfo:GetAttacker()
			local rad = ent.gen.radius or 0
			if IsValid(att) and att:IsPlayer() and att:GetPos():DistToSqr(pos2) <= rad ^ 2 then return false end
		end

		local tr = util.TraceLine({
			start = pos2,
			endpos = pos1,
			filter = {ent.gen}
		})

		tr.HitPos = tr.HitPos - (pos1 - pos2) * 0.05
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal((tr.HitPos - pos2):GetNormalized())
		effectdata:SetScale(dmginfo:GetDamage() * 5)
		util.Effect("riffle", effectdata)
		sound.Play("swrpshield/shoot1.wav", tr.HitPos, 100, 100, 1)
	end
end)

hook.Add("PhysgunPickup", "SWRPShields:Unfreeze", function(ply, ent)
	if ent.isshield or (ent.isgenerator and ent:GetSequence() == 3) then return false end
end)

hook.Add("Hook_BulletHit", "SWRPShields:ArcCWPenetratePatch", function(wep, hit)
	if hit.tr.Entity.isshield then return true end
end)

hook.Add("PreRegisterSWEP", "SWRPShields:TFAPenetratePatch", function(wep, class)
	if class != "tfa_gun_base" then return end

	local old = wep.MainBullet.Penetrate
	function wep.MainBullet:Penetrate(ply, traceres, dmginfo, weapon)
		if not IsValid(weapon) then return end
		local hitent = traceres.Entity

		if IsValid(hitent) and hitent.isshield then
			return
		end
		old(self, ply, traceres, dmginfo, weapon)
	end
end)