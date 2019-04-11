local appid = '' -- Make an application @ https://discordapp.com/developers/applications/ ID can be  found there.
local asset = '' -- Go to https://discordapp.com/developers/applications/APPID/rich-presence/assets OigDTEOGPI-gZ5_LbalpfYwPaTo1C3w6

-- periodic player state update

local state_ready = false
local scubaGearOn = false

AddEventHandler("playerSpawned",function() -- delay state recording
  state_ready = false
  
  removeAttachedProp()
  removeAttachedProp2()
  scubaGearOn = false
  print ("reset scuba gear")

  SetDiscordAppId(appid)
  SetDiscordRichPresenceAsset(asset)
  SetRichPresence("Carregando B2K RP 1.2...")
  
  Citizen.CreateThread(function()
    Citizen.Wait(30000)
    state_ready = true
    --SetRichPresence("discord.gg/YsDpQ5H")
    SetRichPresence(math.random(100, 250) .. " players")
  end)
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(30000)
	
    if IsPlayerPlaying(PlayerId()) and state_ready then
	
	   --SetRichPresence("discord.gg/YsDpQ5H")
	   SetRichPresence(math.random(100, 250) .. " players")
	  
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
      --vRPserver.ping({})
      vRPserver.updatePos({x,y,z})
      vRPserver.updateHealth({tvRP.getHealth()})
      vRPserver.updateArmour({tvRP.getArmour()})
      vRPserver.updateWeapons({tvRP.getWeapons()})
      vRPserver.updateCustomization({tvRP.getCustomization()})
    end
  end
end)

-- WEAPONS

-- def
local weapon_types = {
  "WEAPON_TRANQ",
  "WEAPON_KNIFE",
  "WEAPON_STUNGUN",
  "WEAPON_FLASHLIGHT",
  "WEAPON_NIGHTSTICK",

  "WEAPON_HAMMER",
  "WEAPON_CROWBAR",
  "WEAPON_HATCHET",
  "WEAPON_DAGGER",
  "WEAPON_MACHETE",
  "WEAPON_BOTTLE",

  "WEAPON_KNUCKLE",
  "WEAPON_BAT",
  "WEAPON_GOLFCLUB",  
  "WEAPON_PISTOL",
  "WEAPON_COMBATPISTOL",
  --"WEAPON_APPISTOL",
  --"WEAPON_PISTOL50",
  --"WEAPON_MICROSMG",
  "WEAPON_SMG",
  "WEAPON_ASSAULTSMG",
  "WEAPON_ASSAULTRIFLE",
  "WEAPON_CARBINERIFLE",
  --"WEAPON_ADVANCEDRIFLE",
  --"WEAPON_MG",
  --"WEAPON_COMBATMG",
  "WEAPON_PUMPSHOTGUN",
  --"WEAPON_SAWNOFFSHOTGUN",
  --"WEAPON_ASSAULTSHOTGUN",
  --"WEAPON_BULLPUPSHOTGUN",
  --"WEAPON_SNIPERRIFLE",
  --"WEAPON_HEAVYSNIPER",
  --"WEAPON_REMOTESNIPER",
  --"WEAPON_GRENADELAUNCHER",
  --"WEAPON_GRENADELAUNCHER_SMOKE",
  --"WEAPON_RPG",
  --"WEAPON_PASSENGER_ROCKET",
  --"WEAPON_AIRSTRIKE_ROCKET",
  --"WEAPON_STINGER",
  --"WEAPON_MINIGUN",
  --"WEAPON_GRENADE",
  --"WEAPON_STICKYBOMB",
  --"WEAPON_SMOKEGRENADE",
  --"WEAPON_BZGAS",
  --"WEAPON_MOLOTOV",
  --"WEAPON_FIREEXTINGUISHER",
  --"WEAPON_PETROLCAN",
  --"WEAPON_DIGISCANNER",
  --"WEAPON_BRIEFCASE",
  --"WEAPON_BRIEFCASE_02",
  --"WEAPON_BALL",
  --"WEAPON_FLARE",
  --"WEAPON_REVOLVER",
  --"WEAPON_SWITCHBLADE",
  

}

