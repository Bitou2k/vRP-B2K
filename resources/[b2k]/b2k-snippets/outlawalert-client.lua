--Config
local timer = 1 --in minutes - Set the time during the player is outlaw
local showOutlaw = false --Set if show outlaw act on map
local gunshotAlert = true --Set if show alert when player use gun
local carJackingAlert = true --Set if show when player do carjacking
local meleeAlert = true --Set if show when player fight in melee
local blipGunTime = 10 --in second
local blipMeleeTime = 10 --in second
local blipJackingTime = 10 -- in second
--End config

local origin = false --Don't touche it
local timing = timer * 60000 --Don't touche it

local PedModels = {
        "s_m_y_cop_01",
        's_m_m_snowcop_01',
        's_m_y_hwaycop_01',
        's_f_y_cop_01',
        's_m_y_sheriff_01',
        's_m_y_ranger_01',
        's_m_m_armoured_01',
        's_m_m_armoured_01',
        's_f_y_sheriff_01',
        's_f_y_ranger_01',
		'ft01',
		'ft02',
		'ft03',
		'ft04',
		'rp01',
		'rp02',
		'rp03',
		'rp04',
		'rota01',
		'rota02',
		'rota03',
		'rota04',
		'rocam01',
		'rocam02',
		'rocam03',
		'rocam04',
		's_m_y_blackops_01',
		's_m_y_swat_01'
        --'s_m_m_ciasec_01',
        --'s_m_m_armoured_01',
        --'s_m_m_armoured_02',
        --'u_m_m_fibarchitect',
        --'s_m_y_swat_01',
    }
GetPlayerName()
RegisterNetEvent('outlawNotify')
AddEventHandler('outlawNotify', function(alert)
    for i = 0, #PedModels do
        if not origin and IsPedModel(GetPlayerPed(-1),GetHashKey(PedModels[i])) then
            Notify(alert)
        end
    end
end)

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if NetworkIsSessionStarted() then
            DecorRegister("IsOutlaw",  3)
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
            return
        end
    end
end)

RegisterNetEvent('thiefPlace')
AddEventHandler('thiefPlace', function(tx, ty, tz)
    for i = 0, #PedModels do
        if not origin and IsPedModel(GetPlayerPed(-1),GetHashKey(PedModels[i])) then
            if carJackingAlert then
                local transT = 250
                local thiefBlip = AddBlipForCoord(tx, ty, tz)
                SetBlipSprite(thiefBlip, 10)
                SetBlipColour(thiefBlip, 1)
                SetBlipAlpha(thiefBlip, transT)
                SetBlipAsShortRange(thiefBlip,  1)
                while transT ~= 0 do
                    Wait(blipJackingTime * 4)
                    transT = transT - 1
                    SetBlipAlpha(thiefBlip,  transT)
                    if transT == 0 then
                        SetBlipSprite(thiefBlip,  2)
                        return end
                end
            end
        end
    end
end)

RegisterNetEvent('gunshotPlace')
AddEventHandler('gunshotPlace', function(gx, gy, gz)
    for i = 0, #PedModels do
        if not origin and IsPedModel(GetPlayerPed(-1),GetHashKey(PedModels[i])) then
            if gunshotAlert then
                local transG = 250
                local gunshotBlip = AddBlipForCoord(gx, gy, gz)
                SetBlipSprite(gunshotBlip, 10)
                SetBlipColour(gunshotBlip, 1)
                SetBlipAlpha(gunshotBlip, transG)
                SetBlipAsShortRange(gunshotBlip,  1)
                while transG ~= 0 do
                    Wait(blipGunTime * 4)
                    transG = transG - 1
                    SetBlipAlpha(gunshotBlip,  transG)
                    if transG == 0 then
                        SetBlipSprite(gunshotBlip,  2)
                        return end
                end
            end
        end
    end
end)

