-- decorators
DecorRegister("vRP_owner", 3)
DecorRegister("vRP_vmodel", 3)

local veh_models = {}
local vehicles = {}
local blipCar = nil

function tvRP.setVehicleModelsIndex(index)
  veh_models = index

  -- generate bidirectional keys
  for k,v in pairs(veh_models) do
    veh_models[v] = k
  end
end

-- veh: vehicle game id
-- return owner_user_id, vname (or nil if not managed by vRP)
function tvRP.getVehicleInfos(veh)
  if veh then
    if DecorExistOn(veh, "vRP_owner") and DecorExistOn(veh, "vRP_vmodel") then
      local user_id = DecorGetInt(veh, "vRP_owner")
      local vmodel = DecorGetInt(veh, "vRP_vmodel")
      local vname = veh_models[vmodel]

      if vname then
        return user_id, vname
      end
    end
    -- try get by network id
    for k,v in pairs(vehicles) do
      if v[3] == VehToNet(veh) then
        local vname = veh_models[v[1]]
        return v[4], vname
      end
    end
  end
end

function tvRP.clearAreaOfVehicles(radius)
  local closeby = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(closeby) then -- precheck if vehicle is undriveable
    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(closeby,false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, closeby, false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(closeby))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(closeby))
	 return tvRP.clearAreaOfVehicles(radius)
  end
  return true
end

function tvRP.spawnGarageVehicle(name,pos) -- one vehicle per vname/model allowed at the same time

  --[[local vehicle = vehicles[name]
  if vehicle and not IsVehicleDriveable(vehicle[2]) then -- precheck if vehicle is undriveable
    -- clear blip
    if DoesBlipExist(blipCar) then
      RemoveBlip(blipCar)
    end

    -- clear decor (prevents duplicated chest?)
    DecorRemove(vehicle[2], "vRP_owner")
    DecorRemove(vehicle[2], "vRP_vmodel")

    -- despawn vehicle
    SetVehicleHasBeenOwnedByPlayer(vehicle[2],false)
    Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[2], false, true) -- set not as mission entity
    SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[2]))
    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[2]))
    vehicles[name] = nil
  end]]

  local vehicle = vehicles[name]
  if vehicle == nil then
    -- load vehicle model
    local mhash = GetHashKey(name)

    local i = 0
    while not HasModelLoaded(mhash) and i < 10000 do
      RequestModel(mhash)
      Citizen.Wait(10)
      i = i+1
    end

    -- spawn car
    if HasModelLoaded(mhash) then
      local x,y,z = tvRP.getPosition()
      if pos then
        x,y,z = table.unpack(pos)
      end

      local nveh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
      local netveh = VehToNet(nveh)

      NetworkRegisterEntityAsNetworked(nveh)
      while not NetworkGetEntityIsNetworked(nveh) do
        NetworkRegisterEntityAsNetworked(nveh)
        Citizen.Wait(1)
      end

      if NetworkDoesNetworkIdExist(netveh) then
        SetEntitySomething(nveh, 1)
        if NetworkGetEntityIsNetworked(nveh) then
          SetNetworkIdExistsOnAllMachines(netveh, 1)
        end
      end

      NetworkFadeInEntity(NetToEnt(netveh), 1)
      SetNetworkIdSyncToPlayer(nveh, PlayerId(), 1)

      SetVehicleOnGroundProperly(NetToVeh(netveh))
      SetVehicleIsStolen(NetToVeh(netveh), false)
      SetVehicleNeedsToBeHotwired(NetToVeh(netveh), false)

      SetEntityInvincible(NetToVeh(netveh), false)
      SetPedIntoVehicle(GetPlayerPed(-1), NetToVeh(netveh), -1) -- put player inside
      SetVehicleNumberPlateText(NetToVeh(netveh), "" .. tvRP.getRegistrationNumber())
      SetEntityAsMissionEntity(NetToVeh(netveh), true, true)
      --Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true) -- set as mission entity
      SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh), true)
	  
      SetVehRadioStation(NetToVeh(netveh), "OFF")

      -- set decorators
      DecorSetInt(NetToVeh(netveh), "vRP_owner", tvRP.getUserId())
      DecorSetInt(NetToVeh(netveh), "vRP_vmodel", veh_models[name])

      vehicles[name] = {name,NetToVeh(netveh),netveh,tvRP.getUserId()} -- set current vehicule

      -- clear old blip
      if DoesBlipExist(blipCar) then
        RemoveBlip(blipCar)
      end
      blipCar = AddBlipForEntity(NetToVeh(netveh))
      SetBlipSprite(blipCar, 225)
      SetBlipAsShortRange(blipCar, true)
      SetBlipColour(blipCar, 2)
      SetBlipScale(blipCar, 0.85)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("Meu Veículo")
      EndTextCommandSetBlipName(blip)

      SetModelAsNoLongerNeeded(mhash)

      --local netent = NetToEnt(netveh)
      --SetEntityAsNoLongerNeeded(netent)
      --if IsEntityAVehicle(nveh) then
		  --  vRPserver.resetCooldown()
      --end
      return true
    end
  else
    --vRPserver.resetCooldown()
    tvRP.notify("Você já possui um veículo do modelo fora.")
    return false
  end
