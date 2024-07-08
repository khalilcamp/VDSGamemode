hook.Add("PlayerLoadout", "RD:HackableConsole:GiveDatapadWeapon", function(ply)
	if !NCS_DATAPAD.CONFIG.giveDatapad then return end
	
	ply:Give("datapad_player")
end)

function NCS_DATAPAD.MysqlConnect()
	local READ = NCS_DATAPAD.Mysql

	local HOST = READ.Host
	local PASSWORD = READ.Password
	local DATABASE = READ.Name
	local USERNAME = READ.Username
	local PORT = READ.Port
				
	local MODULE = ( READ.Module or "sqlite" )
	
	RDV_DP_Mysql:SetModule(MODULE)
	
	RDV_DP_Mysql:Connect(HOST, USERNAME, PASSWORD, DATABASE, PORT)
end