RegisterNetEvent('meleePlace')
AddEventHandler('meleePlace', function(mx, my, mz)
   for i = 0, #PedModels do
        if not origin and IsPedModel(GetPlayerPed(-1),GetHashKey(PedModels[i])) then
            if meleeAlert then
                local transM = 250
                local meleeBlip = AddBlipForCoord(mx, my, mz)
                SetBlipSprite(meleeBlip,  270)
                SetBlipColour(meleeBlip,  17)
                SetBlipAlpha(meleeBlip,  transG)
                SetBlipAsShortRange(meleeBlip,  1)
                while transM ~= 0 do
                    Wait(blipMeleeTime * 4)
                    transM = transM - 1
                    SetBlipAlpha(meleeBlip,  transM)
                    if transM == 0 then
                        SetBlipSprite(meleeBlip,  2)
                        return end
                end
            end
        end
    end
end)

--Star color
--[[1- White
2- Black
3- Grey
4- Clear grey
5-
6-
7- Clear orange
8-
9-
10-
11-
12- Clear blue]]

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        if showOutlaw then
            for i = 0, 31 do
                if DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 2 and GetPlayerPed(i) ~= GetPlayerPed(-1) then
                    gamerTagId = Citizen.InvokeNative(0xBFEFE3321A3F5015, GetPlayerPed(i), ".", false, false, "", 0 )
                    Citizen.InvokeNative(0xCF228E2AA03099C3, gamerTagId, 0) --Show a star
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, true) --Active gamerTagId
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 1) --White star
                elseif DecorGetInt(GetPlayerPed(i), "IsOutlaw") == 1 then
                    Citizen.InvokeNative(0x613ED644950626AE, gamerTagId, 7, 255) -- Set Color to 255
                    Citizen.InvokeNative(0x63BB75ABEDC1F6A0, gamerTagId, 7, false) --Unactive gamerTagId
                end
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        if DecorGetInt(GetPlayerPed(-1), "IsOutlaw") == 2 then
            Wait( math.ceil(timing) )
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 1)
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedTryingToEnterALockedVehicle(GetPlayerPed(-1)) or IsPedJacking(GetPlayerPed(-1)) then
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
			
			if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
				sex = "Homem"
			elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
				sex = "Mulher"
			else
				local male = IsPedMale(GetPlayerPed(-1))
				if male then
					sex = "Homem"
				elseif not male then
					sex = "Mulher"
				end
			end

            TriggerServerEvent('thiefInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            local veh = GetVehiclePedIsTryingToEnter(GetPlayerPed(-1))
            local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
            local vehName2 = GetLabelText(vehName)
            if s2 == 0 then
                TriggerServerEvent('thiefInProgressS1', street1, vehName2, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent('thiefInProgress', street1, street2, vehName2, sex)
            end
            Wait(5000)
            origin = false
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedInMeleeCombat(GetPlayerPed(-1)) then 
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
			if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
				sex = "Homem"
			elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
				sex = "Mulher"
			else
				local male = IsPedMale(GetPlayerPed(-1))
				if male then
					sex = "Homem"
				elseif not male then
					sex = "Mulher"
				end
			end
            TriggerServerEvent('meleeInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            if s2 == 0 then
                TriggerServerEvent('meleeInProgressS1', street1, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent("meleeInProgress", street1, street2, sex)
            end
            Wait(3000)
            origin = false
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(10)
        local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
        local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        if IsPedShooting(GetPlayerPed(-1)) then
            origin = true
            DecorSetInt(GetPlayerPed(-1), "IsOutlaw", 2)
			if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
				sex = "Homem"
			elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
				sex = "Mulher"
			else
				local male = IsPedMale(GetPlayerPed(-1))
				if male then
					sex = "Homem"
				elseif not male then
					sex = "Mulher"
				end
			end
            TriggerServerEvent('gunshotInProgressPos', plyPos.x, plyPos.y, plyPos.z)
            if s2 == 0 then
                TriggerServerEvent('gunshotInProgressS1', street1, sex)
            elseif s2 ~= 0 then
                TriggerServerEvent("gunshotInProgress", street1, street2, sex)
            end
            Wait(3000)
            origin = false
        end
    end
end)