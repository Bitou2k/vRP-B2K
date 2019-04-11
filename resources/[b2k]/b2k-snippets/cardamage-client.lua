--[[function GetVehHealthPercent()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 50
	local maxhealth = GetEntityMaxHealth(vehicle) - 50
	local procentage = (vehiclehealth / maxhealth) * 50
	return procentage
end

function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsUsing(ped)
		local damage = GetVehHealthPercent(vehicle)
		if IsPedInAnyVehicle(ped, false) then
			SetPlayerVehicleDamageModifier(PlayerId(), 50) -- Seems to not work at the moment --
			if damage < 45 then
				SetVehicleUndriveable(vehicle, true)
				ShowNotification("Seu veículo quebrou. Vá em Telefone > Serviços para chamar um ~b~Mecânico~w~.")
			end
		end
	end
end)]]
