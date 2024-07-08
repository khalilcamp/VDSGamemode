
Schema.name = "Galactic Conquest |CWRP|"
Schema.author = "nebulous.cloud"
Schema.description = "Um esquema baseado em Star Wars Clone Wars."

-- Include netstream
ix.util.Include("libs/thirdparty/sh_netstream2.lua")

ix.util.Include("sh_configs.lua")
ix.util.Include("sh_commands.lua")

ix.util.Include("cl_schema.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sh_voices.lua")
ix.util.Include("sv_schema.lua")
ix.util.Include("sv_hooks.lua")

ix.util.Include("meta/sh_player.lua")
ix.util.Include("meta/sv_player.lua")
ix.util.Include("meta/sh_character.lua")

-- ix.flag.Add("v", "Access to light blackmarket goods.")
-- ix.flag.Add("V", "Access to heavy blackmarket goods.")

ix.anim.SetModelClass("models/cg_trp/pm_cg_trp.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine.mdl", "player")
ix.anim.SetModelClass("models/cg_thorn/pm_cg_thorn.mdl", "player")
ix.anim.SetModelClass("models/ct_comms/pm_ct_comms.mdl", "player")
ix.anim.SetModelClass("models/ct_trp/pm_ct_trp.mdl", "player")
ix.anim.SetModelClass("models/senate_honor/pm_senate_honor.mdl", "player")
ix.anim.SetModelClass("models/212th_trp/pm_212th_trp.mdl", "player")
ix.anim.SetModelClass("models/212th_medic/pm_212th_medic.mdl", "player")
ix.anim.SetModelClass("models/212th_xo/pm_212th_xo.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular02.mdl", "player")
ix.anim.SetModelClass("models/501st_trp/pm_501st_trp.mdl", "player")
ix.anim.SetModelClass("models/501st_co/pm_501st_co.mdl", "player")
ix.anim.SetModelClass("models/nsn/arc/arc_colt.mdl", "player")
ix.anim.SetModelClass("models/chet/swtor/fong/jedi_fong.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/human.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/togruta.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/trandoshan.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/twilek.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/twilek2.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/umbaran.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/zabrak.mdl", "player")
ix.anim.SetModelClass("models/501st_pilot/pm_501st_pilot.mdl", "player")
ix.anim.SetModelClass("models/ct_pilot/pm_ct_pilot.mdl", "player")
ix.anim.SetModelClass("models/cg_pilot/pm_cg_pilot.mdl", "player")
ix.anim.SetModelClass("models/ct_arf/pm_ct_arf.mdl", "player")
ix.anim.SetModelClass("models/ct_comms/pm_ct_comms.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/trooper.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/trooper.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/trooper.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/medic.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/pilot.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/pilot.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/hawk.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/pilot.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/keller2.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/pilot.mdl", "player")
ix.anim.SetModelClass("models/herm/ct/trooper/trooper.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/stone.mdl", "player")
ix.anim.SetModelClass("models/gonzo/cgiwindujediarmour/cgiwindujediarmour.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arf.mdl", "player")
ix.anim.SetModelClass("models/ct_arf/pm_ct_arf.mdl", "player")
ix.anim.SetModelClass("models/senate_guard/pm_senate_guard.mdl", "player")
ix.anim.SetModelClass("models/senate_honor/pm_senate_honor.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/secretservice.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army_03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/dreadnought_1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/dreadnought_black1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc_arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/stone.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine_camo1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/medic.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/hound.mdl", "player")
ix.anim.SetModelClass("models/aldmor/tc13_trp_shadow/trp.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine_zash.mdl", "player")
ix.anim.SetModelClass("models/player/jedi/nautolan.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/secretservice_officer.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/specialist.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/heavy_officer.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/dogma.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/rys.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine_camo3.mdll", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular06.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular01.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular01.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular02.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular02.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular04.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular04.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular05.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular05.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular06.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular06.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular07.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular07.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/coloured_regular08.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/alpha/tc13j/colouredblack_regular08.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army_01.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army01_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army_02.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army02_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army_03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/army03_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_01.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy01_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_02.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy02_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy03_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_04.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy04_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_medic.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/navy_medic_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb01.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb01_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb02.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb02_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb03.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/republic/tc13j/rsb03_female.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/thorn.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/ibot.mdl", "player")
ix.anim.SetModelClass("models/player/cheddar/swtor/republic/havoc_squad/havoc_squad_female_soldier.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/marine_oni.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgispc/tc13j/coverttrooper.mdl", "player")
ix.anim.SetModelClass("models/md/arf_212_cm/arf_212_cm.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgispc/tc13j/republic_deathtrooper_cody.mdl", "player")
ix.anim.SetModelClass("models/konnie/starwars/drakavis.mdl", "player")
ix.anim.SetModelClass("models/konnie/starwars/ryrsern.mdl", "player")
ix.anim.SetModelClass("models/konnie/starwars/zakrhan.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arc_phase1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arc_barc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arc_arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi212/tc13j/arc_heavy.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/arc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi21s/tc13j/arc_phase1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc_phase1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc_barc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc_arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgi501/tc13j/arc_heavy.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc_phase1.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc_barc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc_arf.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc_heavy.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/cgicga/tc13j/arc_tracker.mdl", "player")
ix.anim.SetModelClass("models/212th_arc/pm_212th_arc.mdl", "player")
ix.anim.SetModelClass("models/501st_arc/pm_501st_arc.mdl", "player")
ix.anim.SetModelClass("models/cg_arc/pm_cg_arc.mdl", "player")
ix.anim.SetModelClass("models/ct_arc/pm_ct_arc.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/arc/tc13j/fyko.mdl", "player")

function Schema:ZeroNumber(number, length)
	local amount = math.max(0, length - string.len(number))
	return string.rep("0", amount)..tostring(number)
end

-- function Schema:IsCombineRank(text, rank)
-- 	return string.find(text, "[%D+]"..rank.."[%D+]")
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(150, 100, 100)
-- 	CLASS.format = "Dispatch broadcasts \"%s\""

-- 	function CLASS:CanSay(speaker, text)
-- 		if (!speaker:IsDispatch()) then
-- 			speaker:NotifyLocalized("notAllowed")

-- 			return false
-- 		end
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		chat.AddText(self.color, string.format(self.format, text))
-- 	end

-- 	ix.chat.Register("dispatch", CLASS)
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(75, 150, 50)
-- 	CLASS.format = "%s radios in \"%s\""

-- 	function CLASS:CanHear(speaker, listener)
-- 		local character = listener:GetCharacter()
-- 		local inventory = character:GetInventory()
-- 		local bHasRadio = false

-- 		for k, v in pairs(inventory:GetItemsByUniqueID("handheld_radio", true)) do
-- 			if (v:GetData("enabled", false) and speaker:GetCharacter():GetData("frequency") == character:GetData("frequency")) then
-- 				bHasRadio = true
-- 				break
-- 			end
-- 		end

-- 		return bHasRadio
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
-- 		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
-- 	end

-- 	ix.chat.Register("radio", CLASS)
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(255, 255, 175)
-- 	CLASS.format = "%s radios in \"%s\""

-- 	function CLASS:GetColor(speaker, text)
-- 		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
-- 			return Color(175, 255, 175)
-- 		end

-- 		return self.color
-- 	end

-- 	function CLASS:CanHear(speaker, listener)
-- 		if (ix.chat.classes.radio:CanHear(speaker, listener)) then
-- 			return false
-- 		end

-- 		local chatRange = ix.config.Get("chatRange", 280)

-- 		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		text = speaker:IsCombine() and string.format("<:: %s ::>", text) or text
-- 		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
-- 	end

-- 	ix.chat.Register("radio_eavesdrop", CLASS)
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(175, 125, 100)
-- 	CLASS.format = "%s requests \"%s\""

-- 	function CLASS:CanHear(speaker, listener)
-- 		return listener:IsCombine() or speaker:Team() == FACTION_ADMIN
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
-- 	end

-- 	ix.chat.Register("request", CLASS)
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(175, 125, 100)
-- 	CLASS.format = "%s requests \"%s\""

-- 	function CLASS:CanHear(speaker, listener)
-- 		if (ix.chat.classes.request:CanHear(speaker, listener)) then
-- 			return false
-- 		end

-- 		local chatRange = ix.config.Get("chatRange", 280)

-- 		return (speaker:Team() == FACTION_CITIZEN and listener:Team() == FACTION_CITIZEN)
-- 		and (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
-- 	end

-- 	ix.chat.Register("request_eavesdrop", CLASS)
-- end

-- do
-- 	local CLASS = {}
-- 	CLASS.color = Color(150, 125, 175)
-- 	CLASS.format = "%s broadcasts \"%s\""

-- 	function CLASS:CanSay(speaker, text)
-- 		if (speaker:Team() != FACTION_ADMIN) then
-- 			speaker:NotifyLocalized("notAllowed")

-- 			return false
-- 		end
-- 	end

-- 	function CLASS:OnChatAdd(speaker, text)
-- 		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
-- 	end

-- 	ix.chat.Register("broadcast", CLASS)
-- end
