-- api

function tvRP.getArmour()
  return GetPedArmour(GetPlayerPed(-1))
end

function tvRP.setArmour(armour)
  SetPedArmour(GetPlayerPed(-1),armour)
end

function tvRP.varyHealth(variation)
  local ped = GetPlayerPed(-1)

  local n = math.floor(GetEntityHealth(ped)+variation)
  SetEntityHealth(ped,n)
end

function tvRP.getHealth()
  return GetEntityHealth(GetPlayerPed(-1))
end

function tvRP.setHealth(health)
  local n = math.floor(health)
  SetEntityHealth(GetPlayerPed(-1),n)
end

function tvRP.setFriendlyFire(flag)
  NetworkSetFriendlyFireOption(flag)
  SetCanAttackFriendly(GetPlayerPed(-1), flag, flag)
end

function tvRP.setPolice(flag)
  local player = PlayerId()
  SetPoliceIgnorePlayer(player, not flag)
  SetDispatchCopsForPlayer(player, flag)
end

-- impact thirst and hunger when the player is running (every 5 seconds)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5000)

    if IsPlayerPlaying(PlayerId()) then
      local ped = GetPlayerPed(-1)

      -- variations for one minute
      local vthirst = 0
      local vhunger = 0

      -- on foot, increase thirst/hunger in function of velocity
      if IsPedOnFoot(ped) and not tvRP.isNoclip() then
        local factor = math.min(tvRP.getSpeed(),10)

        vthirst = vthirst+1*factor
        vhunger = vhunger+0.5*factor
      end

      -- in melee combat, increase
      if IsPedInMeleeCombat(ped) then
        vthirst = vthirst+10
        vhunger = vhunger+5
      end

      -- injured, hurt, increase
      if IsPedHurt(ped) or IsPedInjured(ped) then
        vthirst = vthirst+2
        vhunger = vhunger+1
      end

      -- do variation
      if vthirst ~= 0 then
        vRPserver.varyThirst({vthirst/12.0})
      end

      if vhunger ~= 0 then
        vRPserver.varyHunger({vhunger/12.0})
      end
    end
  end
end)

-- COMA SYSTEM

local playedDeadSound = false
local in_coma = false
local coma_left = cfg.coma_duration*60

local in_uti = false
local uti_left = cfg.coma_duration*30

Citizen.CreateThread(function() -- coma thread
  while true do
    Citizen.Wait(0)
    local ped = GetPlayerPed(-1)
    
    local health = GetEntityHealth(ped)
    if health <= cfg.coma_threshold and coma_left > 0 then
      if not in_coma then -- go to coma state
        if IsEntityDead(ped) then -- if dead, resurrect
          local x,y,z = tvRP.getPosition()
          NetworkResurrectLocalPlayer(x, y, z, true, true, false)
          Citizen.Wait(0)
        end

        -- coma state
        in_coma = true
        vRPserver.updateHealth({cfg.coma_threshold}) -- force health update
        SetEntityHealth(ped, cfg.coma_threshold)
        SetEntityInvincible(ped,true)
        tvRP.playScreenEffect(cfg.coma_effect,-1)
        tvRP.ejectVehicle()
        tvRP.setRagdoll(true)
    		if not playedDeadSound then
    			playedDeadSound = true
    			ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 2.0)
    			tvRP.playSound("ScreenFlash", "MissionFailedSounds")
    			tvRP.playSound("Bed", "WastedSounds")
    		end
      else -- in coma
        -- maintain life
        if health < cfg.coma_threshold then 
          SetEntityHealth(ped, cfg.coma_threshold) 
        end
      end
    else
      if in_coma then -- get out of coma state
        in_coma = false
        playedDeadSound = false
        SetEntityInvincible(ped,false)
        tvRP.setRagdoll(false)
        tvRP.stopScreenEffect(cfg.coma_effect)

        if coma_left <= 0 then -- get out of coma by death
          SetEntityHealth(ped, 0)
        end

        SetTimeout(5000, function()  -- able to be in coma again after coma death after 5 seconds
          coma_left = cfg.coma_duration*60
        end)
      end
    end
  end
end)

function tvRP.isInComa()
  return in_coma
end

function tvRP.isInUTI()
  return in_uti
end

-- kill the player if in coma
function tvRP.killComa()
  if in_coma then
    coma_left = 0
  end
end

function tvRP.resetComa()
  coma_left = cfg.coma_duration*60
end

local uti_spawns_samu = {
  { x = 347.02978515625, y = -590.48156738281, z = 43.105575561523, h = 340.13 },
  { x = 350.82125854492, y = -591.70739746094, z = 43.105575561523, h = 340.13 },
  { x = 354.31979370117, y = -592.55749511719, z = 43.105472564697, h = 340.13 },
  { x = 357.35516357422, y = -594.44647216797, z = 43.105575561523, h = 340.13 }
}

local uti_spawns_cura = {
  { x = 334.00738525391, y = -578.41986083984, z = 43.009105682373, h = 258.84 },
  { x = 344.57211303711, y = -580.98400878906, z = 43.016323089600, h = 243.64 },
  { x = 349.53915405273, y = -583.35870361328, z = 43.105575561523, h = 155.17 },
  { x = 360.51745605469, y = -587.01220703125, z = 43.016326904297, h = 159.32 },
  { x = 356.69046020508, y = -586.08862304688, z = 43.105575561523, h = 168.64 },
  { x = 353.46148681641, y = -584.73822021484, z = 43.104038238525, h = 159.32 },
  { x = 349.50308227539, y = -583.33483886719, z = 43.105583190918, h = 159.32 },
  { x = 326.84002685547, y = -576.35711669922, z = 43.239387512207, h = 159.32 }
}

