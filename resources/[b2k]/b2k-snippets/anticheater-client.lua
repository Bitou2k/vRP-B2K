
BlacklistedWeapons = { -- weapons that will get people banned
  --"WEAPON_HAMMER",
  --"WEAPON_GOLFCLUB",
  --"WEAPON_CROWBAR",
  "WEAPON_APPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_MICROSMG",
  "WEAPON_ADVANCEDRIFLE",
  "WEAPON_MG",
  "WEAPON_COMBATMG",
  "WEAPON_SAWNOFFSHOTGUN",
  "WEAPON_ASSAULTSHOTGUN",
  "WEAPON_BULLPUPSHOTGUN",
  "WEAPON_SNIPERRIFLE",
  "WEAPON_HEAVYSNIPER",
  "WEAPON_REMOTESNIPER",
  "WEAPON_GRENADELAUNCHER",
  "WEAPON_GRENADELAUNCHER_SMOKE",
  "WEAPON_RPG",
  "WEAPON_PASSENGER_ROCKET",
  "WEAPON_AIRSTRIKE_ROCKET",
  "WEAPON_STINGER",
  "WEAPON_MINIGUN",
  "WEAPON_GRENADE",
  "WEAPON_STICKYBOMB",
  "WEAPON_SMOKEGRENADE",
  "WEAPON_BZGAS",
  "WEAPON_MOLOTOV",
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_DIGISCANNER",
  "WEAPON_BRIEFCASE",
  "WEAPON_BRIEFCASE_02",
  "WEAPON_BALL",
  "WEAPON_FLARE",
  "WEAPON_REVOLVER",
  --"WEAPON_MACHETE",
  "WEAPON_SWITCHBLADE",
  --"WEAPON_HATCHET",
  --"WEAPON_DAGGER",
  --"WEAPON_BOTTLE"
}

CageObjs = {
	"prop_gold_cont_01",
	"p_cablecar_s",
	"stt_prop_stunt_tube_l",
	"stt_prop_stunt_track_dwuturn",
}


Citizen.CreateThread(function()
	while true do
		Wait(30000)
		TriggerServerEvent("anticheese:timer:b2k")
	end
end)

--[[Citizen.CreateThread(function()
	Citizen.Wait(5000)
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
		local still = IsPedStill(ped)
		local vel = GetEntitySpeed(ped)
		local ped = PlayerPedId()
		local veh = IsPedInAnyVehicle(ped, true)
		local speed = GetEntitySpeed(ped)
		local para = GetPedParachuteState(ped)
		local flyveh = IsPedInFlyingVehicle(ped)
		local rag = IsPedRagdoll(ped)
		local fall = IsPedFalling(ped)
		local parafall = IsPedInParachuteFreeFall(ped)
		--SetEntityVisible(PlayerPedId(), true) -- make sure player is visible
		Wait(3000) -- wait 3 seconds and check again

		local more = speed - 9.0 -- avarage running speed is 7.06 so just incase someone runs a bit faster it wont trigger

		local rounds = tonumber(string.format("%.2f", speed))
		local roundm = tonumber(string.format("%.2f", more))


		--if not IsEntityVisible(PlayerPedId()) then
		--	SetEntityHealth(PlayerPedId(), -100) -- if player is invisible kill him!
		--end

		newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
		newPed = PlayerPedId() -- make sure the peds are still the same, otherwise the player probably respawned
		if GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz) > 200 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
			TriggerServerEvent("AntiCheese:NoclipFlag", GetDistanceBetweenCoords(posx,posy,posz, newx,newy,newz))
		end

		if speed > 9.0 and not veh and (para == -1 or para == 0) and not flyveh and not fall and not parafall and not rag then
			--dont activate this, its broken!
			--TriggerServerEvent("AntiCheese:SpeedFlag", rounds, roundm) -- send alert along with the rounded speed and how much faster they are
		end
	end
end)]]

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		local curPed = PlayerPedId()
		local curHealth = GetEntityHealth( curPed )
		SetEntityHealth( curPed, curHealth-2)
		local curWait = math.random(10,150)
		-- this will substract 2hp from the current player, wait 50ms and then add it back, this is to check for hacks that force HP at 200
		Citizen.Wait(curWait)

		if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
			TriggerServerEvent("AntiCheese:HealthFlag", false, curHealth-2, GetEntityHealth( curPed ),curWait )
		elseif GetEntityHealth(curPed) == curHealth-2 then
			SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
		end
		
		if GetEntityHealth(curPed) > 400 then
			TriggerServerEvent("AntiCheese:HealthFlag", false, GetEntityHealth( curPed )-200, GetEntityHealth( curPed ),curWait )
		end

		if GetPlayerInvincible( PlayerId() ) then -- if the player is invincible, flag him as a cheater and then disable their invincibility
			TriggerServerEvent("AntiCheese:HealthFlag", true, curHealth-2, GetEntityHealth( curPed ),curWait )
			SetPlayerInvincible( PlayerId(), false )
		end
	end
