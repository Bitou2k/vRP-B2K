--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

-- TUNNEL AND PROXY
cfg = {}
vRPhk = {}
Tunnel.bindInterface("vrp_hotkeys",vRPhk)
vRPserver = Tunnel.getInterface("vRP","vrp_hotkeys")
HKserver = Tunnel.getInterface("vrp_hotkeys","vrp_hotkeys")
vRP = Proxy.getInterface("vRP")

-- GLOBAL VARIABLES
handsup = false
crouched = false
crouchedState = 0
movFwd = true
pointing = false
engine = true
called = 0

-- anims
cruzarbracos = false
aguardar = false

--



local copskins = {
	"s_m_y_blackops_01",
	"s_m_y_swat_01",
	"rota01",
	"rota02",
	"rota03",
	"rota04",
	"ft01",
	"ft02",
	"ft03",
	"ft04",
	"rp01",
	"rp02",
	"rp03",
	"rp04",
	"rocam01",
	"rocam02",
	"rocam03",
	"rocam04",
	"piloto"
}
function CheckSkin(ped)
	for i = 1, #copskins do
		if GetHashKey(copskins[i]) == GetEntityModel(ped) then
			return true
		end
	end
	return false
end
function DisableActions(ped)
	DisableControlAction(1, 140, true)
	DisableControlAction(1, 141, true)
	DisableControlAction(1, 142, true)
	DisableControlAction(1, 37, true) -- Disables INPUT_SELECT_WEAPON (TAB)
	DisablePlayerFiring(ped, true) -- Disable weapon firing
end
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

-- YOU ARE ON A CLIENT SCRIPT ( Just reminding you ;) )
-- Keys IDs can be found at https://wiki.fivem.net/wiki/Controls

