--[[ Bloquear desvirar veículo ]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(veh) and not IsEntityDead(veh) then
            local model = GetEntityModel(veh)
            -- If it's not a boat, plane or helicopter, and the vehilce is off the ground with ALL wheels, then block steering/leaning left/right/up/down.
            if not IsVehicleModel(veh, GetHashKey("DELUXO")) and not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) and IsEntityInAir(veh) then
                DisableControlAction(0, 59) -- leaning left/right
                DisableControlAction(0, 60) -- leaning up/down
            end
            if GetPedInVehicleSeat(veh, -1) == GetPlayerPed(-1) then
                local roll = GetEntityRoll(veh)
                if (roll > 75.0 or roll < -75.0) then
                    DisableControlAction(2, 59, true)
                    DisableControlAction(2, 60, true)
                end
            end
        end
        
    end
end)