end)]]

-- prevent infinite ammo, godmode, invisibility and ped speed hacks, and teleports
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		SetPedInfiniteAmmoClip(PlayerPedId(), false)
		SetEntityInvincible(PlayerPedId(), false)
		SetEntityCanBeDamaged(PlayerPedId(), true)
		ResetEntityAlpha(PlayerPedId())
		local fallin = IsPedFalling(PlayerPedId())
		local ragg = IsPedRagdoll(PlayerPedId())
		local parac = GetPedParachuteState(PlayerPedId())
		if parac >= 0 or ragg or fallin then
			SetEntityMaxSpeed(PlayerPedId(), 80.0)
		else
			SetEntityMaxSpeed(PlayerPedId(), 7.1)
		end
		
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15000)
		local removeAllWeapons = false
		for _,theWeapon in ipairs(BlacklistedWeapons) do
			Citizen.Wait(1)
			if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
					removeAllWeapons = true
					TriggerServerEvent("AntiCheese:WeaponFlag", theWeapon)
			end
		end
		if removeAllWeapons then
			RemoveAllPedWeapons(PlayerPedId(),false)
		end
	end
end)

function ReqAndDelete(object, detach)
	if DoesEntityExist(object) then
		NetworkRequestControlOfEntity(object)
		while not NetworkHasControlOfEntity(object) do
			Citizen.Wait(10)
		end
		if detach then
			DetachEntity(object, 0, false)
		end
		SetEntityCollision(object, false, false)
		SetEntityAlpha(object, 0.0, true)
		SetEntityAsMissionEntity(object, true, true)
		SetEntityAsNoLongerNeeded(object)
		DeleteEntity(object)
	end
end


--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local ped = PlayerPedId()
		local handle, object = FindFirstObject()
		local finished = false
		repeat
			Wait(1)
			if IsEntityAttached(object) and DoesEntityExist(object) then
				if GetEntityModel(object) == GetHashKey("prop_acc_guitar_01") then
					ReqAndDelete(object, true)
				end
			end
			for i=1,#CageObjs do
				if GetEntityModel(object) == GetHashKey(CageObjs[i]) then
					ReqAndDelete(object, false)
				end
			end
			finished, object = FindNextObject(handle)
		until not finished
		EndFindObject(handle)
	end
end)]]


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedJumping(PlayerPedId()) then
			local jumplength = 0
			repeat
				Wait(0)
				jumplength=jumplength+1
				local isStillJumping = IsPedJumping(PlayerPedId())
			until not isStillJumping
			if jumplength > 250 then
				TriggerServerEvent("AntiCheese:JumpFlag", jumplength )
			end
		end
	end
end)

-- Monitorar Spawn de Carro
local tryIntroCar = false



-- Monitorar
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(0,288) then
			TriggerServerEvent("b2k:press",288)
		end
		if IsControlJustPressed(0,166) then
			TriggerServerEvent("b2k:press",166)
		end
		if IsControlJustPressed(0,167) then
			TriggerServerEvent("b2k:press",167)
		end
		if IsControlJustPressed(0,56) then
			TriggerServerEvent("b2k:press",56)
		end
		if IsControlJustPressed(0,108) then
			TriggerServerEvent("b2k:press",108)
		end
		if IsControlJustPressed(0,112) then
			TriggerServerEvent("b2k:press",112)
		end
		if IsControlJustPressed(0,107) then
			TriggerServerEvent("b2k:press",107)
		end
		if IsControlJustPressed(0,111) then
			TriggerServerEvent("b2k:press",111)
		end
	end
end)


local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