-- Hotkeys Configuration: cfg.hotkeys = {[Key] = {group = 1, pressed = function() end, released = function() end},}
cfg.hotkeys = {
  [20] = {
    -- Z toggle Kneel
    group = 1, 
    pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) then -- Comment to allow use in vehicle
        local player = GetPlayerPed( -1 )
        if ( DoesEntityExist( player ) and not IsEntityDead( player )) then 
			RequestAnimDict("random@arrests")
			while not HasAnimDictLoaded("random@arrests") do
				Wait(0)
			end
			RequestAnimDict("random@arrests@busted")
			while not HasAnimDictLoaded("random@arrests@busted") do
				Wait(0)
			end
			SetCurrentPedWeapon(player, 0xA2719263, true)
            if ( IsEntityPlayingAnim( player, "random@arrests@busted", "idle_a", 3 ) ) then 
                TaskPlayAnim( player, "random@arrests@busted", "exit", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
                Wait (3000)
                TaskPlayAnim( player, "random@arrests", "kneeling_arrest_get_up", 8.0, 1.0, -1, 128, 0, 0, 0, 0 )
            else
                TaskPlayAnim( player, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
                Wait (4000)
                TaskPlayAnim( player, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
                Wait (500)
                TaskPlayAnim( player, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )
                Wait (1000)
                TaskPlayAnim( player, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0 )
            end
        end
      end -- Comment to allow use in vehicle
    end,
    released = function()
	  -- Do nothing on release because it's toggle.
    end,
  },
  [288] = {
    -- F1 toggle Cuff nearest player
    group = 1, 
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
	    HKserver.toggleHandcuff()
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [289] = {
    -- F2 - Police Send QTH
    group = 1,
	pressed = function() 
		if not IsPauseMenuActive() and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({})  then -- Comment to allow use in vehicle
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
			HKserver.sendQTHPolice({x,y,z})
			Citizen.Wait(1000)
		end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [73] = {
    -- X toggle HandsUp
    group = 1, 
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
	    handsup = not handsup
	    SetEnableHandcuffs(GetPlayerPed(-1), handsup)
	    if handsup then
	      vRP.playAnim({true,{{"random@mugging3", "handsup_standing_base", 1}},true})
	    else
	      vRP.stopAnim({true})
		  SetPedStealthMovement(GetPlayerPed(-1),false,"") 
	    end
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [29] = {
    -- B toggle Point
    group = 0, 
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and (GetEntityHealth(GetPlayerPed(-1)) > 105) then  -- Comment to allow use in vehicle
		RequestAnimDict("anim@mp_point")
		while not HasAnimDictLoaded("anim@mp_point") do
          Wait(0)
		end
        pointing = not pointing 
		if pointing then 
		  SetPedCurrentWeaponVisible(GetPlayerPed(-1), 0, 1, 1, 1)
		  SetPedConfigFlag(GetPlayerPed(-1), 36, 1)
		  Citizen.InvokeNative(0x2D537BA194896636, GetPlayerPed(-1), "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
		  RemoveAnimDict("anim@mp_point")
        else
		  Citizen.InvokeNative(0xD01015C7316AE176, GetPlayerPed(-1), "Stop")
		  if not IsPedInjured(GetPlayerPed(-1)) then
		    ClearPedSecondaryTask(GetPlayerPed(-1))
		  end
		  if not IsPedInAnyVehicle(GetPlayerPed(-1), 1) then
		    SetPedCurrentWeaponVisible(GetPlayerPed(-1), 1, 1, 1, 1)
		  end
		  SetPedConfigFlag(GetPlayerPed(-1), 36, 0)
		  ClearPedSecondaryTask(PlayerPedId())
        end 
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [36] = {
    -- CTRL toggle Crouch
    group = 0, 
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and (GetEntityHealth(GetPlayerPed(-1)) > 105) then  -- Comment to allow use in vehicle
        RequestAnimSet("move_ped_crouched")
		while not HasAnimSetLoaded("move_ped_crouched") do 
          Citizen.Wait(0)
        end
        crouched = not crouched 
		if crouched then 
			ResetPedMovementClipset(GetPlayerPed(-1), 0)
			ResetPedWeaponMovementClipset(GetPlayerPed(-1))
			ResetPedStrafeClipset(GetPlayerPed(-1))
        else
			SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched", 0.25)
			--SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched")
			--SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched")
        end
		-- 0 off / 1 - crouched / 2 - prone
		--[[crouchedState = crouchedState + 1
		
		if crouchedState == 1 then
			RequestAnimSet("move_ped_crouched")
			while not HasAnimSetLoaded("move_ped_crouched") do 
			  Citizen.Wait(0)
			end
			SetPedMovementClipset(GetPlayerPed(-1), "move_ped_crouched", 0.25)
			SetPedWeaponMovementClipset(GetPlayerPed(-1), "move_ped_crouched")
			SetPedStrafeClipset(GetPlayerPed(-1), "move_ped_crouched")
		elseif crouchedState == 2 then
			RequestAnimSet("move_crawl")
			while not HasAnimSetLoaded("move_crawl") do 
			  Citizen.Wait(0)
			end
			ResetPedMovementClipset(GetPlayerPed(-1), 0)
			ClearPedTasksImmediately(GetPlayerPed(-1))
			if IsControlPressed(1, 39) then
				movFwd = true
				TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", GetEntityCoords(GetPlayerPed(-1)), 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 1.0, 1.0, 1.0, 47, 1.0, 0, 0)
			else
				TaskPlayAnimAdvanced(GetPlayerPed(-1), "move_crawl", "onfront_fwd", GetEntityCoords(GetPlayerPed(-1)), 0.0, 0.0, GetEntityHeading(GetPlayerPed(-1)), 1.0, 1.0, 1.0, 46, 1.0, 0, 0)
				movFwd = false
			end
		elseif crouchedState == 3 then
			crouchedState = 0
			ClearPedTasksImmediately(GetPlayerPed(-1))
			ResetPedMovementClipset(GetPlayerPed(-1), 0)
			ResetPedWeaponMovementClipset(GetPlayerPed(-1))
			ResetPedStrafeClipset(GetPlayerPed(-1))
		end]]
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  --[[[46] = {
    -- E call/skip emergency
    group = 0, 
	pressed = function() 
	  if vRP.isInComa({}) then
	    if called == 0 then 
	      HKserver.canSkipComa({"coma.skipper","coma.caller"},function(skipper,caller) -- permission to skip when no Doc is online, or just call them when they are. Change them on client.lua too if you do
		    if skipper or caller then
		      HKserver.docsOnline({},function(docs)
		        if docs == 0 and skipper then
				  vRP.killComa({})
			    else
				  called = 30
				  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
				  HKserver.helpComa({x,y,z})
				  Citizen.Wait(1000)
			    end
			  end)
            end
		  end)
		else
		  vRP.notify({"~r~You already called the ambulance."})
		end
	  end
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },]]
  [213] = {
    -- HOME toggle User List
    group = 0, 
	pressed = function()
	  RequestStreamedTextureDict( "mplobby" )
	  RequestStreamedTextureDict( "mpleaderboard" )
	  HKserver.openPlayerList({})
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  --[[[311] = {
    -- K toggle Vehicle Engine
    group = 1, 
	pressed = function() 
      if not IsPauseMenuActive() and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		engine = not engine
		SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), engine, false, false)
	  end
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },]]
  [71] = {
    -- W starts Vehicle Engine
    group = 1, 
	pressed = function() 
      if not IsPauseMenuActive() and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		engine = true
		SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), engine, false, false)
	  end
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  --[[182] = {
    -- L toggle Vehicle Lock
    group = 1, 
	pressed = function() 
	  player = GetPlayerPed(-1)
	  vehicle = GetVehiclePedIsIn(player, false)
	  isPlayerInside = IsPedInAnyVehicle(player, true)
	  lastVehicle = GetPlayersLastVehicle()
	  px, py, pz = table.unpack(GetEntityCoords(player, true))
	  coordA = GetEntityCoords(player, true)

	  for i = 1, 32 do
		coordB = GetOffsetFromEntityInWorldCoords(player, 0.0, (6.281)/i, 0.0)
		local rayHandle = CastRayPointToPoint(coordA.x, coordA.y, coordA.z, coordB.x, coordB.y, coordB.z, 10, GetPlayerPed(-1), 0)
		local a, b, c, d, rayVehicle = GetRaycastResult(rayHandle)
		targetVehicle = rayVehicle
		if targetVehicle ~= nil and targetVehicle ~= 0 then
		  vx, vy, vz = table.unpack(GetEntityCoords(targetVehicle, false))
		  if GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false) then
			distance = GetDistanceBetweenCoords(px, py, pz, vx, vy, vz, false)
			break
		  end
		end
	  end

	  if distance ~= nil and distance <= 5 and targetVehicle ~= 0 or vehicle ~= 0 then
		if vehicle ~= 0 then
		  plate = GetVehicleNumberPlateText(vehicle)
		else
		  vehicle = targetVehicle
		  plate = GetVehicleNumberPlateText(vehicle)
		end
	    HKserver.canUserLockVehicle({plate, vehicle, isPlayerInside})
	  end
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },]]

  [244] = {
    -- M -- Cruzar braços
    group = 1,
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
      	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
	    cruzarbracos = not cruzarbracos
	    aguardar = false
	    if cruzarbracos then
	      vRP.playAnim({true, {{"amb@world_human_hang_out_street@female_arms_crossed@idle_a","idle_a",1}}, true})
	    else
	      vRP.stopAnim({true})
	    end
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [47] = {
    -- G -- 
    group = 1,
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
      	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
	    vRP.playAnim({true,{{"rcmnigel1c","hailing_whistle_waive_a"}},false})
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [246] = {
    -- Y -- 
    group = 1,
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
      	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
	    vRP.playAnim({true, {{"anim@mp_player_intupperthumbs_up","idle_a",1}}, false})
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [182] = {
    -- L -- 
    group = 1,
	pressed = function() 
      if not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle
      	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
	    aguardar = not aguardar
	    cruzarbracos = false
	    if aguardar then
	      vRP.playAnim({true, {{"mini@strip_club@idles@bouncer@base","base",1}}, true})
	    else
	      vRP.stopAnim({true})
	    end
	  end -- Comment to allow use in vehicle
	end,
	released = function()
	  -- Do nothing on release because it's toggle.
	end,
  },
  [19] = {
    -- LEFT ALT -- 
    group = 0,
	pressed = function() 
      if CheckSkin(GetPlayerPed(-1)) and not IsPauseMenuActive() and not IsPedInAnyVehicle(GetPlayerPed(-1), true) and not IsPedSwimming(GetPlayerPed(-1)) and not IsPedSwimmingUnderWater(GetPlayerPed(-1)) and not IsPedShooting(GetPlayerPed(-1)) and not IsPedDiving(GetPlayerPed(-1)) and not IsPedFalling(GetPlayerPed(-1)) and (GetEntityHealth(GetPlayerPed(-1)) > 105) and not vRP.isHandcuffed({}) then -- Comment to allow use in vehicle

      	loadAnimDict("random@arrests")
      	if not IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
			TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 12.0, 3.0, -1, 50, 2.0, 0, 0, 0 )
		elseif IsPlayerFreeAiming(PlayerId()) then -- INPUT_CHARACTER_WHEEL (LEFT ALT)
			TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "radio_chatter", 12.0, 3.0, -1, 50, 2.0, 0, 0, 0 )
		end
		if IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "generic_radio_enter", 3) then
			DisableActions(GetPlayerPed(-1))
		elseif IsEntityPlayingAnim(GetPlayerPed(PlayerId()), "random@arrests", "radio_chatter", 3) then
			DisableActions(GetPlayerPed(-1))
		end

	  end -- Comment to allow use in vehicle
	end,
	released = function()
		if CheckSkin(GetPlayerPed(-1)) then
			ClearPedTasks(GetPlayerPed(-1))
		end
	  -- Do nothing on release because it's toggle.
	end,
  }
}