function tvRP.getWeaponTypes()
  return weapon_types
end

function tvRP.getWeapons()
  local player = GetPlayerPed(-1)

  local ammo_types = {} -- remember ammo type to not duplicate ammo amount

  local weapons = {}
  for k,v in pairs(weapon_types) do
    local hash = GetHashKey(v)
    if HasPedGotWeapon(player,hash) then
      local weapon = {}
      weapons[v] = weapon
	  
      local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74, player, hash)
      if ammo_types[atype] == nil then
        ammo_types[atype] = true
        weapon.ammo = GetAmmoInPedWeapon(player,hash)
      else
        weapon.ammo = 0
      end
    end
  end

  return weapons
end

-- replace weapons (combination of getWeapons and giveWeapons)
-- return previous weapons
function tvRP.replaceWeapons(weapons)
  local old_weapons = tvRP.getWeapons()
  tvRP.giveWeapons(weapons, true)
  return old_weapons
end

function tvRP.giveWeapons(weapons,clear_before)
  local player = GetPlayerPed(-1)

  -- give weapons to player

  if clear_before then
    RemoveAllPedWeapons(player,true)
  end

  for k,weapon in pairs(weapons) do
    local hash = GetHashKey(k)
    local ammo = weapon.ammo or 0

    GiveWeaponToPed(player, hash, ammo, false)
  end
end

--[[
function tvRP.dropWeapon()
  SetPedDropsWeapon(GetPlayerPed(-1))
end
--]]

-- PLAYER CUSTOMIZATION

-- parse part key (a ped part or a prop part)
-- return is_proppart, index
local function parse_part(key)
  if type(key) == "string" and string.sub(key,1,1) == "p" then
    return true,tonumber(string.sub(key,2))
  else
    return false,tonumber(key)
  end
end

function tvRP.getDrawables(part)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1),index)
  else
    return GetNumberOfPedDrawableVariations(GetPlayerPed(-1),index)
  end
end

function tvRP.getDrawableTextures(part,drawable)
  local isprop, index = parse_part(part)
  if isprop then
    return GetNumberOfPedPropTextureVariations(GetPlayerPed(-1),index,drawable)
  else
    return GetNumberOfPedTextureVariations(GetPlayerPed(-1),index,drawable)
  end
end

function tvRP.getCustomization()
  local ped = GetPlayerPed(-1)

  local custom = {}

  custom.modelhash = GetEntityModel(ped)

  -- ped parts
  for i=0,20 do -- index limit to 20
    custom[i] = {GetPedDrawableVariation(ped,i), GetPedTextureVariation(ped,i), GetPedPaletteVariation(ped,i)}
  end

  -- props
  for i=0,10 do -- index limit to 10
    custom["p"..i] = {GetPedPropIndex(ped,i), math.max(GetPedPropTextureIndex(ped,i),0)}
  end

  return custom
end

-- partial customization (only what is set is changed)
function tvRP.setCustomization(custom) -- indexed [drawable,texture,palette] components or props (p0...) plus .modelhash or .model
  local exit = TUNNEL_DELAYED() -- delay the return values

  Citizen.CreateThread(function() -- new thread
    if custom then
      local ped = GetPlayerPed(-1)
      local armour = 0
      local mhash = nil

      -- model
      if custom.modelhash ~= nil then
        mhash = custom.modelhash
      elseif custom.model ~= nil then
        mhash = GetHashKey(custom.model)
      end

      if mhash ~= nil then
        local i = 0
        while not HasModelLoaded(mhash) and i < 10000 do
          RequestModel(mhash)
          Citizen.Wait(10)
        end

        if HasModelLoaded(mhash) then
          -- changing player model remove weapons, so save it -- and life too
          local weapons = tvRP.getWeapons()
          local health = tvRP.getHealth()
          armour = GetPedArmour(ped)
          SetPlayerModel(PlayerId(), mhash)

          tvRP.giveWeapons(weapons,true)
          tvRP.setHealth(health)

          SetModelAsNoLongerNeeded(mhash)
        end
      end

      ped = GetPlayerPed(-1)
      SetPedMaxHealth(ped, 400) -- fix 175
      SetPedArmour(ped, armour)
	  
      -- parts
      for k,v in pairs(custom) do
        if k ~= "model" and k ~= "modelhash" then
          local isprop, index = parse_part(k)
          if isprop then
            if v[1] < 0 then
              ClearPedProp(ped,index)
            else
              SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
            end
          else
            SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
          end
        end
      end
    end

    exit({})
  end)
