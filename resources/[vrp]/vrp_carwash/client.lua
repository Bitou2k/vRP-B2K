
Key = 201 -- ENTER

vehicleWashStation = {
	{26.5906,  -1392.0261,  27.3634},
	{167.1034,  -1719.4704,  27.2916},
	{-74.5693,  6427.8715,  29.4400},
	{-699.6325,  -932.7043,  17.0139}
}

vRP = Proxy.getInterface("vRP")

Citizen.CreateThread(function ()
	Citizen.Wait(1000)
	for i = 1, #vehicleWashStation do
		garageCoords = vehicleWashStation[i]
		stationBlip = AddBlipForCoord(garageCoords[1], garageCoords[2], garageCoords[3])
		SetBlipSprite(stationBlip, 100) -- 100 = carwash
		SetBlipAsShortRange(stationBlip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Lava-Jato")
		EndTextCommandSetBlipName(stationBlip)
	end
    return
end)

function DrawSpecialText(m_text, showtime)
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(5)
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 
			for i = 1, #vehicleWashStation do
				garageCoords2 = vehicleWashStation[i]
				DrawMarker(1, garageCoords2[1], garageCoords2[2], garageCoords2[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), garageCoords2[1], garageCoords2[2], garageCoords2[3], true ) < 5 then
					DrawSpecialText("Pressione [~g~ENTER~s~] para limpar seu veículo!")
					if(IsControlJustPressed(1, Key)) then
						TriggerServerEvent('carwash:checkmoney', GetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
					end
				end
			end
		end
	end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function()
	SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1),false), 0.0)
	SetVehicleUndriveable(GetVehiclePedIsIn(GetPlayerPed(-1),false), false)
	vRP.notify({"Pago R$~r~25."})
end)
RegisterNetEvent('carwash:notenough')
AddEventHandler('carwash:notenough', function()
	vRP.notify({"~r~Dinheiro insuficiente."})
end)
RegisterNetEvent('carwash:alreadyclean')
AddEventHandler('carwash:alreadyclean', function()
	vRP.notify({"~g~Veículo já limpo."})
end)