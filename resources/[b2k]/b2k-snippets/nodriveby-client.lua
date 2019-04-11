-- Allow passengers to shoot
local passengerDriveBy = true

-- CODE --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		playerPed = GetPlayerPed(-1)
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			if GetEntityModel(car) == GetHashKey("rocam") or GetEntityModel(car) == GetHashKey("tigerrocam") then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			elseif GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
	end
end)