end


function tvRP.AdminUpgrade()
  ClearVehicleCustomPrimaryColour(GetVehiclePedIsIn(GetPlayerPed(-1), false))
  ClearVehicleCustomSecondaryColour(GetVehiclePedIsIn(GetPlayerPed(-1), false))
  SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
  SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
  ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
  SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
  SetVehicleTyreSmokeColor(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, 0, 127)
  SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
  SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
  SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false), "B2KRP")
  SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
  SetVehicleModColor_1(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 12, 0)
  SetVehicleModColor_2(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, 12)
  SetVehicleColours(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, 12)
  SetVehicleExtraColours(GetVehiclePedIsIn(GetPlayerPed(-1), false), 70, 141)
end

function tvRP.FixClean()
  SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
  SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
  SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
  SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
  SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
  SetVehicleOnGroundProperly(GetVehiclePedIsIn(GetPlayerPed(-1), false))
end

function tvRP.setVehicleMods(custom)
  local ped = GetPlayerPed(-1)
  local veh = GetVehiclePedIsUsing(ped)
  if custom and veh then
    SetVehicleModKit(veh,0)
    if custom.color then
      SetVehicleColours(veh, tonumber(custom.color[1]), tonumber(custom.color[2]))
      SetVehicleExtraColours(veh, tonumber(custom.extracolor[1]), tonumber(custom.extracolor[2]))
	end
  	if custom.smokecolor then
      SetVehicleTyreSmokeColor(veh,tonumber(custom.smokecolor[1]),tonumber(custom.smokecolor[2]),tonumber(custom.smokecolor[3]))
  	end
	
    if custom.neon then
        SetVehicleNeonLightEnabled(veh,0, 1)
        SetVehicleNeonLightEnabled(veh,1, 1)
        SetVehicleNeonLightEnabled(veh,2, 1)
        SetVehicleNeonLightEnabled(veh,3, 1)
        SetVehicleNeonLightsColour(veh,tonumber(custom.neoncolor[1]),tonumber(custom.neoncolor[2]),tonumber(custom.neoncolor[3]))
    else
        SetVehicleNeonLightEnabled(veh,0, 0)
        SetVehicleNeonLightEnabled(veh,1, 0)
        SetVehicleNeonLightEnabled(veh,2, 0)
        SetVehicleNeonLightEnabled(veh,3, 0)
	end

  if custom.plateindex then
    SetVehicleNumberPlateTextIndex(veh,tonumber(custom.plateindex))
  end

  if custom.windowtint then SetVehicleWindowTint(veh,tonumber(custom.windowtint)) end
  if custom.bulletProofTyres then SetVehicleTyresCanBurst(veh, custom.bulletProofTyres) end
  if custom.wheeltype then SetVehicleWheelType(veh, tonumber(custom.wheeltype)) end

	if custom.spoiler then
		SetVehicleMod(veh, 0, tonumber(custom.spoiler))
		SetVehicleMod(veh, 1, tonumber(custom.fbumper))
		SetVehicleMod(veh, 2, tonumber(custom.rbumper))
		SetVehicleMod(veh, 3, tonumber(custom.skirts))
		SetVehicleMod(veh, 4, tonumber(custom.exhaust))
		SetVehicleMod(veh, 5, tonumber(custom.rollcage))
		SetVehicleMod(veh, 6, tonumber(custom.grille))
		SetVehicleMod(veh, 7, tonumber(custom.hood))
		SetVehicleMod(veh, 8, tonumber(custom.fenders))
		SetVehicleMod(veh, 10, tonumber(custom.roof))
		SetVehicleMod(veh, 11, tonumber(custom.engine))
		SetVehicleMod(veh, 12, tonumber(custom.brakes))
		SetVehicleMod(veh, 13, tonumber(custom.transmission))
		SetVehicleMod(veh, 14, tonumber(custom.horn))
		SetVehicleMod(veh, 15, tonumber(custom.suspension))
		SetVehicleMod(veh, 16, tonumber(custom.armor))
		SetVehicleMod(veh, 23, tonumber(custom.tires), custom.tiresvariation)
		
		if IsThisModelABike(GetEntityModel(veh)) then
			SetVehicleMod(veh, 24, tonumber(custom.btires), custom.btiresvariation)
		end
		
		SetVehicleMod(veh, 25, tonumber(custom.plateholder))
		SetVehicleMod(veh, 26, tonumber(custom.vanityplates))
		SetVehicleMod(veh, 27, tonumber(custom.trimdesign)) 
		SetVehicleMod(veh, 28, tonumber(custom.ornaments))
		SetVehicleMod(veh, 29, tonumber(custom.dashboard))
		SetVehicleMod(veh, 30, tonumber(custom.dialdesign))
		SetVehicleMod(veh, 31, tonumber(custom.doors))
		SetVehicleMod(veh, 32, tonumber(custom.seats))
		SetVehicleMod(veh, 33, tonumber(custom.steeringwheels))
		SetVehicleMod(veh, 34, tonumber(custom.shiftleavers))
		SetVehicleMod(veh, 35, tonumber(custom.plaques))
		SetVehicleMod(veh, 36, tonumber(custom.speakers))
		SetVehicleMod(veh, 37, tonumber(custom.trunk)) 
		SetVehicleMod(veh, 38, tonumber(custom.hydraulics))
		SetVehicleMod(veh, 39, tonumber(custom.engineblock))
		SetVehicleMod(veh, 40, tonumber(custom.camcover))
		SetVehicleMod(veh, 41, tonumber(custom.strutbrace))
		SetVehicleMod(veh, 42, tonumber(custom.archcover))
		SetVehicleMod(veh, 43, tonumber(custom.aerials))
		SetVehicleMod(veh, 44, tonumber(custom.roofscoops))
		SetVehicleMod(veh, 45, tonumber(custom.tank))
		SetVehicleMod(veh, 46, tonumber(custom.doors))
		SetVehicleMod(veh, 48, tonumber(custom.liveries))
			
		ToggleVehicleMod(veh, 20, tonumber(custom.tyresmoke))
		ToggleVehicleMod(veh, 22, tonumber(custom.headlights))
		ToggleVehicleMod(veh, 18, tonumber(custom.turbo))
	end
	
  end
