local cfg = module("cfg/survival")
local Tunnel = module("vrp", "lib/Tunnel")
local lang = vRP.lang

HUDclient = Tunnel.getInterface("vrp_hud", "vrp_hud")
-- api

function vRP.getHunger(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.hunger
  end

  return 0
end

function vRP.getThirst(user_id)
  local data = vRP.getUserDataTable(user_id)
  if data then
    return data.thirst
  end

  return 0
end

function vRP.setHunger(user_id,value)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.hunger = value
    if data.hunger < 0 then data.hunger = 0
    elseif data.hunger > 100 then data.hunger = 100 
    end

    -- update bar
    local source = vRP.getUserSource(user_id)
    HUDclient.setHunger(source,{data.hunger})
    --[[vRPclient.setProgressBarValue(source, {"vRP:hunger",data.hunger})
    if data.hunger >= 100 then
      vRPclient.setProgressBarText(source,{"vRP:hunger",lang.survival.starving()})
    else
      vRPclient.setProgressBarText(source,{"vRP:hunger",""})
    end]]
  end
end

function vRP.setThirst(user_id,value)
  local data = vRP.getUserDataTable(user_id)
  if data then
    data.thirst = value
    if data.thirst < 0 then data.thirst = 0
    elseif data.thirst > 100 then data.thirst = 100 
    end

    -- update bar
    local source = vRP.getUserSource(user_id)
    HUDclient.setThirst(source,{data.thirst})
    --[[vRPclient.setProgressBarValue(source, {"vRP:thirst",data.thirst})
    if data.thirst >= 100 then
      vRPclient.setProgressBarText(source,{"vRP:thirst",lang.survival.thirsty()})
    else
      vRPclient.setProgressBarText(source,{"vRP:thirst",""})
    end]]
  end
end

function vRP.varyHunger(user_id, variation)
  local data = vRP.getUserDataTable(user_id)
  if data then
    local was_starving = data.hunger >= 100
    data.hunger = data.hunger + variation
    local is_starving = data.hunger >= 100

    -- apply overflow as damage
    local overflow = data.hunger-100
    if overflow > 0 then
      vRPclient.varyHealth(vRP.getUserSource(user_id),{-overflow*cfg.overflow_damage_factor})
    end

    if data.hunger < 0 then data.hunger = 0
    elseif data.hunger > 100 then data.hunger = 100 
    end

    -- set progress bar data
    local source = vRP.getUserSource(user_id)
    HUDclient.setHunger(source,{data.hunger})
    --[[vRPclient.setProgressBarValue(source,{"vRP:hunger",data.hunger})
    if was_starving and not is_starving then
      vRPclient.setProgressBarText(source,{"vRP:hunger",""})
    elseif not was_starving and is_starving then
      vRPclient.setProgressBarText(source,{"vRP:hunger",lang.survival.starving()})
    end]]
  end
end

function vRP.varyThirst(user_id, variation)
  local data = vRP.getUserDataTable(user_id)
  if data then
    local was_thirsty = data.thirst >= 100
    data.thirst = data.thirst + variation
    local is_thirsty = data.thirst >= 100

    -- apply overflow as damage
    local overflow = data.thirst-100
    if overflow > 0 then
      vRPclient.varyHealth(vRP.getUserSource(user_id),{-overflow*cfg.overflow_damage_factor})
    end

    if data.thirst < 0 then data.thirst = 0
    elseif data.thirst > 100 then data.thirst = 100 
    end

    -- set progress bar data
    local source = vRP.getUserSource(user_id)
    HUDclient.setThirst(source,{data.thirst})
    --[[vRPclient.setProgressBarValue(source,{"vRP:thirst",data.thirst})
    if was_thirsty and not is_thirsty then
      vRPclient.setProgressBarText(source,{"vRP:thirst",""})
    elseif not was_thirsty and is_thirsty then
      vRPclient.setProgressBarText(source,{"vRP:thirst",lang.survival.thirsty()})
    end]]
  end
end

-- tunnel api (expose some functions to clients)

function tvRP.varyHunger(variation)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.varyHunger(user_id,variation)
  end
end

function tvRP.varyThirst(variation)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.varyThirst(user_id,variation)
  end
end

-- tasks

-- hunger/thirst increase
function task_update()
  for k,v in pairs(vRP.users) do
    vRP.varyHunger(v,cfg.hunger_per_minute)
    vRP.varyThirst(v,cfg.thirst_per_minute)
  end

  SetTimeout(60000,task_update)
end
task_update()

-- handlers

-- init values
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
  local data = vRP.getUserDataTable(user_id)
  if data.hunger == nil then
    data.hunger = 0
  end
  if data.thirst == nil then
    data.thirst = 0
  end
end)

-- add survival progress bars on spawn
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  local data = vRP.getUserDataTable(user_id)

  -- disable police
  vRPclient.setPolice(source,{cfg.police})
  -- set friendly fire
  vRPclient.setFriendlyFire(source,{cfg.pvp})

  --vRPclient.setProgressBar(source,{"vRP:hunger","minimap2",htxt,249,162,0,0})
  --vRPclient.setProgressBar(source,{"vRP:thirst","minimap2",ttxt,79,86,194,0})
  if data == nil then
    data = { }
  end
  if data.hunger == nil then
    data.hunger = 0
  end
  if data.thirst == nil then
    data.thirst = 0
  end
  
  vRP.setHunger(user_id, data.hunger)
  vRP.setThirst(user_id, data.thirst)
  
  --vRPclient.setProgressBar(source,{"vRP:life","minimap","",34,177,76,0})
  --vRPclient.setProgressBar(source,{"vRP:armor","minimap","",200,200,200,0})
  
end)