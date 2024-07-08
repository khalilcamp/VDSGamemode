language.Add( "emp_grenade_ammo", "EMP Grenades" )

net.Receive("EMPGrenade.MotionBlur", function()
	local StartTime = CurTime()
	hook.Add( "RenderScreenspaceEffects", "EMPGrenade.MotionBlurEffect", function()

		DrawMotionBlur( math.Remap( CurTime() - StartTime, 0, 5, 0.25, 1 ), 10, 0.05/math.Remap( CurTime() - StartTime, 0, 5, 1, 5 ) )

	end )
	timer.Simple(5, function()
		hook.Remove("RenderScreenspaceEffects", "EMPGrenade.MotionBlurEffect")
	end)
end )
