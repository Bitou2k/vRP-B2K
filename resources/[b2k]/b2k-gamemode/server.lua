-- Call this after playerSpawn, instantly goes into a NUI welcome page
RegisterServerEvent('b2k:serverPlayerSpawn')
AddEventHandler('b2k:serverPlayerSpawn', function()
	TriggerClientEvent('b2k:clientPlayerSpawn', source, -1041.7530517578,-2744.6650390625,21.359392166138, 'G_F_Y_Vagos_01')
end)