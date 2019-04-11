
-- this module define some police tools and functions
local lang = vRP.lang
local cfg = module("cfg/police")

-- police records

-- insert a police record for a specific user
--- line: text for one line (can be html)
function vRP.insertPoliceRecord(user_id, line)
  if user_id ~= nil then
    vRP.getUData(user_id, "vRP:police_records", function(data)
      local records = data..line.."<br />"
      vRP.setUData(user_id, "vRP:police_records", records)
    end)
  end
end

-- Hotkey Open Police PC 1/2
function vRP.openPolicePC(source)
  vRP.buildMenu("police_pc", {player = source}, function(menudata)
    menudata.name = "Police PC"
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    vRP.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police PC 2/2
function tvRP.openPolicePC()
  vRP.openPolicePC(source)
end

-- Hotkey Open Police Menu 1/2
function vRP.openPoliceMenu(source)
  vRP.buildMenu("police", {player = source}, function(menudata)
    menudata.name = lang.police.title()
    menudata.css = {top="75px",header_color="rgba(0,125,255,0.75)"}
    vRP.openMenu(source,menudata)
  end)
end

-- Hotkey Open Police Menu 2/2
function tvRP.openPoliceMenu()
  vRP.openPoliceMenu(source)
end

-- police PC

local menu_pc = {name=lang.police.pc.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

-- search identity by registration
local function ch_searchreg(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.getUserIdentity(user_id, function(identity)
          if identity then
            -- display identity and business
            local nome = identity.nome
            local sobrenome = identity.sobrenome
            local age = identity.age
            local phone = identity.phone
            local registration = identity.registration
            local bname = ""
            local bcapital = 0
            local home = ""
            local number = ""

            vRP.getUserBusiness(user_id, function(business)
              if business then
                bname = business.name
                bcapital = business.capital
              end

              vRP.getUserAddress(user_id, function(address)
                if address then
                  home = address.home
                  number = address.number
                end

                local content = lang.police.identity.info({nome,sobrenome,age,registration,phone,bname,bcapital,home,number})
                vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
              end)
            end)
          else
            vRPclient.notify(player,{lang.common.not_found()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- show police records by registration
local function ch_show_police_records(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.getUData(user_id, "vRP:police_records", function(content)
          vRPclient.setDiv(player,{"police_pc",".div_police_pc{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- delete police records by registration
local function ch_delete_police_records(player,choice)
  vRP.prompt(player,lang.police.pc.searchreg.prompt(),"",function(player, reg)
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.setUData(user_id, "vRP:police_records", "")
        vRPclient.notify(player,{lang.police.pc.records.delete.deleted()})
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

-- close business of an arrested owner
local function ch_closebusiness(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRP.getUserIdentity(nuser_id, function(identity)
        vRP.getUserBusiness(nuser_id, function(business)
          if identity and business then
            vRP.request(player,lang.police.pc.closebusiness.request({identity.nome,identity.sobrenome,business.name}),15,function(player,ok)
              if ok then
                vRP.closeBusiness(nuser_id)
                vRPclient.notify(player,{lang.police.pc.closebusiness.closed()})
              end
            end)
          else
            vRPclient.notify(player,{lang.common.no_player_near()})
          end
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end

-- track vehicle
local function ch_trackveh(player,choice)
  vRP.prompt(player,lang.police.pc.trackveh.prompt_reg(),"",function(player, reg) -- ask reg
    vRP.getUserByRegistration(reg, function(user_id)
      if user_id ~= nil then
        vRP.prompt(player,lang.police.pc.trackveh.prompt_note(),"",function(player, note) -- ask note
          -- begin veh tracking
          vRPclient.notify(player,{lang.police.pc.trackveh.tracking()})
          local seconds = math.random(cfg.trackveh.min_time,cfg.trackveh.max_time)
          SetTimeout(seconds*1000,function()
            local tplayer = vRP.getUserSource(user_id)
            if tplayer ~= nil then
              vRPclient.getAnyOwnedVehiclePosition(tplayer,{},function(ok,x,y,z)
                if ok then -- track success
                  vRP.sendServiceAlert(nil, cfg.trackveh.service,x,y,z,lang.police.pc.trackveh.tracked({reg,note}))
                else
                  vRPclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
                end
              end)
            else
              vRPclient.notify(player,{lang.police.pc.trackveh.track_failed({reg,note})}) -- failed
            end
          end)
        end)
      else
        vRPclient.notify(player,{lang.common.not_found()})
      end
    end)
  end)
end

menu_pc[lang.police.pc.searchreg.title()] = {ch_searchreg,lang.police.pc.searchreg.description()}
menu_pc[lang.police.pc.trackveh.title()] = {ch_trackveh,lang.police.pc.trackveh.description()}
menu_pc[lang.police.pc.records.show.title()] = {ch_show_police_records,lang.police.pc.records.show.description()}
menu_pc[lang.police.pc.records.delete.title()] = {ch_delete_police_records, lang.police.pc.records.delete.description()}
menu_pc[lang.police.pc.closebusiness.title()] = {ch_closebusiness,lang.police.pc.closebusiness.description()}

menu_pc.onclose = function(player) -- close pc gui
  vRPclient.removeDiv(player,{"police_pc"})
end

local function pc_enter(source,area)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil and vRP.hasPermission(user_id,"police.oficial") then
    vRP.openMenu(source,menu_pc)
  end
end

local function pc_leave(source,area)
  vRP.closeMenu(source)
end

-- main menu choices

---- handcuff
local choice_handcuff = {function(player,choice)
	vRPclient.isInComa(player,{}, function(in_coma)
		if not in_coma then
			vRPclient.getNearestPlayer(player,{4},function(nplayer)
				local nuser_id = vRP.getUserId(nplayer)
				if nuser_id ~= nil then
					vRPclient.toggleHandcuff(nplayer,{})
				else
					vRPclient.notify(player,{lang.common.no_player_near()})
				end
			end)
		end
	end)
end,lang.police.menu.handcuff.description()}

---- putinveh
--[[
-- veh at position version
local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.getNearestOwnedVehicle(player, {10}, function(ok,vtype,name) -- get nearest owned vehicle
            if ok then
              vRPclient.getOwnedVehiclePosition(player, {vtype}, function(x,y,z)
                vRPclient.putInVehiclePositionAsPassenger(nplayer,{x,y,z}) -- put player in vehicle
              end)
            else
              vRPclient.notify(player,{lang.vehicle.no_owned_near()})
            end
          end)
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}
--]]

local choice_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

local choice_getoutveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
        if handcuffed then
          vRPclient.ejectVehicle(nplayer, {})
        else
          vRPclient.notify(player,{lang.police.not_handcuffed()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

-- SAMU
local choice_samu_putinveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isInComa(nplayer,{}, function(in_coma)
       if in_coma then
          vRPclient.stopAnim(player, {true}) -- upper
          vRPclient.stopAnim(player, {false}) -- full
          TriggerClientEvent("dr:samu:undrag", nplayer)
          --vRPclient.setHandcuffed(nplayer,{true})
          vRPclient.putInNearestVehicleAsPassenger(nplayer, {5})
        else
          vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.putinveh.description()}

local choice_samu_getoutveh = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.isInComa(nplayer,{}, function(in_coma)
       if in_coma then
          vRPclient.ejectVehicle(nplayer, {})
          --vRPclient.setHandcuffed(nplayer,{false})
          vRPclient.playAnim(nplayer,{false,{{"dead","dead_a",1}},true}) -- anim
        else
          vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.getoutveh.description()}

---- askid
local choice_askid = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(player,{lang.police.menu.askid.asked()})
      vRP.request(nplayer,lang.police.menu.askid.request(),15,function(nplayer,ok)
        if ok then
          vRP.getUserIdentity(nuser_id, function(identity)
            if identity then
              -- display identity and business
              local nome = identity.nome
              local sobrenome = identity.sobrenome
              local age = identity.age
              local phone = identity.phone
              local registration = identity.registration
              local bname = ""
              local bcapital = 0
              local home = ""
              local number = ""

              vRP.getUserBusiness(nuser_id, function(business)
                if business then
                  bname = business.name
                  bcapital = business.capital
                end

                vRP.getUserAddress(nuser_id, function(address)
                  if address then
                    home = address.home
                    number = address.number
                  end

                  local content = lang.police.identity.info({nome,sobrenome,age,registration,phone,bname,bcapital,home,number})
                  vRPclient.setDiv(player,{"police_identity",".div_police_identity{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",content})
                  -- request to hide div
                  vRP.request(player, lang.police.menu.askid.request_hide(), 1000, function(player,ok)
                    vRPclient.removeDiv(player,{"police_identity"})
                  end)
                end)
              end)
            end
          end)
        else
          vRPclient.notify(player,{lang.common.request_refused()})
        end
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.askid.description()}

---- police check
local choice_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{lang.police.menu.check.checked()})
	  
      vRPclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = vRP.getMoney(nuser_id)
        local items = ""
        local data = vRP.getUserDataTable(nuser_id)
        --[[if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item = vRP.items[k]
            if item then
              items = items.."<br />"..item.name.." (Qtd: "..v.amount..")"
            end
          end
        end]] -- old

        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = vRP.getItemName(k)
            if item_name then
              items = items.."<br />"..item_name.." (Qtd: "..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." (Munição: "..v.ammo..")"
        end

        vRPclient.setDiv(player,{"police_check_div",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        vRP.request(player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          vRPclient.removeDiv(player,{"police_check_div"})
        end)
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

local choice_seize_weapons = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
        vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            vRPclient.replaceWeapons(nplayer,{},function(weapons)
              for k,v in pairs(weapons) do -- display seized weapons
                -- vRPclient.notify(player,{lang.police.menu.seize.seized({k,v.ammo})})
                -- convert weapons to parametric weapon items
                vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                if v.ammo > 0 then
                  vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
                end
              end

              -- clear all weapons
              --vRPclient.giveWeapons(nplayer,{{},true})
              vRPclient.notify(nplayer,{lang.police.menu.seize.weapons.seized()})
            end)
          else
            vRPclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.weapons.description()}

local choice_seize_items = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil and vRP.hasPermission(nuser_id, "police.seizable") then
        vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            for k,v in pairs(cfg.seizable_items) do -- transfer seizable items
              local amount = vRP.getInventoryItemAmount(nuser_id,v)
              if amount > 0 then
                local item = vRP.items[v]
                if item then -- do transfer
                  if vRP.tryGetInventoryItem(nuser_id,v,amount,true) then
                    vRP.giveInventoryItem(user_id,v,amount,false)
                    vRPclient.notify(player,{lang.police.menu.seize.seized({item.name,amount})})
                  end
                end
              end
            end

            vRPclient.notify(nplayer,{lang.police.menu.seize.items.seized()})
          else
            vRPclient.notify(player,{lang.police.not_handcuffed()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.seize.items.description()}

-- toggle jail nearest player
local choice_jail = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isJailed(nplayer, {}, function(jailed)
          if jailed then -- unjail
            vRPclient.unjail(nplayer, {})
            vRPclient.notify(nplayer,{lang.police.menu.jail.notify_unjailed()})
            vRPclient.notify(player,{lang.police.menu.jail.unjailed()})
          else -- find the nearest jail
            vRPclient.getPosition(nplayer,{},function(x,y,z)
              local d_min = 1000
              local v_min = nil
              for k,v in pairs(cfg.jails) do
                local dx,dy,dz = x-v[1],y-v[2],z-v[3]
                local dist = math.sqrt(dx*dx+dy*dy+dz*dz)

                if dist <= d_min and dist <= 15 then -- limit the research to 15 meters
                  d_min = dist
                  v_min = v
                end

                -- jail
                if v_min then
                  vRPclient.jail(nplayer,{v_min[1],v_min[2],v_min[3],v_min[4]})
                  vRPclient.notify(nplayer,{lang.police.menu.jail.notify_jailed()})
                  vRPclient.notify(player,{lang.police.menu.jail.jailed()})
                else
                  vRPclient.notify(player,{lang.police.menu.jail.not_found()})
                end
              end
            end)
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.jail.description()}

local choice_fine = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player, {5}, function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        local money = vRP.getMoney(nuser_id)+vRP.getBankMoney(nuser_id)

        -- build fine menu
        local menu = {name=lang.police.menu.fine.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}

        local choose = function(player,choice) -- fine action
          local amount = cfg.fines[choice]
          if amount ~= nil then
            if vRP.tryFullPayment(nuser_id, amount) then
              vRP.insertPoliceRecord(nuser_id, lang.police.menu.fine.record({choice,amount}))
              vRPclient.notify(player,{lang.police.menu.fine.fined({choice,amount})})
              vRPclient.notify(nplayer,{lang.police.menu.fine.notify_fined({choice,amount})})
              vRP.closeMenu(player)
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
          end
        end

        for k,v in pairs(cfg.fines) do -- add fines in function of money available
          if v <= money then
            menu[k] = {choose,v}
          end
        end

        -- open menu
        vRP.openMenu(player, menu)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, lang.police.menu.fine.description()}

local choice_store_weapons = {function(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getWeapons(player,{},function(weapons)
      for k,v in pairs(weapons) do
        -- convert weapons to parametric weapon items
        vRP.giveInventoryItem(user_id, "wbody|"..k, 1, true)
        if v.ammo > 0 then
          vRP.giveInventoryItem(user_id, "wammo|"..k, v.ammo, true)
        end
      end

      -- clear all weapons
      vRPclient.giveWeapons(player,{{},true})
    end)
  end
end, lang.police.menu.store_weapons.description()}

--bPrison = Proxy.getInterface("b2kPrison") -- server resource

--[[
local choice_prison = {function(player, choice)
  vRPclient.getNearestPlayers(player,{15},function(nplayers) 
    local user_list = ""
    for k,v in pairs(nplayers) do
      user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
    if user_list ~= "" then
      vRP.prompt({player,"Jogadores Próximos:" .. user_list,"",function(player,target_id) 
        if target_id ~= nil and target_id ~= "" then
          vRP.prompt({player,"Tempo de Prisão em Minutos:","1",function(player,jail_time)
            if jail_time ~= nil and jail_time ~= "" then
              local targetSource = vRP.getUserSource({tonumber(target_id)})
              if targetSource ~= nil then

                -- Pena Max 120, Min 1
                if tonumber(jail_time) > 120 then
                  jail_time = 120
                end
                if tonumber(jail_time) < 1 then
                  jail_time = 1
                end
                vRPclient.isHandcuffed(target, {}, function(handcuffed)  
                  if handcuffed then 
                    TriggerClientEvent('chatMessage', -1, 'PRISÃO', { 0, 0, 0 }, '^2O ^3'.. vRP.getPlayerName({target}) ..' ^2foi preso(a) e condenado(a) por ^3'.. jail_time ..' ^2ano(s).')
                    bPrison.sendPrisoner({targetSource, tonumber(jail_time)})
                  end
                end)
              end
            end
          end})
        end
      end})
    else
      vRPclient.notify(player,{"Nenhum jogador por perto."})
    end
  end)
end, "Penitenciária Estadual"}]]


-- EMERGENCY

---- revive
local revive_seq_samu = {
  {"mini@cpr@char_a@cpr_def","cpr_intro",1},
  {"mini@cpr@char_a@cpr_str","cpr_pumpchest",1},
  --{"mini@cpr@char_a@cpr_str","cpr_success",1}
}

local revive_seq2_samu = {
  {"mini@cpr@char_b@cpr_str","cpr_kol_to_cpr",1},
  {"mini@cpr@char_b@cpr_str","cpr_success",1}
}

local choice_revive = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            if vRP.tryGetInventoryItem(user_id,"medkit",1,true) then
              vRPclient.playAnim(player,{false,revive_seq_samu,false}) -- anim
              SetTimeout(15000, function()
                vRPclient.varyHealth(nplayer,{50}) -- heal 50
                vRPclient.playAnim(nplayer,{false,revive_seq2_samu,false})
              end)
            end
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,lang.emergency.menu.revive.description()}

local choice_bandagem = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            if vRP.tryGetInventoryItem(user_id,"medkit",1,true) then
              vRPclient.playAnim(player,{false,revive_seq_samu,false}) -- anim
              SetTimeout(15000, function()
                vRPclient.resetComa(nplayer,{}) -- reseta 600s coma
                vRPclient.notify(player,{"Você aplicou os primeiros socorros no jogador. (+10m de vida)"})
                vRPclient.notify(nplayer,{"O Paramedico realizou os primeiros socorros."})
              end)
            end
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Aplica Primeiros Socorros no Paciente."}

local seq_drag = {
  {"anim@heists@box_carry@", "idle",1}
}

local choice_drag = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            vRPclient.playAnim(player, {true,seq_drag,true})
            vRPclient.playAnim(nplayer, {false,{{"dead","dead_a",1}},true})
            TriggerClientEvent("dr:samu:drag", nplayer, player)
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Carrega o Paciente."}

local choice_undrag = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
            vRPclient.stopAnim(player, {true}) -- upper
            vRPclient.stopAnim(player, {false}) -- full
            TriggerClientEvent("dr:samu:undrag", nplayer, player)
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Soltar o Paciente."}




local seq_treatment = {
  {"amb@medic@standing@tendtodead@idle_a","idle_a",1},
  {"amb@medic@standing@tendtodead@idle_a","idle_b",1},
  {"amb@medic@standing@tendtodead@idle_a","idle_c",1}
}

local choice_treatment = {function(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId(nplayer)
      if nuser_id ~= nil then
        vRPclient.isInUTI(nplayer,{}, function(in_uti)
          if in_uti then
            vRPclient.playAnim(player,{true,seq_treatment,true}) -- anim
            vRPclient.tratamentoUTI(nplayer, {})
            SetTimeout(80*1000, function()
              -- Halloween - B2kCoin
              --vRP.giveInventoryItem(user_id, "b2kcoin", 10, true)

              vRPclient.stopAnim(player, {true}) -- upper
              vRPclient.stopAnim(player, {false}) -- full

              -- Money
              vRP.giveBankMoney(user_id, 500)

              if not vRP.hasPermission(user_id,"vip.hospital") then
                vRP.tryFullPayment(nuser_id, 500)
              end
            end)
          else
            vRPclient.notify(player,{"O jogador não está na UTI."})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end,"Realizar Tratamento no Paciente."}

-- add choices to the menu
vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local choices = {}

    if vRP.hasPermission(user_id,"police.base") then
      -- build police menu
      choices[lang.police.title()] = {function(player,choice)
        vRP.buildMenu("police", {player = player}, function(menu)
          menu.name = lang.police.title()
          menu.css = {top="75px",header_color="rgba(0,125,255,0.75)"}

          if vRP.hasPermission(user_id,"police.handcuff") then
            menu[lang.police.menu.handcuff.title()] = choice_handcuff
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.putinveh.title()] = choice_putinveh
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.getoutveh.title()] = choice_getoutveh
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.check.title()] = choice_check
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.seize.weapons.title()] = choice_seize_weapons
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.seize.items.title()] = choice_seize_items
          end

          if vRP.hasPermission(user_id,"police.base") then
            menu[lang.police.menu.jail.title()] = choice_jail
          end

          if vRP.hasPermission(user_id,"police.fine") then
            menu[lang.police.menu.fine.title()] = choice_fine
          end

          -- Nova prisao
          --if vRP.hasPermission(user_id,"police.prison") then
          --  menu["Prisão"] = choice_prison
          --end

          vRP.openMenu(player,menu)
        end)
      end}
    end

    if vRP.hasPermission(user_id,"police.askid") then
      choices[lang.police.menu.askid.title()] = choice_askid
    end

    if vRP.hasPermission(user_id, "police.store_weapons") then
      choices[lang.police.menu.store_weapons.title()] = choice_store_weapons
    end

    -- Samu
    if vRP.hasPermission(user_id,"samu.menu") then
      -- build police menu
      choices["<img src='nui://vrp/gui/imgs/afirst-aid-kit.png'/> Samu"] = {function(player,choice)
        vRP.buildMenu("samu", {player = player}, function(menu)
          menu.name = "<img src='nui://vrp/gui/imgs/afirst-aid-kit.png'/> Samu"
          menu.css = {top="75px",header_color="rgba(255,0,0,0.75)"}

          if vRP.hasPermission(user_id,"samu.bandagem") then
            menu["1. Primeiros Socorros"] = choice_bandagem
          end

          if vRP.hasPermission(user_id,"samu.drag") then
            menu["2. Carregar Paciente"] = choice_drag
          end

          if vRP.hasPermission(user_id,"samu.drag") then
            menu["3. Soltar Paciente"] = choice_undrag
          end

          if vRP.hasPermission(user_id,"samu.putinveh") then
            menu["4. Colocar no Veículo"] = choice_samu_putinveh
          end

          if vRP.hasPermission(user_id,"samu.getoutveh") then
            menu["5. Tirar do Veículo"] = choice_samu_getoutveh
          end

          if vRP.hasPermission(user_id,"samu.treatment") then
            menu["6. Realizar Tratamento"] = choice_treatment
          end

          vRP.openMenu(player,menu)
        end)
      end}
    end

    add(choices)
  end
end)

local function build_client_points(source)
  -- PC
  for k,v in pairs(cfg.pcs) do
    local x,y,z = table.unpack(v)
    vRPclient.addMarker(source,{x,y,z,1.5,1.5,0.7,0,125,255,125,150})
    vRP.setArea(source,"vRP:police:pc"..k,x,y,z,1,1.5,pc_enter,pc_leave)
  end
end

-- build police points
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_points(source)
  end
end)

-- WANTED SYNC

local wantedlvl_players = {}

function vRP.getUserWantedLevel(user_id)
  return wantedlvl_players[user_id] or 0
end

-- receive wanted level
function tvRP.updateWantedLevel(level)
  local player = source
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    local was_wanted = (vRP.getUserWantedLevel(user_id) > 0)
    wantedlvl_players[user_id] = level
    local is_wanted = (level > 0)

    -- send wanted to listening service
    if not was_wanted and is_wanted then
      vRPclient.getPosition(player, {}, function(x,y,z)
        vRP.sendServiceAlert(nil, cfg.wanted.service,x,y,z,lang.police.wanted({level}))
      end)
    end

    if was_wanted and not is_wanted then
      vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id}) -- remove wanted blip (all to prevent phantom blip)
    end
  end
end

-- delete wanted entry on leave
AddEventHandler("vRP:playerLeave", function(user_id, player)
  wantedlvl_players[user_id] = nil
  vRPclient.removeNamedBlip(-1, {"vRP:wanted:"..user_id})  -- remove wanted blip (all to prevent phantom blip)
end)

-- display wanted positions
local function task_wanted_positions()
  local listeners = vRP.getUsersByPermission("police.base")
  for k,v in pairs(wantedlvl_players) do -- each wanted player
    local player = vRP.getUserSource(tonumber(k))
    if player ~= nil and v ~= nil and v > 0 then
      vRPclient.getPosition(player, {}, function(x,y,z)
        for l,w in pairs(listeners) do -- each listening player
          local lplayer = vRP.getUserSource(w)
          if lplayer ~= nil then
            vRPclient.setNamedBlip(lplayer, {"vRP:wanted:"..k,x,y,z,cfg.wanted.blipid,cfg.wanted.blipcolor,lang.police.wanted({v})})
          end
        end
      end)
    end
  end

  SetTimeout(5000, task_wanted_positions)
end
task_wanted_positions()
