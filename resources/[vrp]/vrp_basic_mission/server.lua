
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp_basic_mission", "cfg/missions")

-- load global and local languages
local glang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})
local lang = Lang.new(module("vrp_basic_mission", "cfg/lang/"..cfg.lang) or {})

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_basic_mission")

--function task_mission()

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Police
    for k,v in pairs(cfg.police) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          if math.random(1,v.chance+1) == 1 then -- chance check
            -- build mission
            local mdata = {}
            mdata.name = v.title
            mdata.steps = {}

            -- build steps
            for i=1,v.steps do
              local step = {
                text = ""..v.title.."<br /> Recompensa: R$ <font style='color:rgb(0,255,0);'>"..v.reward.."</font>",
                onenter = function(player, area)
  				  --vRPclient.notify(player,{"Aguarde alguns segundos."})
                    --SetTimeout(5000, function()
                      vRP.nextMissionStep({player})

                      -- last step
                      if i == v.steps then
                        vRP.giveMoney({user_id,v.reward})
                        vRPclient.notify(player,{glang.money.received({v.reward})})
  					  --TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você recebeu R$" .. v.reward)
  					  vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você recebeu R$" .. v.reward, 10})
                      end
                    --end)
                end,
                position = v.positions[math.random(1,#v.positions)]
              }

              table.insert(mdata.steps, step)
            end

            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Mecanico
    for k,v in pairs(cfg.repair) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          if math.random(1,v.chance+1) == 1 then -- chance check
            -- build mission
            local mdata = {}
            mdata.name = v.title
            mdata.steps = {}

            -- build steps
            for i=1,v.steps do
              local step = {
  			  text = ""..v.title.."<br /> Recompensa: R$ <font style='color:rgb(0,255,0);'>"..v.reward.."</font>",
                onenter = function(player, area)
                  if vRP.tryGetInventoryItem({user_id,"repairkit",1,true}) then
                    vRPclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
                    SetTimeout(15000, function()
                      vRP.nextMissionStep({player})
  					vRPclient.stopAnim(player,{false})
  					
                      -- last step
                      if i == v.steps then
                        vRP.giveMoney({user_id,v.reward})
                        vRPclient.notify(player,{glang.money.received({v.reward})})
  					  --TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você recebeu R$" .. v.reward)
  					  vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você recebeu R$" .. v.reward, 10})
                      end
                    end)
                  end
                end,
                position = v.positions[math.random(1,#v.positions)]
              }

              table.insert(mdata.steps, step)
            end

            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Bombeiros
    for k,v in pairs(cfg.emergency) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          if math.random(1,v.chance+1) == 1 then -- chance check
            -- build mission
            local mdata = {}
            mdata.name = v.title
            mdata.steps = {}

            -- build steps
            for i=1,v.steps do
              local step = {
  			  text = ""..v.title.."<br /> Recompensa: R$ <font style='color:rgb(0,255,0);'>"..v.reward.."</font>",
                onenter = function(player, area)
                  if vRP.tryGetInventoryItem({user_id,"medkit",1,true}) then
  				  vRPclient.notify(player,{"Paciente vindo..."})
                    --SetTimeout(15000, function()
                      vRP.nextMissionStep({player})
                      vRPclient.stopAnim(player,{false})

                      -- last step
                      if i == v.steps then
                        vRP.giveMoney({user_id,v.reward})
                        vRPclient.notify(player,{glang.money.received({v.reward})})
  					  --TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você recebeu R$" .. v.reward)
  					  vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você recebeu R$" .. v.reward, 10})
  					else
  					  vRPclient.notify(player,{"Ele está dentro! Leve-o para o próximo hospital!"})
                      end
                    --end)
                  end
                end,
                position = v.positions[math.random(1,#v.positions)]
              }
              table.insert(mdata.steps, step)
            end

            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Vendedor de Drogas
    for k,v in pairs(cfg.drugseller) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          -- build mission
          local mdata = {}
          mdata.name = "Tráfico de Drogas"

          -- generate items
          local todo = 0
          local drugseller_items = {}
          for idname,data in pairs(v.items) do
            local amount = math.random(data[1],data[2]+1)
            if amount > 0 then
              drugseller_items[idname] = amount
              todo = todo+1
            end
          end

          local step = {
            text = "",
            onenter = function(player, area)
              for idname,amount in pairs(drugseller_items) do
                if amount > 0 then -- check if not done
                  if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                    local reward = v.items[idname][3]*amount
                    --vRP.giveMoney({user_id,reward})
  				  vRP.giveInventoryItem({user_id,"dirty_money",reward,true})
  				  
                    --vRPclient.notify(player,{glang.money.received({reward})})
                    todo = todo-1
                    drugseller_items[idname] = 0
                    if todo == 0 then -- all received, finish mission
                      vRP.nextMissionStep({player})
  					--TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você deixou os viciados felizes")
  					vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você deixou os viciados felizes", 10})
                    end
                  end
                end
              end
            end,
            position = v.positions[math.random(1,#v.positions)]
          }

          -- mission display
          for idname,amount in pairs(drugseller_items) do
            local name = vRP.getItemName({idname})
  		  -- text = ""..v.title.."<br /> Recompensa: R$ <font style='color:rgb(0,255,0);'>"..v.reward.."</font>",
            -- step.text = step.text..lang.drugseller.item({name,amount}).."<br />"
  		  step.text = step.text.."<br /> "..name..": <font style='color:rgb(0,255,0);'>"..amount.."</font><br />"
          end

          mdata.steps = {step}

          if todo > 0 then
            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Delivery
    for k,v in pairs(cfg.delivery) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          -- build mission
          local mdata = {}
          mdata.name = "Delivery"

          -- generate items
          local todo = 0
          local delivery_items = {}
          for idname,data in pairs(v.items) do
            local amount = math.random(data[1],data[2]+1)
            if amount > 0 then
              delivery_items[idname] = amount
              todo = todo+1
            end
          end

          local step = {
            text = "",
            onenter = function(player, area)
              for idname,amount in pairs(delivery_items) do
                if amount > 0 then -- check if not done
                  if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                    local reward = v.items[idname][3]*amount
                    vRP.giveMoney({user_id,reward})
  				  
                    vRPclient.notify(player,{glang.money.received({reward})})
                    todo = todo-1
                    delivery_items[idname] = 0
                    if todo == 0 then -- all received, finish mission
                      vRP.nextMissionStep({player})
  					--TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você matou a fome de algumas pessoas.")
  					vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você matou a fome de algumas pessoas.", 10})
                    end
                  end
                end
              end
            end,
            position = v.positions[math.random(1,#v.positions)]
          }

          -- mission display
          for idname,amount in pairs(delivery_items) do
            local name = vRP.getItemName({idname})
  		  -- text = ""..v.title.."<br /> Recompensa: R$ <font style='color:rgb(0,255,0);'>"..v.reward.."</font>",
            -- step.text = step.text..lang.drugseller.item({name,amount}).."<br />"
  		  step.text = step.text.."<br /> "..name..": <font style='color:rgb(0,255,0);'>"..amount.."</font><br />"
          end

          mdata.steps = {step}

          if todo > 0 then
            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- hacker
    for k,v in pairs(cfg.hacker) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          -- build mission
          local mdata = {}
          mdata.name = "Hacker"

          -- generate items
          local todo = 0
          local hacker_items = {}
          for idname,data in pairs(v.items) do
            local amount = math.random(data[1],data[2]+1)
            if amount > 0 then
              hacker_items[idname] = amount
              todo = todo+1
            end
          end

          local step = {
            text = "",
            onenter = function(player, area)
              for idname,amount in pairs(hacker_items) do
                if amount > 0 then -- check if not done
                  if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                    local reward = v.items[idname][3]*amount
                    --vRP.giveMoney({user_id,reward})
  				  vRP.giveInventoryItem({user_id,"dirty_money",reward,true})
                    --vRPclient.notify(player,{glang.money.received({reward})})
                    todo = todo-1
                    hacker_items[idname] = 0
                    if todo == 0 then -- all received, finish mission
                      vRP.nextMissionStep({player})
  					--TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Você ainda é um Hacker virgem.")
  					vRPclient.midsizedMessage(player,{21,"Missão Completada", "Você ainda é um Hacker virgem.", 10})
                    end
                  end
                end
              end
            end,
            position = v.positions[math.random(1,#v.positions)]
          }

          -- mission display
          for idname,amount in pairs(hacker_items) do
            local name = vRP.getItemName({idname})
            --step.text = step.text..lang.hacker.item({name,amount}).."<br />"
  		  step.text = step.text.."<br /> "..name..": <font style='color:rgb(0,255,0);'>"..amount.."</font><br />"
          end

          mdata.steps = {step}

          if todo > 0 then
            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- adv
    for k,v in pairs(cfg.advogados) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
        local user_id = w
        local player = vRP.getUserSource({user_id})
        if not vRP.hasMission({player}) then
          -- build mission
          local mdata = {}
          mdata.name = "Advogados"

          -- generate items
          local todo = 0
          local adv_items = {}
          for idname,data in pairs(v.items) do
            local amount = math.random(data[1],data[2]+1)
            if amount > 0 then
              adv_items[idname] = amount
              todo = todo+1
            end
          end

          local step = {
            text = "",
            onenter = function(player, area)
              for idname,amount in pairs(adv_items) do
                if amount > 0 then -- check if not done
                  if vRP.tryGetInventoryItem({user_id,idname,amount,true}) then
                    local reward = v.items[idname][3]*amount
                    vRP.giveMoney({user_id,reward})
                    vRPclient.notify(player,{glang.money.received({reward})})
                    todo = todo-1
                    adv_items[idname] = 0
                    if todo == 0 then -- all received, finish mission
                      vRP.nextMissionStep({player})
  					--TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "Continue sendo um Ótimo Advogado(a).")
  					vRPclient.midsizedMessage(player,{21,"Missão Completada", "Continue sendo um Ótimo Advogado(a).", 10})
                    end
                  end
                end
              end
            end,
            position = v.positions[math.random(1,#v.positions)]
          }

          -- mission display
          for idname,amount in pairs(adv_items) do
            local name = vRP.getItemName({idname})
            --step.text = step.text..lang.hacker.item({name,amount}).."<br />"
  		  step.text = step.text.."<br /> "..name..": <font style='color:rgb(0,255,0);'>"..amount.."</font><br />"
          end

          mdata.steps = {step}

          if todo > 0 then
            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(100000) -- start 

  while true do
    Citizen.Wait(60000)
    -- Mafias
    for k,v in pairs(cfg.gunrunner) do -- each repair perm def
      -- add missions to users
      local users = vRP.getUsersByPermission({k})
      for l,w in pairs(users) do
      local user_id = w
      local player = vRP.getUserSource({user_id})
      local pistol = math.random(-1,4)
  	  local shotgun = math.random(-2,8)
  	  local smg = math.random(-6,10)
  	  local ak47 = math.random(-12,12)
  	  	  
        if not vRP.hasMission({player}) then
          if math.random(1,v.chance+1) == 1 then -- chance check
            -- build mission
            local mdata = {}
            mdata.name = v.title
            mdata.steps = {}

            -- build steps
            for i=1,v.steps do
              local step = {
                text = "Carregamento de Armas",
                onenter = function(player, area)
        				if pistol > 0 then
        			      vRP.giveInventoryItem({user_id,"pistol_parts",pistol,true})
        			      vRP.giveInventoryItem({user_id,"wammo|WEAPON_PISTOL",math.random(5,10)*pistol,true})
        				end
        				if shotgun > 0 then
        			      vRP.giveInventoryItem({user_id,"shotgun_parts",shotgun,true})
        			      vRP.giveInventoryItem({user_id,"wammo|WEAPON_PUMPSHOTGUN",math.random(3,15)*shotgun,true})
        				end
        				if smg > 0 then
        			      vRP.giveInventoryItem({user_id,"smg_parts",smg,true})
        			      vRP.giveInventoryItem({user_id,"wammo|WEAPON_SMG",math.random(5,20)*smg,true})
        				end
        				if ak47 > 0 then
        			      vRP.giveInventoryItem({user_id,"ak47_parts",ak47,true})
        			      vRP.giveInventoryItem({user_id,"wammo|WEAPON_ASSAULTRIFLE",math.random(5,25)*ak47,true})
        				end

        				--TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "~w~Se você teve sorte, recebeu ~r~Partes de Armas ~w~e ~r~Munições~w~.")
        				vRPclient.midsizedMessage(player,{21,"Missão Completada", "~w~Se você teve sorte, recebeu ~r~Partes de Armas ~w~e ~r~Munições~w~.", 10})
                vRP.nextMissionStep({player})
              end,
              position = v.positions[math.random(1,#v.positions)]
              }

              table.insert(mdata.steps, step)
            end

            vRP.startMission({player,mdata})
          end
        end
      end
    end
  end
end)
  --[[ Cruz Vermelha
  for k,v in pairs(cfg.cruzvermelha) do -- each repair perm def
    -- add missions to users
    local users = vRP.getUsersByPermission({k})
    for l,w in pairs(users) do
      local user_id = w
      local player = vRP.getUserSource({user_id})
      local coins = math.random(1,3)
          
      if not vRP.hasMission({player}) then
        if math.random(1,v.chance+1) == 1 then -- chance check
          -- build mission
          local mdata = {}
          mdata.name = v.title
          mdata.steps = {}

          -- build steps
          for i=1,v.steps do
            local step = {
              text = "Entrega de Suprimentos",
              onenter = function(player, area)
              if vRP.tryGetInventoryItem({user_id,"suprimentos",1,true}) then
                if coins > 0 then
                    vRP.giveInventoryItem({user_id,"b2kcoin",coins,true})
                end
                --TriggerClientEvent("b2k:missaoCompletada", player, 10, "~g~Missão Completada", "~w~Se você teve sorte, recebeu ~r~Partes de Armas ~w~e ~r~Munições~w~.")
                vRPclient.midsizedMessage(player,{21,"Missão Completada", "~w~Você entregou ~g~Suprimentos~w~ aos necessitados.", 10})
                vRP.nextMissionStep({player})
              end
            end,
            position = v.positions[math.random(1,#v.positions)]
            }

            table.insert(mdata.steps, step)
          end

          vRP.startMission({player,mdata})
        end
      end
    end
  end]]

  --SetTimeout(60000,task_mission)
--end
--task_mission()