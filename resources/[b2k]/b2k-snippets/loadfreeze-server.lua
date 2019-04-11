-- unfreeze on spawn
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	local player = source
	SetTimeout(30000,function() 
		TriggerClientEvent('b2k:unfreeze',player,false)
	end)
end)