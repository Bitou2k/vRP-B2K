-- Disable drop weapons
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
	-- Remove vehicles giving you weapons
	DisablePlayerVehicleRewards(PlayerId())
  end
end)

-- No weapons drops
Citizen.CreateThread(function()
	while true do
		-- List of pickup hashes (https://pastebin.com/8EuSv2r1)
		RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
		RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
		RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun

        Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
    while true do

        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
        Citizen.Wait(3000)
    end
end)

Citizen.CreateThread(function()
	-- Disable police dispatch for the player in general.
	SetDispatchCopsForPlayer(NetworkPlayerIdToInt(), false)
	
	-- Disable specific/more emergency services from being dispatched.
	EnableDispatchService(1, false) -- Police Automobile -- PoliceAutomobileDispatch
	EnableDispatchService(2, false) -- Police Helicopter -- PoliceHelicopterDispatch
	EnableDispatchService(3, true) -- Swat Helicopter -- FireDepartmentDispatch
	EnableDispatchService(4, false) -- Fire Department -- SwatAutomobileDispatch
	EnableDispatchService(5, false) -- Swat Automobile -- AmbulanceDepartmentDispatch
	EnableDispatchService(6, true) -- Ambulance Department -- PoliceRidersDispatch
	EnableDispatchService(7, false) -- Gangs -- PoliceVehicleRequest
	EnableDispatchService(8, false) -- Police Riders -- PoliceRoadBlockDispatch
	EnableDispatchService(9, false) -- Police Vehicle Request -- 11 GangDispatch
	EnableDispatchService(12, false) -- SwatHelicopterDispatch
	EnableDispatchService(13, false) -- PoliceBoatDispatch
	EnableDispatchService(14, false) -- ArmyVehicleDispatch
	EnableDispatchService(15, false) -- BikerBackupDispatch
		
	--for i = 1, 12 do
	--	Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	--end
end)


Citizen.CreateThread(function()
	while true do
		local handle, ped = FindFirstPed()
		local finished = false -- FindNextPed will turn the first variable to false when it fails to find another ped in the index
		repeat
			if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) then
				SetEntityAsMissionEntity(ped,true,true)
				SetEntityAsNoLongerNeeded(ped)
				local model = GetEntityModel(ped)
				SetModelAsNoLongerNeeded(model)
				SetEntityAsMissionEntity(ped,true,true)
				DeleteEntity(ped)
			end
			finished, ped = FindNextPed(handle) -- first param returns true while entities are found
			if IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) then
				SetEntityAsMissionEntity(ped,true,true)
				SetEntityAsNoLongerNeeded(ped)
				local model = GetEntityModel(ped)
				SetModelAsNoLongerNeeded(model)
				SetEntityAsMissionEntity(ped,true,true)
				DeleteEntity(ped)
			end
			if not IsPedDeadOrDying(ped) and not IsPedAPlayer(ped) then
				RemoveAllPedWeapons(ped, true) -- prevents mod menu npcs
			end
			
		until not finished
		EndFindPed(handle)
		Citizen.Wait(60000)
	end
end)

