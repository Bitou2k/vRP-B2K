local doors = {}

RegisterNetEvent('vrpdoorsystem:load')
AddEventHandler('vrpdoorsystem:load',function(list)
	doors = list
end)

RegisterNetEvent('vrpdoorsystem:statusSend')
AddEventHandler('vrpdoorsystem:statusSend',function(i,status)
	doors[i].locked = status
end)

function searchIdDoor()
	local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	for k,v in pairs(doors) do
		if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 1.5 then
			return k
		end
	end
	return 0
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,38) then
			local id = searchIdDoor()
			if id ~= 0 then
				TriggerServerEvent("vrpdoorsystem:open",id)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
		for k,v in pairs(doors) do
			if GetDistanceBetweenCoords(x,y,z,v.x,v.y,v.z,true) <= 3 then
				local door = GetClosestObjectOfType(v.x,v.y,v.z,1.0,v.hash,false,false,false)
				if door ~= 0 then
					SetEntityCanBeDamaged(door,false)
					if v.locked == false then
						NetworkRequestControlOfEntity(door)
						FreezeEntityPosition(door,false)
						DrawText3DTest(v.x,v.y,v.z+0.50,"~w~[E] Aberta")
					else
						local locked, heading = GetStateOfClosestDoorOfType(v.hash,v.x,v.y,v.z,locked,heading)
						DrawText3DTest(v.x,v.y,v.z+0.50,"~w~[E] Fechada")
						if heading > -0.02 and heading < 0.02 then
							NetworkRequestControlOfEntity(door)
							FreezeEntityPosition(door,true)
						end
					end
				end
			end
		end
	end
end)

function DrawText3DTest(x,y,z,text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextDropshadow(0, 0, 0, 155)
	SetTextEdge(1, 0, 0, 0, 250)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 41, 41, 68)
end