end

function tvRP.despawnGarageVehicle(name)
  local vehicle = vehicles[name]
  if vehicle then
    if GetVehicleBodyHealth(vehicle[2]) < 980 then
		  tvRP.notify("Veículo está danificado. Impossível guarda-lo.")
    else
  		-- remove vehicle
  		SetVehicleHasBeenOwnedByPlayer(vehicle[2],false)
  		Citizen.InvokeNative(0xAD738C3085FE7E11, vehicle[2], false, true) -- set not as mission entity
  		SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(vehicle[2]))
  		Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle[2]))
  		vehicles[name] = nil
  		tvRP.notify("Veículo guardado.")
	   end
  end
end

function tvRP.forceDespawnGarageVehicle(name)
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
end

-- New Method:
-- return map of veh => distance
function tvRP.getNearestVehicles(radius)
  local r = {}

  local px,py,pz = tvRP.getPosition()

  local vehs = {}
  local it, veh = FindFirstVehicle()
  if veh then table.insert(vehs, veh) end
  local ok
  repeat
    ok, veh = FindNextVehicle(it)
    if ok and veh then table.insert(vehs, veh) end
  until not ok
  EndFindVehicle(it)

  for _,veh in pairs(vehs) do
    local x,y,z = table.unpack(GetEntityCoords(veh,true))
    local distance = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)
    if distance <= radius then
      r[veh] = distance
    end
  end

  return r
end

function tvRP.getNearestVehicle(radius)
  local veh

  local vehs = tvRP.getNearestVehicles(radius)
  local min = radius+0.0001
  for _veh,dist in pairs(vehs) do
    if dist < min then
      min = dist
      veh = _veh
    end
  end

  return veh 
end

-- try to re-own the nearest vehicle
function tvRP.tryOwnNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if veh then
    local user_id, vname = tvRP.getVehicleInfos(veh)
    if user_id and user_id == tvRP.getUserId() then
		  local netveh = VehToNet(veh)
      if vehicles[vname] ~= nil and vehicles[vname][1] == vname and vehicles[vname][2] ~= NetToVeh(netveh) then
        vehicles[vname][2] = NetToVeh(netveh)
      end
    end
  end
