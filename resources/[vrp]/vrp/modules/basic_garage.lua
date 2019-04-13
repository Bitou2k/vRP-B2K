-- a basic garage implementation

-- vehicle db
MySQL.createCommand("vRP/vehicles_table", [[
CREATE TABLE IF NOT EXISTS vrp_user_vehicles(
  user_id INTEGER,
  vehicle VARCHAR(255),
  CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
  CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);
]])

MySQL.createCommand("vRP/add_vehicle","INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle) VALUES(@user_id,@vehicle)")
MySQL.createCommand("vRP/remove_vehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("vRP/get_vehicles","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_vehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

MySQL.createCommand("vRP/count_vehicle","SELECT COUNT(*) as qtd FROM vrp_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("vRP/move_vehicle","UPDATE vrp_user_vehicles SET user_id = @tuser_id WHERE user_id = @user_id AND vehicle = @vehicle")

MySQL.createCommand("vRP/count_user_vehicles","SELECT COUNT(*) as qtd FROM vrp_user_vehicles WHERE user_id = @user_id")

-- init
MySQL.execute("vRP/vehicles_table")

-- load config
local Tools = module("vrp","lib/Tools")
local cfg = module("cfg/garages")
local cfg_inventory = module("cfg/inventory")
local vehicle_groups = cfg.garage_types
local lang = vRP.lang

local garages = cfg.garages

-- vehicle models index
local veh_models_ids = Tools.newIDGenerator()
local veh_models = {}

-- prepare garage menus

local garage_menus = {}
local cooldown = {}

function tvRP.resetCooldown()
  cooldown[source] = false
end

for group,vehicles in pairs(vehicle_groups) do
  --old local veh_type = vehicles._config.vtype or "default"
  
  -- fill vehicle models index
  for veh_model,_ in pairs(vehicles) do
    if not veh_models[veh_model] and veh_model ~= "_config" then
      veh_models[veh_model] = veh_models_ids:gen()
    end
  end
  
  local gtypes = vehicles._config.gtype

  local menu = {
    name=lang.garage.title({group}),
    css={top = "75px", header_color="rgba(255,125,0,0.75)"}
  }
  garage_menus[group] = menu

  for _,gtype in pairs(gtypes) do
    
	if gtype == "personal" then 
	  menu[lang.garage.owned.title()] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
		  -- init tmpdata for rents
		  local tmpdata = vRP.getUserTmpTable(user_id)
		  if tmpdata.rent_vehicles == nil then
			tmpdata.rent_vehicles = {}
		  end


		  -- build nested menu
		  local kitems = {}
		  local submenu = {name=lang.garage.title({lang.garage.owned.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
		  submenu.onclose = function()
			--vRP.openMenu(player,menu)
		  end

		  local choose = function(player, choice)
			local vname = kitems[choice]
			if vname then
			  -- spawn vehicle
			  --local vehicle = vehicles[vname]
			  --if vehicle then
				--vRP.closeMenu(player)
				--vRPclient.spawnGarageVehicle(player,{veh_type,vname})
			  --end
			  
			  -- implementar carregar custom mods
			  vRP.closeMenu(player)
			  --vRPclient.spawnGarageVehicle(player,{veh_type,vname})
			  vRP.getUData(user_id,"custom:u"..user_id.."veh_"..vname, function(data)
					local custom = json.decode(data) or {}

					vRPclient.spawnGarageVehicle(player,{vname}, function(result)
						if result then
						  vRPclient.setVehicleMods(player,{custom})
						else
						  vRPclient.notify(player,{lang.garage.personal.out()})
						end
					end)
			  end)
			end
		  end
	  
		  -- get player owned vehicles
		  MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(pvehicles, affected)

			for k,v in pairs(pvehicles) do
				local vehicle
				for x,garage in pairs(vehicle_groups) do
					vehicle = garage[v.vehicle]
					if vehicle then break end
			    end
				
				if vehicle then
					submenu[vehicle[1]] = {choose,vehicle[3]}
					kitems[vehicle[1]] = v.vehicle
					
				end
			end
			vRP.openMenu(player,submenu)
		  end)
		end
	  end,lang.garage.owned.description()}
	  menu[lang.garage.store.title()] = {function(player,choice)
	    -- old vRPclient.despawnGarageVehicle(player,{veh_type,15}) 
		vRPclient.getNearestOwnedVehicle(player, {15}, function(ok, name)
			if ok then
				vRPclient.despawnGarageVehicle(player, {name})
			else
				vRPclient.notify(player, {"Veículo muito longe."})
			end
		end)
	  end, lang.garage.store.description()}
	elseif gtype == "store" then 
	  menu[lang.garage.buy.title()] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then

		  -- build nested menu
		  local kitems = {}
		  local submenu = {name=lang.garage.title({lang.garage.buy.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
		  submenu.onclose = function()
			vRP.openMenu(player,menu)
		  end

		  local choose = function(player, choice)
			local vname = kitems[choice]
			if vname then
			  -- buy vehicle
			  local vehicle = vehicles[vname]
			  if vehicle then
				MySQL.query("vRP/count_vehicle", {vehicle = vname}, function(row, affected)
					if vehicle[4] ~= -1 and row[1].qtd >= vehicle[4] then
						vRPclient.notify(player,{"~r~Sem estoque para este modelo."})
					else
						local priceBuyCar = vehicle[2]
						local discountBuyCar = 0
						local maxCarsPerm = 3

						if vRP.hasPermission(user_id, "vip.10carros") then
							discountBuyCar = priceBuyCar * 0.10
							maxCarsPerm = 4
						end
						if vRP.hasPermission(user_id, "vip.20carros") then
							discountBuyCar = priceBuyCar * 0.20
							maxCarsPerm = 5
						end
						if vRP.hasPermission(user_id, "vip.30carros") then
							discountBuyCar = priceBuyCar * 0.30
							maxCarsPerm = 6
						end

						priceBuyCar = priceBuyCar - discountBuyCar

						MySQL.query("vRP/count_user_vehicles", {user_id = user_id}, function(row2, affected)

							if vRP.hasPermission(user_id, "vip.unlimitedcars") then
								maxCarsPerm = -1
							end
							
							if maxCarsPerm ~= -1 and row2[1].qtd >= maxCarsPerm then
								vRPclient.notify(player,{"~r~Limite de Veículos por Dono atingido. (Max: " .. maxCarsPerm ..")"})
							else
								if vRP.tryPayment(user_id,priceBuyCar) then
									MySQL.execute("vRP/add_vehicle", {user_id = user_id, vehicle = vname})
									vRPclient.notify(player,{lang.money.paid({priceBuyCar})})
									vRP.closeMenu(player)
								else
									vRPclient.notify(player,{lang.money.not_enough()})
								end
							end
						end)
					end
				end)
			  end
			end
		  end
		  
		  -- get player owned vehicles (indexed by vehicle type name in lower case)
		  MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
			local pvehicles = {}
			for k,v in pairs(_pvehicles) do
			  pvehicles[string.lower(v.vehicle)] = true
			end

			-- for each existing vehicle in the garage group
			for k,v in pairs(vehicles) do
			  if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
				submenu[v[1]] = {choose,lang.garage.buy.info({v[2],v[3]})}
				kitems[v[1]] = k
			  end
			end

			vRP.openMenu(player,submenu)
		  end)
		end
	  end,lang.garage.buy.description()}
	  
	  menu[lang.garage.sell.title()] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then

		  -- build nested menu
		  local kitems = {}
		  local submenu = {name=lang.garage.title({lang.garage.sell.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
		  submenu.onclose = function()
			vRP.openMenu(player,menu)
		  end

		  local choose = function(player, choice)
			local vname = kitems[choice]
			if vname then
			  -- sell vehicle
			  local vehicle = vehicles[vname]
			  if vehicle then
				local price = math.ceil(vehicle[2]*cfg.sell_factor)

				MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = vname}, function(rows, affected)
				  if #rows > 0 then -- has vehicle
					vRP.giveMoney(user_id,price)
					MySQL.execute("vRP/remove_vehicle", {user_id = user_id, vehicle = vname})
					vRP.delUData(user_id,"custom:u"..user_id.."veh_"..vname)
					vRP.delSData(user_id,"chest:u"..user_id.."veh_"..vname)

					vRPclient.isOwnedVehicleOut(player, {vname}, function(veh,netIdSent)
						if veh then
							vRPclient.forceDespawnGarageVehicle(player,{veh})
							TriggerClientEvent("b2k:syncRemovedEntity", -1, netIdSent)
						end
					end)
					
					vRPclient.notify(player,{lang.money.received({price})})
					vRP.closeMenu(player)
				  else
					vRPclient.notify(player,{lang.common.not_found()})
				  end
				end)
			  end
			end
		  end
		  
		  -- get player owned vehicles (indexed by vehicle type name in lower case)
		  MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
			local pvehicles = {}
			for k,v in pairs(_pvehicles) do
			  pvehicles[string.lower(v.vehicle)] = true
			end

			-- for each existing vehicle in the garage group
			for k,v in pairs(pvehicles) do
			  local vehicle = vehicles[k]
			  if vehicle then -- not already owned
				local price = math.ceil(vehicle[2]*cfg.sell_factor)
				submenu[vehicle[1]] = {choose,lang.garage.buy.info({price,vehicle[3]})}
				kitems[vehicle[1]] = k
			  end
			end

			vRP.openMenu(player,submenu)
		  end)
		end
	  end,lang.garage.sell.description()}
	  
	elseif gtype == "rental" then 
	  menu[lang.garage.rent.title()] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
		  -- init tmpdata for rents
		  local tmpdata = vRP.getUserTmpTable(user_id)
		  if tmpdata.rent_vehicles == nil then
			tmpdata.rent_vehicles = {}
		  end

		  -- build nested menu
		  local kitems = {}
		  local submenu = {name=lang.garage.title({lang.garage.rent.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
		  submenu.onclose = function()
			vRP.openMenu(player,menu)
		  end

		  local choose = function(player, choice)
			local vname = kitems[choice]
			if vname then
			  -- rent vehicle
			  local vehicle = vehicles[vname]
			  if vehicle then
				local price = math.ceil(vehicle[2]*cfg.rent_factor)
				if vRP.tryPayment(user_id,price) then
				  -- add vehicle to rent tmp data
				  tmpdata.rent_vehicles[vname] = true

				  vRPclient.notify(player,{lang.money.paid({price})})
				  vRP.closeMenu(player)
				else
				  vRPclient.notify(player,{lang.money.not_enough()})
				end
			  end
			end
		  end
		  
		  -- get player owned vehicles (indexed by vehicle type name in lower case)
		  MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(_pvehicles, affected)
			local pvehicles = {}
			for k,v in pairs(_pvehicles) do
			  pvehicles[string.lower(v.vehicle)] = true
			end

			-- add rents to blacklist
			for k,v in pairs(tmpdata.rent_vehicles) do
			  pvehicles[string.lower(k)] = true
			end

			-- for each existing vehicle in the garage group
			for k,v in pairs(vehicles) do
			  if k ~= "_config" and pvehicles[string.lower(k)] == nil then -- not already owned
				local price = math.ceil(v[2]*cfg.rent_factor)
				submenu[v[1]] = {choose,lang.garage.buy.info({price,v[3]})}
				kitems[v[1]] = k
			  end
			end

			vRP.openMenu(player,submenu)
		  end)
		end
	  end,lang.garage.rent.description()}
	  menu[lang.garage.owned.title()] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id ~= nil then
		  -- init tmpdata for rents
		  local tmpdata = vRP.getUserTmpTable(user_id)
		  if tmpdata.rent_vehicles == nil then
			tmpdata.rent_vehicles = {}
		  end


		  -- build nested menu
		  local kitems = {}
		  local submenu = {name=lang.garage.title({lang.garage.owned.title()}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
		  submenu.onclose = function()
			--vRP.openMenu(player,menu)
		  end

		  local choose = function(player, choice)
			local vname = kitems[choice]
			if vname then
			  vRP.closeMenu(player)

			  vRP.getUData(user_id,"custom:u"..user_id.."veh_"..vname, function(data)
					local custom = json.decode(data) or {}
					vRPclient.spawnGarageVehicle(player,{vname}, function(result)
						if result then
						  vRPclient.setVehicleMods(player,{custom})
						else
						  vRPclient.notify(player,{lang.garage.personal.out()})
						end
					end)
			  end)
			end
		  end
		  
		  -- get player owned vehicles
		  MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
			-- add rents to whitelist
			for k,v in pairs(tmpdata.rent_vehicles) do
			  if v then -- check true, prevent future neolua issues
				table.insert(pvehicles,{vehicle = k})
			  end
			end

			for k,v in pairs(pvehicles) do
			  local vehicle = vehicles[v.vehicle]
			  if vehicle then
				submenu[vehicle[1]] = {choose,vehicle[3]}
				kitems[vehicle[1]] = v.vehicle
			  end
			end
			
			vRP.openMenu(player,submenu)
		  end)
		end
	  end,lang.garage.owned.description()}
	  menu[lang.garage.store.title()] = {function(player,choice)
	    -- old vRPclient.despawnGarageVehicle(player,{veh_type,15}) 
		vRPclient.getNearestOwnedVehicle(player, {15}, function(ok, name)
			if ok then
				vRPclient.despawnGarageVehicle(player, {name})
			else
				vRPclient.notify(player, {"Veículo muito longe."})
			end
		end)
	  end, lang.garage.store.description()}
	end

   end
end

local function build_client_garages(source)
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    for k,v in pairs(garages) do
      local gtype,x,y,z = table.unpack(v)

      local group = vehicle_groups[gtype]
      if group then
        local gcfg = group._config

        -- enter
        local garage_enter = function(player,area)
          local user_id = vRP.getUserId(source)
          if user_id ~= nil and vRP.hasPermissions(user_id,gcfg.permissions or {}) then
            local menu = garage_menus[gtype]
            if menu then
              vRP.openMenu(player,menu)
            end
          end
        end

        -- leave
        local garage_leave = function(player,area)
          vRP.closeMenu(player)
        end
		
		if gcfg.blipid ~= nil then
			vRPclient.addScaledBlip(source,{x,y,z,0.7,gcfg.blipid,gcfg.blipcolor,lang.garage.title({gtype})})
			--vRPclient.addBlip(source,{x,y,z,gcfg.blipid,gcfg.blipcolor,lang.garage.title({gtype})})
		end
		if string.match(gtype, "Garagem") then
        	--vRPclient.addMarker(source,{x,y,z,1.5,1.5,0.7,0,125,255,125,150})
        	vRPclient.addCustomMarker(source,{27,x,y,z,0,0,0,2.5,2.5,0.7,0,125,255,125,150,1,0,0})
        	vRPclient.addCustomMarker(source,{36,x,y,z,0,0,0,1.5,1.5,1.5,0,125,255,125,150,0,1,0})
		else
			vRPclient.addMarker(source,{x,y,z,1.5,1.5,0.7,0,125,255,125,150})
		end

        vRP.setArea(source,"vRP:garage"..k,x,y,z,2.5,1.5,garage_enter,garage_leave)
      end
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
  if first_spawn then
    build_client_garages(source)
	vRPclient.setUserId(source, {user_id})
	vRPclient.setVehicleModelsIndex(source, {veh_models})
  end
end)

-- VEHICLE MENU

-- define vehicle actions
-- action => {cb(user_id,player,veh_group,veh_name),desc}
local veh_actions = {}

-- open trunk
veh_actions[lang.vehicle.trunk.title()] = {function(user_id,player,name)
  local chestname = "u"..user_id.."veh_"..string.lower(name)
  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

  local tmpdata = vRP.getUserTmpTable(user_id)
  if tmpdata.rent_vehicles[name] == true then
	vRPclient.notify(player,{"~r~Carros Alugados não possuem Porta-Malas."})
	return
  else
	-- open chest
	vRPclient.vc_openDoor(player, {name, 5})
	vRP.openChest(player, chestname, max_weight, function()
	  vRPclient.vc_closeDoor(player, {name, 5})
	end)
  end
end, lang.vehicle.trunk.description()}

-- detach trailer
veh_actions[lang.vehicle.detach_trailer.title()] = {function(user_id,player,name)
  vRPclient.vc_detachTrailer(player, {name})
end, lang.vehicle.detach_trailer.description()}

-- detach towtruck
veh_actions[lang.vehicle.detach_towtruck.title()] = {function(user_id,player,name)
  vRPclient.vc_detachTowTruck(player, {name})
end, lang.vehicle.detach_towtruck.description()}

-- detach cargobob
veh_actions[lang.vehicle.detach_cargobob.title()] = {function(user_id,player,name)
  vRPclient.vc_detachCargobob(player, {name})
end, lang.vehicle.detach_cargobob.description()}

-- lock/unlock
veh_actions[lang.vehicle.lock.title()] = {function(user_id,player,name)
  vRPclient.vc_toggleLock(player, {name})
end, lang.vehicle.lock.description()}

-- engine on/off
veh_actions[lang.vehicle.engine.title()] = {function(user_id,player,name)
  vRPclient.vc_toggleEngine(player, {name})
end, lang.vehicle.engine.description()}

local function ch_vehicle(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- check vehicle
    vRPclient.getNearestOwnedVehicle(player,{7},function(ok,name)
	
      -- build vehicle menu
      vRP.buildMenu("vehicle", {user_id = user_id, player = player, vname = name}, function(menu)
          menu.name=lang.vehicle.title()
          menu.css={top="75px",header_color="rgba(255,125,0,0.75)"}
		  
          if ok then
			for k,v in pairs(veh_actions) do
				menu[k] = {function(player,choice) v[1](user_id,player,name) end, v[2]}
			end
		  end

          local ch_keys = function(player,choice)
			local user_id = vRP.getUserId(player)
			if user_id ~= nil then
				local kitems = {}
				local tosub = false
				local submenu = {name=lang.garage.keys.title(), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
				submenu.onclose = function()
					if not tosub then
						vRP.openMenu(player,menu)
					end
				end
				
				local choose = function(player, choice)
					local vehicle = choice
					local vname = kitems[vehicle]
					local subsubmenu = {name=lang.garage.keys.key({vehicle}), css={top="75px",header_color="rgba(255,125,0,0.75)"}}
					subsubmenu.onclose = function()
						tosub = false
						vRP.openMenu(player,submenu)
					end
					
					local ch_sell = function(player, choice)
						vRPclient.getNearestPlayer(player, {5}, function(nplayer)
							if nplayer then
								local tuser_id = vRP.getUserId(nplayer)
								MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = vname}, function(rowss, affected)
									if #rowss > 0 then
										MySQL.query("vRP/get_vehicle", {user_id = tuser_id, vehicle = vname}, function(rows, affected)
											if #rows == 0 then
												vRP.prompt(player,lang.garage.keys.sell.prompt(),"",function(player,price)
													local price = tonumber(sanitizeString(price,"\"[]{}+=?!_()#@%/\\|,.",false))
													vRP.request(nplayer, lang.garage.keys.sell.request({vehicle,price}), 30,function(nplayer,ok)
														if ok then
															if vRP.tryFullPayment(tuser_id,price) then
																MySQL.execute("vRP/move_vehicle", {user_id = user_id, tuser_id = tuser_id, vehicle = vname})
																vRP.delUData(tuser_id,"custom:u"..tuser_id.."veh_"..vname) -- try delete old car history
																vRP.delSData(user_id,"chest:u"..user_id.."veh_"..vname)
																vRP.getUData(user_id,"custom:u"..user_id.."veh_"..vname, function(data)
																	local custom = json.decode(data) or {}
																	vRP.setUData(tuser_id,"custom:u"..tuser_id.."veh_"..vname, json.encode(custom))
																	vRP.delUData(user_id,"custom:u"..user_id.."veh_"..vname)
																end)
																if price > 0 then
																	vRP.giveBankMoney(user_id,price)
																	vRPclient.notify(nplayer,{lang.money.paid({price})})
																	vRPclient.notify(player,{lang.money.received({price})})
																end
																
																vRPclient.isOwnedVehicleOut(player, {vname}, function(veh,netIdSent)
																	if veh then
																		vRPclient.forceDespawnGarageVehicle(player,{veh})
																		TriggerClientEvent("b2k:syncRemovedEntity", -1, netIdSent)
																	end
																end)
																vRP.closeMenu(player)
															else
																vRPclient.notify(player,{lang.money.not_enough()})
																vRPclient.notify(nplayer,{lang.money.not_enough()})
															end
														else
															vRPclient.notify(player,{lang.common.request_refused()})
														end
													end)
												end)
											else
												vRPclient.notify(player,{"Você não possui este veículo."})
											end
										end)
									else
										vRPclient.notify(nplayer,{lang.garage.keys.sell.owned()})
										vRPclient.notify(player,{lang.garage.keys.sell.owned()})
									end
								end)
							else
								vRPclient.notify(player,{lang.common.no_player_near()})
							end
						end)
					end
					
					subsubmenu[lang.garage.keys.sell.title()] = {ch_sell,lang.garage.keys.sell.description()}
					
					tosub = true
					vRP.openMenu(player,subsubmenu)
				end
				
				-- get player owned vehicles (indexed by vehicle type name in lower case)
				MySQL.query("vRP/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
					for k,v in pairs(pvehicles) do
						local vehicle
						for x,garage in pairs(vehicle_groups) do
							vehicle = garage[v.vehicle]
							if vehicle then break end
						end
						
						if vehicle then
							submenu[vehicle[1]] = {choose,vehicle[3]}
							kitems[vehicle[1]] = v.vehicle
						end
					end

					vRP.openMenu(player,submenu)
				end)
			end
          end
		  
		  menu[lang.garage.keys.title()] = {ch_keys, lang.garage.keys.description()}
		  
          vRP.openMenu(player,menu)
        end)
      --else
      --  vRPclient.notify(player,{lang.vehicle.no_owned_near()})
      --end
    end)

  end
end

-- ask trunk (open other user car chest)
local function ch_asktrunk(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId(nplayer)
    if nuser_id ~= nil then
      vRPclient.notify(player,{lang.vehicle.asktrunk.asked()})
      vRP.request(nplayer,lang.vehicle.asktrunk.request(),15,function(nplayer,ok)
        if ok then -- request accepted, open trunk
          vRPclient.getNearestOwnedVehicle(nplayer,{7},function(ok,name)
            if ok then
              local tmpdata = vRP.getUserTmpTable(nuser_id)
              if tmpdata.rent_vehicles[name] == true then
                vRPclient.notify(player,{"~r~Carros Alugados não possuem Porta-Malas."})
                return
              else
				  local chestname = "u"..nuser_id.."veh_"..string.lower(name)
				  local max_weight = cfg_inventory.vehicle_chest_weights[string.lower(name)] or cfg_inventory.default_vehicle_chest_weight

				  -- open chest
				  local cb_out = function(idname,amount)
					vRPclient.notify(nplayer,{lang.inventory.give.given({vRP.getItemName(idname),amount})})
				  end

				  local cb_in = function(idname,amount)
					vRPclient.notify(nplayer,{lang.inventory.give.received({vRP.getItemName(idname),amount})})
				  end

				  vRPclient.vc_openDoor(nplayer, {name,5})
				  vRP.openChest(player, chestname, max_weight, function()
					vRPclient.vc_closeDoor(nplayer, {name,5})
				  end,cb_in,cb_out)
			  end
            else
              vRPclient.notify(player,{lang.vehicle.no_owned_near()})
              vRPclient.notify(nplayer,{lang.vehicle.no_owned_near()})
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
end

-- repair nearest vehicle
local repair_seq = {
  {"mini@repair","fixing_a_player",1}
}

local function ch_repair(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
	vRPclient.getNearestVehicle(player,{4},function(vehicle)
		if vehicle then
			vRPclient.checkOffSetAndHoodOpen(player,{vehicle,true},function(isok,netid)
				if isok then
					if vRP.tryGetInventoryItem(user_id,"repairkit",1,true) then
						vRPclient.playAnim(player,{false,repair_seq,false})
						SetTimeout(15000, function()
							TriggerClientEvent("b2k:fixeVehicleByNetId", -1, netid)
							vRPclient.playSound(player,{"WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"})
							vRPclient.stopAnim(player,{false})
						end)
					end
				else
					vRPclient.notify(player,{"Você precisa se posicionar na Frente ou Atrás do veículo."})
				end
			end)
		else
			vRPclient.notify(player,{"Nenhum veículo próximo."})
		end
	end)
  end
end

-- replace nearest vehicle
local function ch_replace(player,choice)
  vRPclient.replaceNearestVehicle(player,{7})
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    -- add vehicle entry
    local choices = {}
    choices[lang.vehicle.title()] = {ch_vehicle}

    -- add ask trunk
    choices[lang.vehicle.asktrunk.title()] = {ch_asktrunk}

    -- add repair functions
    if vRP.hasPermission(user_id, "vehicle.repair") then
      choices[lang.vehicle.repair.title()] = {ch_repair, lang.vehicle.repair.description()}
    end

    if vRP.hasPermission(user_id, "vehicle.replace") then
      choices[lang.vehicle.replace.title()] = {ch_replace, lang.vehicle.replace.description()}
    end

    add(choices)
  end
end)

RegisterServerEvent("b2k:pressLockCar")
AddEventHandler("b2k:pressLockCar", function()
	local player = source
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		vRPclient.getNearestOwnedVehicle(player, {7}, function(ok, name)
			if ok then
				vRPclient.vc_toggleLock(player, {name})
				vRPclient.playSound(player,{"WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"})
				--vRPclient.playAnim(player,{true,{{"anim@mp_player_intincardancelow@ps@","idle_a_fp",1}},false})
				--SetTimeout(1000, function()
				--	vRPclient.stopAnim(player,{false})
				--end)
			end
		end)
	end
end)

RegisterServerEvent("b2k:trySyncLockVehicle")
AddEventHandler("b2k:trySyncLockVehicle", function(nveh, cond)
	local player = source
	local user_id = vRP.getUserId(player)
	if user_id ~= nil then
		TriggerClientEvent("b2k:syncLockVehicle", -1, nveh, cond)
	end
end)