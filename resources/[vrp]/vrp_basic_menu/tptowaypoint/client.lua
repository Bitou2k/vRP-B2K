vRP = Proxy.getInterface("vRP")

local function teleportToWaypoint()
	Citizen.CreateThread(function()
		local targetPed = GetPlayerPed(-1)
		local targetVeh = GetVehiclePedIsUsing(targetPed)
		if(IsPedInAnyVehicle(targetPed))then
			targetPed = targetVeh
	    end

		if(not IsWaypointActive())then
			vRP.notify({"~r~ Map Marker not found."})
			return
		end

		local waypointBlip = GetFirstBlipInfoId(8) -- 8 = waypoint Id
		local x,y,z = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, waypointBlip, Citizen.ResultAsVector())) 

		-- ensure entity teleports above the ground
		local ground
		local groundFound = false
		local groundCheckHeights = {100.0, 150.0, 50.0, 0.0, 200.0, 250.0, 300.0, 350.0, 400.0,450.0, 500.0, 550.0, 600.0, 650.0, 700.0, 750.0, 800.0, 850.0, 900.0, 950.0, 1000.0, 1100.0, 1200.0, 1300.0, 1400.0, 1500.0, 1600.0}

		for i,height in ipairs(groundCheckHeights) do
			SetEntityCoordsNoOffset(targetPed, x, y, height, 0, 0, 1)

			RequestCollisionAtCoord(x, y, z)
			while not HasCollisionLoadedAroundEntity(targetPed)do
				RequestCollisionAtCoord(x, y, z)
				Wait(0)
			end
			Wait(20)

			ground,z = GetGroundZFor_3dCoord(x, y, height)
			if (ground) then
				z = z + 5.0
				groundFound = true
				break;
			end
		end

		if (not groundFound) then
			z = 1200
			GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
		end

		RequestCollisionAtCoord(x, y, z)
		while not HasCollisionLoadedAroundEntity(targetPed)do
			RequestCollisionAtCoord(x, y, z)
			Citizen.Wait(0)
		end
		
		SetEntityCoordsNoOffset(targetPed, x, y, z, 0, 0, 1)
		vRP.notify({"~g~ Teleported to waypoint."})
	end)
end
RegisterNetEvent("b2k:TpToWaypoint")
AddEventHandler("b2k:TpToWaypoint", teleportToWaypoint)