end

function tvRP.getObjToNet(objectId)
  return ObjToNet(objectId)
end

function tvRP.fixeNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleFixed(veh)
  end
end

function tvRP.replaceNearestVehicle(radius)
  local veh = tvRP.getNearestVehicle(radius)
  if IsEntityAVehicle(veh) then
    SetVehicleOnGroundProperly(veh)
  end
end

-- try to get a vehicle at a specific position (using raycast)
function tvRP.getVehicleAtPosition(x,y,z)
  x = x+0.0001
  y = y+0.0001
  z = z+0.0001

  local ray = CastRayPointToPoint(x,y,z,x,y,z+4,10,GetPlayerPed(-1),0)
  local a, b, c, d, ent = GetRaycastResult(ray)
  return ent
end

-- return ok,name
function tvRP.getNearestOwnedVehicle(radius)
  tvRP.tryOwnNearestVehicle(radius) -- get back network lost vehicles

  local px,py,pz = tvRP.getPosition()
  local min_dist
  local min_k
  for k,v in pairs(vehicles) do
    local x,y,z = table.unpack(GetEntityCoords(v[2],true))
    local dist = GetDistanceBetweenCoords(x,y,z,px,py,pz,true)

    if dist <= radius+0.0001 then
      if not min_dist or dist < min_dist then
        min_dist = dist
        min_k = k
      end
    end
  end

  if min_k then
    return true,min_k
  end

  return false,""
end

-- return ok,x,y,z
function tvRP.getAnyOwnedVehiclePosition()
  for k,v in pairs(vehicles) do
    if IsEntityAVehicle(v[2]) then
      local x,y,z = table.unpack(GetEntityCoords(v[2],true))
      return true,x,y,z
    end
  end

  return false,0,0,0
end

-- return x,y,z
function tvRP.getOwnedVehiclePosition(name)
  local vehicle = vehicles[name]
  local x,y,z = 0,0,0

  if vehicle then
    x,y,z = table.unpack(GetEntityCoords(vehicle[2],true))
  end

  return x,y,z
end

-- return owned vehicle handle or nil if not found
function tvRP.getOwnedVehicleHandle(name)
  local vehicle = vehicles[name]
  if vehicle then
    return vehicle[2]
  end
end

function tvRP.isOwnedVehicleOut(name)
  local vehicle = vehicles[name]
  if vehicle then
    return vehicle[1],VehToNet(vehicle[2])
  end
end

-- eject the ped from the vehicle
function tvRP.ejectVehicle()
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    local veh = GetVehiclePedIsIn(ped,false)
    TaskLeaveVehicle(ped, veh, 4160)
  end
end

function tvRP.isInVehicle()
  local ped = GetPlayerPed(-1)
  return IsPedSittingInAnyVehicle(ped) 
end

-- vehicle commands
function tvRP.vc_openDoor(name, door_index)
  local vehicle = vehicles[name]
  if vehicle then
    SetVehicleDoorOpen(vehicle[2],door_index,0,false)
  end
end

function tvRP.vc_closeDoor(name, door_index)
  local vehicle = vehicles[name]
  if vehicle then
    SetVehicleDoorShut(vehicle[2],door_index)
  end
end

function tvRP.vc_detachTrailer(name)
  local vehicle = vehicles[name]
  if vehicle then
    DetachVehicleFromTrailer(vehicle[2])
  end
end

function tvRP.vc_detachTowTruck(name)
  local vehicle = vehicles[name]
  if vehicle then
    local ent = GetEntityAttachedToTowTruck(vehicle[2])
    if IsEntityAVehicle(ent) then
      DetachVehicleFromTowTruck(vehicle[2],ent)
    end
  end
end

function tvRP.vc_detachCargobob(name)
  local vehicle = vehicles[name]
  if vehicle then
    local ent = GetVehicleAttachedToCargobob(vehicle[2])
    if IsEntityAVehicle(ent) then
      DetachVehicleFromCargobob(vehicle[2],ent)
    end
  end
end

function tvRP.vc_toggleEngine(name)
  local vehicle = vehicles[name]
  if vehicle then
    local running = Citizen.InvokeNative(0xAE31E7DF9B5B132E,vehicle[2]) -- GetIsVehicleEngineRunning
    SetVehicleEngineOn(vehicle[2],not running,true,true)
    if running then
      SetVehicleUndriveable(vehicle[2],true)
    else
      SetVehicleUndriveable(vehicle[2],false)
    end
  end