-- Vehicles Weapons Disables
local vehicle_weapon_names = {
	"VEHICLE_WEAPON_WATER_CANNON",
	"VEHICLE_WEAPON_PLAYER_LAZER",
	"VEHICLE_WEAPON_PLANE_ROCKET",
	"VEHICLE_WEAPON_ENEMY_LASER",
	"VEHICLE_WEAPON_TANK",
	"VEHICLE_WEAPON_SEARCHLIGHT",
	"VEHICLE_WEAPON_RADAR",
	"VEHICLE_WEAPON_PLAYER_BUZZARD",
	"VEHICLE_WEAPON_SPACE_ROCKET",
	"VEHICLE_WEAPON_TURRET_INSURGENT",
	"VEHICLE_WEAPON_PLAYER_SAVAGE",
	"VEHICLE_WEAPON_TURRET_TECHNICAL",
	"VEHICLE_WEAPON_NOSE_TURRET_VALKYRIE",
	"VEHICLE_WEAPON_TURRET_VALKYRIE",
	"VEHICLE_WEAPON_CANNON_BLAZER",
	"VEHICLE_WEAPON_TURRET_BOXVILLE",
	"VEHICLE_WEAPON_RUINER_BULLET",
	"VEHICLE_WEAPON_RUINER_ROCKET",
	"VEHICLE_WEAPON_HUNTER_MG",
	"VEHICLE_WEAPON_HUNTER_MISSILE",
	"VEHICLE_WEAPON_HUNTER_CANNON",
	"VEHICLE_WEAPON_HUNTER_BARRAGE",
	"VEHICLE_WEAPON_TULA_NOSEMG",
	"VEHICLE_WEAPON_TULA_MG",
	"VEHICLE_WEAPON_TULA_DUALMG",
	"VEHICLE_WEAPON_TULA_MINIGUN",
	"VEHICLE_WEAPON_SEABREEZE_MG",
	"VEHICLE_WEAPON_MICROLIGHT_MG",
	"VEHICLE_WEAPON_DOGFIGHTER_MG",
	"VEHICLE_WEAPON_DOGFIGHTER_MISSILE",
	"VEHICLE_WEAPON_MOGUL_NOSE",
	"VEHICLE_WEAPON_MOGUL_DUALNOSE",
	"VEHICLE_WEAPON_MOGUL_TURRET",
	"VEHICLE_WEAPON_MOGUL_DUALTURRET",
	"VEHICLE_WEAPON_ROGUE_MG",
	"VEHICLE_WEAPON_ROGUE_CANNON",
	"VEHICLE_WEAPON_ROGUE_MISSILE",
	"VEHICLE_WEAPON_BOMBUSHKA_DUALMG",
	"VEHICLE_WEAPON_BOMBUSHKA_CANNON",
	"VEHICLE_WEAPON_HAVOK_MINIGUN",
	"VEHICLE_WEAPON_VIGILANTE_MG",
	"VEHICLE_WEAPON_VIGILANTE_MISSILE",
	"VEHICLE_WEAPON_TURRET_LIMO",
	"VEHICLE_WEAPON_DUNE_MG",
	"VEHICLE_WEAPON_DUNE_GRENADELAUNCHER",
	"VEHICLE_WEAPON_DUNE_MINIGUN",
	"VEHICLE_WEAPON_TAMPA_MISSILE",
	"VEHICLE_WEAPON_TAMPA_MORTAR",
	"VEHICLE_WEAPON_TAMPA_FIXEDMINIGUN",
	"VEHICLE_WEAPON_TAMPA_DUALMINIGUN",
	"VEHICLE_WEAPON_HALFTRACK_DUALMG",
	"VEHICLE_WEAPON_HALFTRACK_QUADMG",
	"VEHICLE_WEAPON_APC_CANNON",
	"VEHICLE_WEAPON_APC_MISSILE",
	"VEHICLE_WEAPON_APC_MG",
	"VEHICLE_WEAPON_ARDENT_MG",
	"VEHICLE_WEAPON_TECHNICAL_MINIGUN",
	"VEHICLE_WEAPON_INSURGENT_MINIGUN",
	"VEHICLE_WEAPON_TRAILER_QUADMG",
	"VEHICLE_WEAPON_TRAILER_MISSILE",
	"VEHICLE_WEAPON_TRAILER_DUALAA",
	"VEHICLE_WEAPON_NIGHTSHARK_MG",
	"VEHICLE_WEAPON_OPPRESSOR_MG",
	"VEHICLE_WEAPON_OPPRESSOR_MISSILE",
	"VEHICLE_WEAPON_MOBILEOPS_CANNON",
	"VEHICLE_WEAPON_AKULA_TURRET_SINGLE",
	"VEHICLE_WEAPON_AKULA_MISSILE",
	"VEHICLE_WEAPON_AKULA_TURRET_DUAL",
	"VEHICLE_WEAPON_AKULA_MINIGUN",
	"VEHICLE_WEAPON_AKULA_BARRAGE",
	"VEHICLE_WEAPON_AVENGER_CANNON",
	"VEHICLE_WEAPON_BARRAGE_TOP_MG",
	"VEHICLE_WEAPON_BARRAGE_TOP_MINIGUN",
	"VEHICLE_WEAPON_BARRAGE_REAR_MG",
	"VEHICLE_WEAPON_BARRAGE_REAR_MINIGUN",
	"VEHICLE_WEAPON_BARRAGE_REAR_GL",
	"VEHICLE_WEAPON_CHERNO_MISSILE",
	"VEHICLE_WEAPON_COMET_MG",
	"VEHICLE_WEAPON_DELUXO_MG",
	"VEHICLE_WEAPON_DELUXO_MISSILE",
	"VEHICLE_WEAPON_KHANJALI_CANNON",
	"VEHICLE_WEAPON_KHANJALI_CANNON_HEAVY",
	"VEHICLE_WEAPON_KHANJALI_MG",
	"VEHICLE_WEAPON_KHANJALI_GL",
	"VEHICLE_WEAPON_REVOLTER_MG",
	"VEHICLE_WEAPON_WATER_CANNON",
	"VEHICLE_WEAPON_SAVESTRA_MG",
	"VEHICLE_WEAPON_SUBCAR_MG",
	"VEHICLE_WEAPON_SUBCAR_MISSILE",
	"VEHICLE_WEAPON_SUBCAR_TORPEDO",
	"VEHICLE_WEAPON_THRUSTER_MG",
	"VEHICLE_WEAPON_THRUSTER_MISSILE",
	"VEHICLE_WEAPON_VISERIS_MG",
	"VEHICLE_WEAPON_VOLATOL_DUALMG"
}

Citizen.CreateThread(function()
    vehicle_weapons = {}

    --slight optimization
    for _,v in next, vehicle_weapon_names do
        table.insert(vehicle_weapons, GetHashKey(v))
    end

    while true do
        for i=0,64,1 do
		    local ply = GetPlayerPed(i)
		    local veh = GetVehiclePedIsIn(ply, false)

		    if DoesVehicleHaveWeapons(veh) then
			    for _,v in next, vehicle_weapons do
				    DisableVehicleWeapon(true, v, veh, ply)	
			    end
		    end
        end
        Citizen.Wait(100)
    end
end)