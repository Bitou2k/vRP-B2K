RegisterServerEvent('thiefInProgress')
AddEventHandler('thiefInProgress', function(street1, street2, veh, sex)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "~r~Roubo de veículo por ~w~"..sex.." ~r~entre ~w~"..street1.."~r~ e ~w~"..street2)
	else
		TriggerClientEvent("outlawNotify", -1, "~r~Roubo de veículo modelo ~w~"..veh.." ~r~por ~w~"..sex.." ~r~entre ~w~"..street1.."~r~ e ~w~"..street2)
	end
end)

RegisterServerEvent('thiefInProgressS1')
AddEventHandler('thiefInProgressS1', function(street1, veh, sex)
	if veh == "NULL" then
		TriggerClientEvent("outlawNotify", -1, "~r~Roubo de veículo por ~w~"..sex.." ~r~na ~w~"..street1)
	else
		TriggerClientEvent("outlawNotify", -1, "~r~Roubo de veículo modelo ~w~"..veh.." ~r~por um ~w~"..sex.." ~r~na ~w~"..street1)
	end
end)

RegisterServerEvent('meleeInProgress')
AddEventHandler('meleeInProgress', function(street1, street2, sex)
	--TriggerClientEvent("outlawNotify", -1, "~r~Briga iniciada por ~w~"..sex.." ~r~entre ~w~"..street1.."~r~ e ~w~"..street2)
end)

RegisterServerEvent('meleeInProgressS1')
AddEventHandler('meleeInProgressS1', function(street1, sex)
	--TriggerClientEvent("outlawNotify", -1, "~r~Briga iniciada por ~w~"..sex.." ~r~na ~w~"..street1)
end)


RegisterServerEvent('gunshotInProgress')
AddEventHandler('gunshotInProgress', function(street1, street2, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~Disparo de Arma por ~w~"..sex.." ~r~entre ~w~"..street1.."~r~ e ~w~"..street2)
end)

RegisterServerEvent('gunshotInProgressS1')
AddEventHandler('gunshotInProgressS1', function(street1, sex)
	TriggerClientEvent("outlawNotify", -1, "~r~Disparo de Arma por ~w~"..sex.." ~r~na ~w~"..street1)
end)

RegisterServerEvent('thiefInProgressPos')
AddEventHandler('thiefInProgressPos', function(tx, ty, tz)
	TriggerClientEvent('thiefPlace', -1, tx, ty, tz)
end)

RegisterServerEvent('gunshotInProgressPos')
AddEventHandler('gunshotInProgressPos', function(gx, gy, gz)
	TriggerClientEvent('gunshotPlace', -1, gx, gy, gz)
end)

RegisterServerEvent('meleeInProgressPos')
AddEventHandler('meleeInProgressPos', function(mx, my, mz)
	--TriggerClientEvent('meleePlace', -1, mx, my, mz)
end)