end

function tvRP.vc_toggleLock(name)
  local vehicle = vehicles[name]
  if vehicle then
    local veh = vehicle[2]
    local locked = GetVehicleDoorLockStatus(veh) >= 2
    if locked then -- unlock
      SetVehicleDoorsLockedForAllPlayers(veh, false)
      SetVehicleDoorsLocked(veh,1)
      SetVehicleDoorsLockedForPlayer(veh, PlayerId(), false)
      tvRP.notify("Veículo destravado.")
      TriggerServerEvent("b2k:trySyncLockVehicle", VehToNet(veh), false)
    else -- lock
      SetVehicleDoorsLocked(veh,2)
      SetVehicleDoorsLockedForAllPlayers(veh, true)
      tvRP.notify("Veículo travado.")
      TriggerServerEvent("b2k:trySyncLockVehicle", VehToNet(veh), true)
    end
  end
end

function tvRP.checkOffSetAndHoodOpen(vehicle,sentOpenHood)
	
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 3.0, 0.5))
	local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -3.0, 0.5))
	local coordA = GetEntityCoords(GetPlayerPed(-1))
	
	if (GetDistanceBetweenCoords(coordA.x,coordA.y,coordA.z,x,y,z) < 2.0) or (GetDistanceBetweenCoords(coordA.x,coordA.y,coordA.z,x2,y2,z2) < 2.0) then
		if sentOpenHood then
			SetVehicleDoorOpen(vehicle,4,0,0)
		end
		return true,VehToNet(vehicle)
	else
		return false,-1
	end
end

RegisterNetEvent("b2k:syncLockVehicle")
AddEventHandler("b2k:syncLockVehicle", function(netIdSent,condSent)
  if NetworkDoesNetworkIdExist(netIdSent) then
    local v = NetToEnt(netIdSent)
    if DoesEntityExist(v) then
      if IsEntityAVehicle(v) then
        if condSent then
          SetVehicleDoorsLocked(v,2)
          SetVehicleDoorsLockedForAllPlayers(v, true)
        else
          SetVehicleDoorsLockedForAllPlayers(v, false)
          SetVehicleDoorsLocked(v,1)
          SetVehicleDoorsLockedForPlayer(v, PlayerId(), false)
        end
      end
    end
  end
end)

RegisterNetEvent("b2k:fixeVehicleByNetId")
AddEventHandler("b2k:fixeVehicleByNetId", function(netIdSent)
  if NetworkDoesNetworkIdExist(netIdSent) then
  	local v = NetToEnt(netIdSent)
  	if DoesEntityExist(v) then
  		if IsEntityAVehicle(v) then
  			SetVehicleFixed(v)
  		end
  	end
  end
end)

RegisterNetEvent("b2k:fixEngineVehicleByNetId")
AddEventHandler("b2k:fixEngineVehicleByNetId", function(netIdSent)
  if NetworkDoesNetworkIdExist(netIdSent) then
    local v = NetToEnt(netIdSent)
    if DoesEntityExist(v) then
      if IsEntityAVehicle(v) then
        SetVehicleEngineHealth(v, 550.0)
        SetVehicleBodyHealth(v, 550.0)
      end
    end
  end
end)

function mechanicGetNearestVehicle(radius)
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  local ped = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ped) then
    return GetVehiclePedIsIn(ped, true)
  else
    -- flags used:
    --- 8192: boat
    --- 4096: helicos
    --- 4,2,1: cars (with police)

    local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 8192+4096+4+2+1)  -- boats, helicos
    if not IsEntityAVehicle(veh) then veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, radius+0.0001, 0, 4+2+1) end -- cars
    return veh
  end
end

function DrawText3DTest(x,y,z, text)
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

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    local vehicle = mechanicGetNearestVehicle(5)
    if vehicle then
      local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 3.0, 0.5))
      local x2,y2,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -3.0, 0.5))
      local coordA = GetEntityCoords(GetPlayerPed(-1))

      if GetDistanceBetweenCoords(coordA.x,coordA.y,coordA.z,x,y,z) < 2.0 then
        DrawText3DTest(x,y,z, "Frente")
      end
      if GetDistanceBetweenCoords(coordA.x,coordA.y,coordA.z,x2,y2,z2) < 2.0 then
        DrawText3DTest(x2,y2,z2, "Trás")
      end
    end
  end
end)