end

-- fix invisible players by resetting customization every minutes
--[[
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(60000)
    if state_ready then
      local custom = tvRP.getCustomization()
      custom.model = nil
      custom.modelhash = nil
      tvRP.setCustomization(custom)
    end
  end
end)
--]]

-- Scuba Gear
local attachedProp = 0
local attachedProp2 = 0
local latestScubaModel = 0

function removeAttachedProp()
	DeleteEntity(attachedProp)
	attachedProp = 0
end
function removeAttachedProp2()
	DeleteEntity(attachedProp2)
	attachedProp2 = 0
end

function attachProp(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp()
	local attachModel = GetHashKey(attachModelSent)
	local boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	SetEntityCollision(attachedProp, false, 0)
	AttachEntityToEntity(attachedProp, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

function attachProp2(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
	removeAttachedProp2()
	local attachModel = GetHashKey(attachModelSent)
	local boneNumber = boneNumberSent
	local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)
	RequestModel(attachModel)
	while not HasModelLoaded(attachModel) do
		Citizen.Wait(100)
	end
	attachedProp2 = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
	SetEntityCollision(attachedProp2, false, 0)
	AttachEntityToEntity(attachedProp2, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, 0, 2, 1)
end

RegisterNetEvent("b2k:scubaGearClear")
AddEventHandler("b2k:scubaGearClear", function()
	print("scubaGearOn Clear")
	removeAttachedProp()
	removeAttachedProp2()
	latestScubaModel = 0
	scubaGearOn = false
end)

RegisterNetEvent("b2k:scubaGear")
AddEventHandler("b2k:scubaGear", function()
	
	-- Checks current model
	if latestScubaModel ~= GetEntityModel(GetPlayerPed(-1)) then
	    latestScubaModel = GetEntityModel(GetPlayerPed(-1))
		removeAttachedProp()
		removeAttachedProp2()
		scubaGearOn = false
		print("latestScubaModel reset Changed")
	end

    scubaGearOn = not scubaGearOn
	if scubaGearOn then
	  print("scubaGearOn ONN")
	  attachProp("p_s_scuba_tank_s", 24818, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0)
	  attachProp2("p_s_scuba_mask_s", 12844, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0)
	  latestScubaModel = GetEntityModel(GetPlayerPed(-1))
	else
	  print("scubaGearOn OFF")
	  removeAttachedProp()
	  removeAttachedProp2()
	end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
    if IsPlayerPlaying(PlayerId()) and state_ready then
  		if scubaGearOn then
  			SetEnableScuba(GetPlayerPed(-1), true)
  			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 100000.00)
  			SetPedDiesInWater(GetPlayerPed(-1), false)
  		else
  			SetEnableScuba(GetPlayerPed(-1), false)
  			SetPedMaxTimeUnderwater(GetPlayerPed(-1), 10.00)
  			SetPedDiesInWater(GetPlayerPed(-1), true)
  		end
    end
  end
end)

--
local secondsToNextRagDoll = 0
local randomRagDoll = 0
local isNeymar = false

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1000)
		if secondsToNextRagDoll > 0 then
			secondsToNextRagDoll = secondsToNextRagDoll - 1
		end
	end
end)

Citizen.CreateThread(function() 
  while true do
    Citizen.Wait(1000)
    if IsPlayerPlaying(PlayerId()) and state_ready and isNeymar then
  		local isSwimming = IsPedSwimming(GetPlayerPed(-1))
  		local isUnderWater = IsPedSwimmingUnderWater(GetPlayerPed(-1))
  		
  		if isSwimming or isUnderWater then
  			randomRagDoll = 0
  		else
  			randomRagDoll = math.random(100)
  		end
  	end
  end
end)