function tvRP.teleportUTI(isSamu)
  Citizen.CreateThread(function()
    in_uti = true
    DoScreenFadeOut(500)
    while IsScreenFadingOut() do Citizen.Wait(0) end

    Citizen.Wait(500)

    FreezeEntityPosition(GetPlayerPed(-1), true)

    local selectedMaca = uti_spawns_cura[math.random(1, #uti_spawns_cura)]
    if isSamu then selectedMaca = uti_spawns_samu[math.random(1, #uti_spawns_samu)] end

    tvRP.teleport(selectedMaca.x,selectedMaca.y,selectedMaca.z)

    SetEntityHeading(GetPlayerPed(-1), selectedMaca.h) -- player
    --SetFollowPedCamViewMode(4)
    
    tvRP.playAnim(false,{{"dead","dead_a",1}},true) -- anim
    Citizen.Wait(1000)

    ShutdownLoadingScreen()
    DoScreenFadeIn(2000)
    while IsScreenFadingIn() do Citizen.Wait(0) end

    local pedHealth = 110
    SetEntityHealth(GetPlayerPed(-1), pedHealth)

    if isSamu then
      Citizen.Wait(5*60*1000) -- samu protection
    end

    if in_uti then
      tvRP.tratamentoUTI()
    end
  end)
end

function tvRP.tratamentoUTI()
  Citizen.CreateThread(function()
    in_uti = false
    local pedHealth = 110
    SetEntityHealth(GetPlayerPed(-1), pedHealth)

    repeat
      pedHealth = pedHealth + 1
      SetEntityHealth(GetPlayerPed(-1), pedHealth)
      Citizen.Wait(1000)
    until GetEntityHealth(GetPlayerPed(-1)) == 400

    Citizen.Wait(3000)

    DoScreenFadeOut(5000)
    while IsScreenFadingOut() do Citizen.Wait(0) end

    FreezeEntityPosition(GetPlayerPed(-1), true)
    tvRP.teleport(330.60842895508,-584.43310546875,43.317329406738)
    tvRP.stopAnim(true) -- upper
    tvRP.stopAnim(false) -- full

    FreezeEntityPosition(GetPlayerPed(-1), true)

    local timewait = 0
    repeat
      timewait = timewait + 1
      SetEntityHealth(GetPlayerPed(-1), 5)
      Citizen.Wait(500)
      SetEntityHealth(GetPlayerPed(-1), 400)
      Citizen.Wait(2000)
    until timewait >= 3

    FreezeEntityPosition(GetPlayerPed(-1), false)
    tvRP.teleport(330.60842895508,-584.43310546875,43.317329406738)

    ShutdownLoadingScreen()
    DoScreenFadeIn(1000)
    while IsScreenFadingIn() do Citizen.Wait(0) end
  end)
end


Citizen.CreateThread(function() -- coma decrease thread
  while true do 
    Citizen.Wait(1000)
    if in_coma then
      coma_left = coma_left-1
    end
    if in_uti then
      uti_left = uti_left-1
    end
  end
end)

Citizen.CreateThread(function() -- disable health regen, conflicts with coma system
  while true do
    Citizen.Wait(100)
    -- prevent health regen
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0)
  end
end)

function drawTxt(x,y, scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function() -- coma countdown message
    while true do 
  		Citizen.Wait(0)
  		if in_coma then
  			function Initialize(scaleform)
  				local scaleform = RequestScaleformMovie(scaleform)

  				while not HasScaleformMovieLoaded(scaleform) do
  					Citizen.Wait(0)
  				end
  				PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
  				PushScaleformMovieFunctionParameterString("~r~SE FUDEU")
  				PushScaleformMovieFunctionParameterString("Você está em coma.")
  				PopScaleformMovieFunctionVoid()
  				return scaleform
  			end
  			scaleformWasted = Initialize("mp_big_message_freemode")
  			drawTxt(0.38, 0.9, 0.5, "~w~Respawn em: ~r~" .. coma_left .. " ~w~segundos.", 255,255,255,255)
  			DrawScaleformMovieFullscreen(scaleformWasted, 255, 255, 255, 255, 0)
  		end
      if in_uti then
        drawTxt(0.25, 0.8, 0.5, "~w~Você está internado na ~r~UTI~w~, aguarde o tratamento finalizar.", 255,255,255,255)
      end
    end
end)

-- Samu Drag System
local other = nil
local drag = false
local playerStillDragged = false

RegisterNetEvent("dr:samu:drag")
AddEventHandler("dr:samu:drag", function(pl)
    other = pl
    drag = not drag
end)

RegisterNetEvent("dr:samu:undrag")
AddEventHandler("dr:samu:undrag", function()
    drag = false
end)

Citizen.CreateThread(function()
    -- request anim dict
    RequestAnimDict("anim@heists@box_carry@")
    local i = 0
    while not HasAnimDictLoaded("anim@heists@box_carry@") and i < 1000 do -- max time, 10 seconds
        Citizen.Wait(10)
        RequestAnimDict("anim@heists@box_carry@")
        i = i+1
    end

    while true do
        if drag and other ~= nil then
            local ped = GetPlayerPed(GetPlayerFromServerId(other))
            local myped = PlayerPedId()
            AttachEntityToEntity(myped, ped, 4103, 11816, 0.44, 1.04, 0.0, -270.0, 0.0, 0.0, false, false, false, false, 2, true)
            --TaskPlayAnim(myped, "anim@heists@box_carry@", "anim@heists@box_carry@", 1.0, 1.0, -1, 1,  1, 0, 0, 0)
            playerStillDragged = true
        else
            if(playerStillDragged) then
                DetachEntity(PlayerPedId(), true, false)
                playerStillDragged = false
            end
        end
        Citizen.Wait(0)
    end
end)
