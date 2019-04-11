local currentlyTowedVehicle = nil

RegisterNetEvent('pv:tow')
AddEventHandler('pv:tow', function()
	
	local playerped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(playerped, true)
	
	local towmodel = GetHashKey('flatbed')
	local isVehicleTow = IsVehicleModel(vehicle, towmodel)
			
	if isVehicleTow then
	
		local coordA = GetEntityCoords(playerped, 1)
		local coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 5.0, 0.0)
		local targetVehicle = getVehicleInDirection(coordA, coordB)
		
		if currentlyTowedVehicle == nil then
			if targetVehicle ~= 0 then
				local x,y,z = table.unpack(GetEntityCoords(targetVehicle,true))
				if GetDistanceBetweenCoords(x,y,z,coordA.x, coordA.y, coordA.z,true) < 9999999999999 then
					if not IsPedInAnyVehicle(playerped, true) then
						if vehicle ~= targetVehicle then
							AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
							currentlyTowedVehicle = targetVehicle
							TriggerEvent("chatMessage", "[Mecânico]", {255, 255, 0}, "Veículo anexado com sucesso ao caminhão de reboque!")
						else
							TriggerEvent("chatMessage", "[Mecânico]", {255, 255, 0}, "Você é retardado? Você pode rebocar seu próprio caminhão de reboque com seu próprio caminhão de reboque?")
						end
					end
				end
			else
				TriggerEvent("chatMessage", "[Mecânico]", {255, 255, 0}, "Não há veículo para rebocar?")
			end
		else
			AttachEntityToEntity(currentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
			DetachEntity(currentlyTowedVehicle, true, true)
			currentlyTowedVehicle = nil
			TriggerEvent("chatMessage", "[Mecânico]", {255, 255, 0}, "O veículo foi removido com sucesso!")
		end
	end
end)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end


--[[function tvRP.forceDespawnGarageVehicle(name)
  local vehicle = vehicles[name]
  if vehicle then
    local x,y,z = table.unpack(GetEntityCoords(vehicle[2],true))
    local px,py,pz = tvRP.getPosition()
    if GetDistanceBetweenCoords(x,y,z,px,py,pz,true) < 9999999999999 then -- check distance with the vehicule
		-- remove vehicle
		SetVehicleHasBeenOwnedByPlayer(vehicle[2],false)
		Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[2], false, true) -- set not as mission entity
		SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[2]))
		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[2]))
		vehicles[name] = nil
		tvRP.notify("Veículo removido do Mundo.")
	end
  end
end]]