Citizen.CreateThread(function()
  while true do
    if IsPlayerPlaying(PlayerId()) and state_ready and isNeymar then
  		Citizen.Wait(50)
  		if IsPedRagdoll(GetPlayerPed(-1)) and not tvRP.isRagdoll() then
  			SetPedToRagdoll(GetPlayerPed(-1), math.random(55), math.random(55), 3, 0, 0, 0)
  			randomRagDoll = 0
  		elseif randomRagDoll > 80 and IsPedRunning(GetPlayerPed(-1)) and secondsToNextRagDoll == 0 then
  			SetPedToRagdoll(GetPlayerPed(-1), math.random(4000), math.random(4000), 3, 0, 0, 0)
  			randomRagDoll = 0
  			secondsToNextRagDoll = 120
  		end
  	else
  		Citizen.Wait(1000)
  	end
  end
end)

RegisterNetEvent("b2k:Neymar")
AddEventHandler("b2k:Neymar", function()
  isNeymar = true
end)

local timeSetted = 0

function tvRP.midsizedMessage(color, title, info, timeSended)
	timeSetted = timeSended
	
    CreateThread(function()
        local announced = false
        local announcedout = false
        
        while true do
            Wait(0)
            midsizedmessage = RequestScaleformMovie("MIDSIZED_MESSAGE")
            if not announced then
                while not HasScaleformMovieLoaded(midsizedmessage) do
                    Wait(0)
                end
                BeginScaleformMovieMethod(midsizedmessage, "SHOW_COND_SHARD_MESSAGE")
                BeginTextCommandScaleformString("STRING")
                AddTextComponentScaleform(title)
                EndTextCommandScaleformString()
                BeginTextCommandScaleformString("STRING")
                AddTextComponentScaleform(info)
                EndTextCommandScaleformString()
                PushScaleformMovieMethodParameterInt(color)
                EndScaleformMovieMethodReturn()
                Timera = GetNetworkTime()
                PlaySoundFrontend(-1, "Deliver_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 1)
                announced = true
            end
            DrawScaleformMovieFullscreen(midsizedmessage, 255, 255, 255, 255)
            if not announcedout then
                if GetTimeDifference(GetNetworkTime(), Timera) > (timeSetted*1000) then
                    BeginScaleformMovieMethod(midsizedmessage, "SHARD_ANIM_OUT")
                    PushScaleformMovieMethodParameterInt(1)
                    PushScaleformMovieMethodParameterFloat(0.33)
                    PopScaleformMovieFunctionVoid()
                    announcedout = true
                end
            end
            if GetTimeDifference(GetNetworkTime(), Timera) > ((timeSetted+5)*1000) then
                if HasScaleformMovieLoaded(midsizedmessage) then
                    SetScaleformMovieAsNoLongerNeeded(midsizedmessage)
                    SetTimeout(100, function()
                        announced = false
                        announcedout = false
                        timeSetted = 0
                    end)
                    break
                    return
                end
            end
        end
    end)
end

local spawnLoadoutExtrasList = {   
    {0x5EF9FEC4, 0x359B7AAE},   -- Combat Pistol Flashlight
    {0x5EF9FEC4, 0xD67B4F2D},   -- Combat Pistol Extended Clip
    {0x83BF0278, 0x7BC4CDDC},   -- Carbine Rifle Flashlight
    {0x83BF0278, 0x91109691},   -- Carbine Rifle Extended Clip
    {0x83BF0278, 0xC164F53},    -- Carbine Rifle Grip
    {0x83BF0278, 0xA0D89C42},   -- Carbine Rifle Scope
}

RegisterNetEvent("b2k:equipFederal")
AddEventHandler("b2k:equipFederal",function()
	local ped = GetPlayerPed(-1)
    for k, c in pairs(spawnLoadoutExtrasList) do
        GiveWeaponComponentToPed(ped, c[1], c[2])
    end
end)