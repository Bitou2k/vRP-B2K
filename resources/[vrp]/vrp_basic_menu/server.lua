local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPbm = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_basic_menu")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")
vRPbsC = Tunnel.getInterface("vRP_barbershop","vRP_barbershop")
Tunnel.bindInterface("vrp_basic_menu",vRPbm)

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

local jailRooms = {
  {x = 1726.587890625, y = 2630.3674316406, z = 49.788803100586},
  {x = 1726.5895996094, y = 2635.2932128906, z = 49.788841247558},
  {x = 1726.9464111328, y = 2640.5881347656, z = 49.788845062256},
  {x = 1727.2291259766, y = 2645.3881835938, z = 49.788841247558},
  {x = 1746.172241211, y = 2645.3884277344, z = 49.788799285888},
  {x = 1746.2196044922, y = 2639.8608398438, z = 49.788803100586},
  {x = 1746.3303222656, y = 2634.755859375, z = 49.788799285888},
  {x = 1746.119506836, y = 2629.9677734375, z = 49.788803100586}
}

Citizen.CreateThread(function()
	ac_webhook_joins = GetConvar("ac_webhook_joins", "none")
	ac_webhook_gameplay = GetConvar("ac_webhook_gameplay", "none")
	ac_webhook_bans = GetConvar("ac_webhook_bans", "none")
	ac_webhook_wl = GetConvar("ac_webhook_wl", "none")
	ac_webhook_arsenal = GetConvar("ac_webhook_arsenal", "none")

	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-- LOG FUNCTION
function vRPbm.logInfoToFile(file,info)
  file = io.open(file, "a")
  if file then
    file:write(os.date("%c").." => "..info.."\n")
  end
  file:close()
end
-- MAKE CHOICES
--toggle service
local choice_service = {function(player,choice)
  local user_id = vRP.getUserId({player})
  local service = "onservice"
  if user_id ~= nil then
    if vRP.hasGroup({user_id,service}) then
	  vRP.removeUserGroup({user_id,service})
	  if vRP.hasMission({player}) then
		vRP.stopMission({player})
	  end
      vRPclient.notify(player,{"Off service"})
	else
	  vRP.addUserGroup({user_id,service})
      vRPclient.notify(player,{"On service"})
	end
  end
end, "Go on/off service"}

-- teleport waypoint
local choice_tptowaypoint = {function(player,choice)
  TriggerClientEvent("b2k:TpToWaypoint", player)
  SendWebhookMessage(ac_webhook_gameplay, "**ADMIN TpToWayPoint** \n```\nAdmin ID: "..GetPlayerName(player).." TpToWaypoint```")
end, "Teleport to map blip."}

-- fix barbershop green hair for now
local ch_fixhair = {function(player,choice)
    local custom = {}
    local user_id = vRP.getUserId({player})
    vRP.getUData({user_id,"vRP:head:overlay",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
        vRPbsC.setOverlay(player,{custom,true})
	  end
	end})
end, "Desbuga Cabelo do Barbershop."}

--toggle blips
local ch_blips = {function(player,choice)
  TriggerClientEvent("b2k:showBlips", player)
  SendWebhookMessage(ac_webhook_gameplay, "**ADMIN ShowBlips** \n```\nUser: "..GetPlayerName(player).." ShowBlips```")
end, "Toggle blips."}

local spikes = {}
local ch_spikes = {function(player,choice)
	local user_id = vRP.getUserId({player})
	BMclient.isCloseToSpikes(player,{},function(closeby)
		if closeby and (spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.removeSpikes(player,{})
		  spikes[player] = false
		elseif closeby and not spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
		  vRPclient.notify(player,{"You can carry only one set of spikes!"})
		elseif not closeby and spikes[player] and not vRP.hasPermission({user_id,"admin.spikes"}) then
		  vRPclient.notify(player,{"You can deploy only one set of spikes!"})
		elseif not closeby and (not spikes[player] or vRP.hasPermission({user_id,"admin.spikes"})) then
		  BMclient.setSpikesOnGround(player,{})
		  spikes[player] = true
		end
	end)
end, "Toggle spikes."}

local ch_sprites = {function(player,choice)
  TriggerClientEvent("b2k:showSprites", player)
end, "Toggle sprites."}

local ch_deleteveh = {function(player,choice)
  BMclient.deleteVehicleInFrontOrInside(player,{5.0})
  SendWebhookMessage(ac_webhook_gameplay, "**Delete Car** \n```\nUser: "..GetPlayerName(player).." DeleteVeh```")
end, "Delete nearest car."}

--client function
local ch_crun = {function(player,choice)
  vRP.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerClientEvent("b2k:RunCode:RunStringLocally", player, stringToRun)
  end})
end, "Run client function."}

--server function
local ch_srun = {function(player,choice)
  vRP.prompt({player,"Function:","",function(player,stringToRun) 
    stringToRun = stringToRun or ""
	TriggerEvent("b2k:RunCode:RunStringRemotelly", stringToRun)
  end})
end, "Run server function."}

--police weapons // comment out the weapons if you dont want to give weapons.
local police_weapons = {}

police_weapons["Radio Patrulha"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if vRP.hasPermission({user_id,"pm.armas"}) then
            vRPclient.giveWeapons(player,{{
              ["WEAPON_PISTOL"] = {ammo=100}, -- Pistola
              --["WEAPON_PUMPSHOTGUN"] = {ammo=36}, -- 12
              ["WEAPON_NIGHTSTICK"] = {ammo=1}, -- Cacetete
              ["WEAPON_STUNGUN"] = {ammo=1}, -- Tazer
              ["WEAPON_FLASHLIGHT"] = {ammo=1} -- Lanterna       
            }, true})
            BMclient.setArmour(player,{100,true})
			SendWebhookMessage(ac_webhook_arsenal, "**Police Weapons: Radio Patrulha** \n```\nUser ID: "..user_id.."```")
        else
            vRPclient.notify(player, {"Você não tem permissão."})
        end
    end
end}

police_weapons["Rota"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if vRP.hasPermission({user_id,"rota.armas"}) then
            vRPclient.giveWeapons(player,{{
              ["WEAPON_COMBATPISTOL"] = {ammo=180}, -- Pistola de Combate
              ["WEAPON_PUMPSHOTGUN"] = {ammo=64}, -- 12
              ["WEAPON_NIGHTSTICK"] = {ammo=1}, -- Cacetete
              ["WEAPON_STUNGUN"] = {ammo=1}, -- Tazer
              ["WEAPON_FLASHLIGHT"] = {ammo=1}, -- Lanterna 
              ["WEAPON_CARBINERIFLE"] = {ammo=200} -- Carabina    
            }, true})
            BMclient.setArmour(player,{100,true})
			SendWebhookMessage(ac_webhook_arsenal, "**Police Weapons: Rota** \n```\nUser ID: "..user_id.."```")
        else
            vRPclient.notify(player, {"Você não tem permissão."})
        end
    end
end}

police_weapons["Forca Tatica"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if vRP.hasPermission({user_id,"ft.armas"}) then
            vRPclient.giveWeapons(player,{{
              ["WEAPON_COMBATPISTOL"] = {ammo=180}, -- Pistola de Combate
              ["WEAPON_PUMPSHOTGUN"] = {ammo=64}, -- 12
              ["WEAPON_NIGHTSTICK"] = {ammo=1}, -- Cacetete
              ["WEAPON_STUNGUN"] = {ammo=1}, -- Tazer
              ["WEAPON_FLASHLIGHT"] = {ammo=1}, -- Lanterna
              ["WEAPON_ASSAULTSMG"] = {ammo=200} -- Metralhadora
            }, true})
            BMclient.setArmour(player,{100,true})
			SendWebhookMessage(ac_webhook_arsenal, "**Police Weapons: Forca Tatica** \n```\nUser ID: "..user_id.."```")
        else
            vRPclient.notify(player, {"Você não tem permissão."})
        end
    end
end}

local federal_weapons = {}
federal_weapons["Federal"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
        if vRP.hasPermission({user_id,"federal.armas"}) then
            vRPclient.giveWeapons(player,{{
              ["WEAPON_COMBATPISTOL"] = {ammo=250}, -- Pistola de Combate
              ["WEAPON_PUMPSHOTGUN"] = {ammo=250}, -- 12
              ["WEAPON_NIGHTSTICK"] = {ammo=1}, -- Cacetete
              ["WEAPON_STUNGUN"] = {ammo=1}, -- Tazer
              ["WEAPON_FLASHLIGHT"] = {ammo=1}, -- Lanterna 
              ["WEAPON_CARBINERIFLE"] = {ammo=250} -- Carabina    
            }, true})
            BMclient.setArmour(player,{100,true})
			TriggerClientEvent("b2k:equipFederal", player)
			SendWebhookMessage(ac_webhook_arsenal, "**Police Weapons: Federal** \n```\nUser ID: "..user_id.."```")
        else
            vRPclient.notify(player, {"Você não tem permissão."})
        end
    end
end}

--store money
local choice_store_money = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    local amount = vRP.getMoney({user_id})
    if vRP.tryPayment({user_id, amount}) then -- unpack the money
      vRP.giveInventoryItem({user_id, "money", amount, true})
    end
  end
end, "Guarda dinheiro da carteira no inventário."}

--medkit storage
local emergency_medkit = {}
emergency_medkit["Equipar"] = {function(player,choice)
	local user_id = vRP.getUserId({player})
	vRP.giveInventoryItem({user_id,"medkit",25,true})
end}

--heal me
local emergency_heal = {}
emergency_heal["Curar (R$ 500)"] = {function(player,choice)
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
    vRPclient.isInComa(player,{}, function(in_coma)
      if not in_coma then
        local newpricemedical = 500
        if vRP.hasPermission({user_id,"vip.hospital"}) then
          newpricemedical = 0
        end

        if vRP.tryPayment({user_id,newpricemedical}) then
          vRPclient.teleportUTI(player, {false})
          vRPclient.notify(player, {"Aguarde enquanto você recebe tratamento."})
        else
          vRPclient.notify(player,{"Dinheiro Insuficiente."})
        end
      else
        vRPclient.notify(player,{"Você está em coma."})
      end
    end)
	end
end}

emergency_heal["Transferir UTI (SAMU)"] = {function(player,choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    if vRP.hasPermission({user_id,"samu.uti"}) then
      vRPclient.getNearestPlayer(player,{2},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
          vRPclient.stopAnim(player, {true}) -- upper
          vRPclient.stopAnim(player, {false}) -- full
          TriggerClientEvent("dr:samu:undrag", nplayer)
          vRPclient.teleportUTI(nplayer, {true})
          vRPclient.notify(player,{"O cidadão foi transferido para a UTI."})
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      end)
    end
  end
end}

local hospi_e = {}
hospi_e["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{251.32405090332, -1367.2664794922, 39.534370422363}) -- Destination point (Morgue) 360.08847045898, y = -585.16223144531, z = 28.820465087891
end}

local hospi_s = {}
hospi_s["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{360.08847045898, -585.16223144531, 28.820465087891}) -- Destination point (Outside)
end}

local tribunal_e = {}
tribunal_e["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{236.01475524902,-413.36260986328,-118.16348266602}) -- Destination point (Morgue)
end}

local tribunal_s = {}
tribunal_s["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{233.23551940918,-410.48593139648,48.11194229126}) -- Destination point (Outside)
end}

local tribunal_lobbye = {}
tribunal_lobbye["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{238.80630493164,-334.22885131836,-118.77348327637}) -- Destination point (Morgue)
end}

local tribunal_lobbys = {}
tribunal_lobbys["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{225.11094665527,-419.61151123047,-118.1996383667}) -- Destination point (Outside)
end}

local federal_entrada = {}
federal_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{467.77380371094,-1097.7532958984,38.706531524658}) -- Entrada Federal
end}

local federal_saida = {}
federal_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{416.05096435547,-1086.2639160156,30.057842254639}) -- Saida Federal
end}

local federal_entrada_heli = {}
federal_entrada_heli["Subir"] = {function(player,choice)
    vRPclient.teleport(player,{484.60437011719,-1094.1079101563,43.075649261475}) -- Entrada Federal Topo
end}

local federal_saida_heli = {}
federal_saida_heli["Descer"] = {function(player,choice)
    vRPclient.teleport(player,{471.49169921875,-1089.7761230469,38.706504821777}) -- Saida Federal Topo
end}

local lavagem_entrada = {}
lavagem_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{1138.1552734375,-3198.5004882813,-39.665687561035}) -- Entrada Lavagem de Dinheiro
end}

local lavagem_saida = {}
lavagem_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{858.64544677734,-3203.6105957031,5.9949970245361}) -- Saida Lavagem de Dinheiro
end}

local weed_entrada = {}
weed_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{1064.9476318359,-3183.3408203125,-39.163444519043}) -- Entrada Farm de Maconha (Colher)
end}

local weed_saida = {}
weed_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{2564.1904296875,4680.482421875,34.076770782471}) -- Saida Farm de Maconha (Colher)
end}

local meth_entrada = {}
meth_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{997.3916015625,-3200.63671875,-36.393688201904}) -- Entrada Farm de Maconha (Colher)
end}

local meth_saida = {}
meth_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{1454.46875,-1651.9616699219,66.99479675293}) -- Saida Farm de Maconha (Colher)
end}

local cocaine_entrada = {}
cocaine_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{1088.6865234375,-3188.0783691406,-38.993461608887}) -- Entrada Farm de Cocaina (Colher)
end}

local cocaine_saida = {}
cocaine_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{1416.9096679688,6339.8159179688,24.189083099365}) -- Saida Farm de Cocaina (Colher)
end}

local mina_entrada = {}
mina_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-595.21545410156,2085.802734375,131.38134765625}) -- Entrada Mina
end}

local mina_saida = {}
mina_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-596.86285400391,2090.830078125,131.41278076172}) -- Saida Mina
end}

local oab_entrada = {}
oab_entrada["Subir"] = {function(player,choice)
    vRPclient.teleport(player,{155.01602172852,-1108.9591064453,37.183734893799}) -- Entrada
end}

local oab_saida = {}
oab_saida["Descer"] = {function(player,choice)
    vRPclient.teleport(player,{155.37397766113,-1103.2545166016,29.323266983032}) -- Saida
end}

local bahamas_entrada = {}
bahamas_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-1387.2572021484,-588.40148925781,30.319505691528}) -- Entrada
end}

local bahamas_saida = {}
bahamas_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-1388.7598876953,-586.23864746094,30.21915435791}) -- Saida
end}

local hospheli_entrada = {}
hospheli_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{339.2073059082,-584.13525390625,74.165672302246}) -- Entrada
end}

local hospheli_saida = {}
hospheli_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{325.24520874023,-598.69177246094,43.291786193848}) -- Saida
end}

local b2knewsheli_entrada = {}
b2knewsheli_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-569.37023925781,-927.76025390625,36.833557128906}) -- Entrada
end}

local b2knewsheli_saida = {}
b2knewsheli_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-598.76416015625,-929.82464599609,23.86349105835}) -- Saida
end}

local lsquarto01_entrada = {}
lsquarto01_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{151.6649017334,-1007.326171875,-99.0}) -- Entrada
end}

local lsquarto01_saida = {}
lsquarto01_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{1398.3591308594,1157.0681152344,114.33364868164}) -- Saida
end}

local b2ktower_entrada = {}
b2ktower_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{208.82633972168,-921.85876464844,214.48066711426}) -- Entrada
end}

local b2ktower_saida = {}
b2ktower_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{210.80752563477,-924.90960693359,30.692022323608}) -- Saida
end}

local sicimembros_entrada = {}
sicimembros_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-2679.6118164062,1315.1262207032,147.44288635254}) -- Entrada
end}

local sicimembros_saida = {}
sicimembros_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-2678.5578613282,1307.7283935546,147.16165161132}) -- Saida
end}

-- Prisao
local pripatio_entrada = {}
pripatio_entrada["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{1712.1800537109,2565.8725585938,45.564868927002}) -- Entrada
end}

local pripatio_saida = {}
pripatio_saida["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{1724.8452148438,2648.7521972656,45.784439086914}) -- Saida
end}

local priacad_entrada = {}
priacad_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{1642.4438476562,2518.6975097656,45.56485748291}) -- Entrada
end}

local priacad_saida = {}
priacad_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{1644.2642822266,2518.2768554688,45.56485748291}) -- Saida
end}

local yazukamem_entrada = {}
yazukamem_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-874.87939453125,-1454.2927246094,7.5268068313599}) -- Entrada
end}

local yazukamem_saida = {}
yazukamem_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-876.830078125,-1454.7742919922,7.5267992019653}) -- Saida
end}

local siciarmas_entrada = {}
siciarmas_entrada["Entrar"] = {function(player,choice)
    vRPclient.teleport(player,{-2673.2407226563,1336.4757080078,140.88262939453}) -- Entrada
end}

local siciarmas_saida = {}
siciarmas_saida["Sair"] = {function(player,choice)
    vRPclient.teleport(player,{-2679.6271972656,1319.2336425781,152.00950622559}) -- Saida
end}

--loot corpse cooldown
local loot_corpse_cd = {}
function lootCorpseCooldown()
  for user_id,cd in pairs(loot_corpse_cd) do
    if cd > 0 then
      loot_corpse_cd[user_id] = cd - 1
	end
  end
  SetTimeout(1000,function()
	lootCorpseCooldown()
  end)
end
lootCorpseCooldown()

--loot corpse
local choice_loot = {function(player,choice)
  local user_id = vRP.getUserId({player})
    if (loot_corpse_cd[user_id] == nil or loot_corpse_cd[user_id] == 0) and user_id ~= nil then
	loot_corpse_cd[user_id] = 40
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      local nuser_id = vRP.getUserId({nplayer})
      if nuser_id ~= nil then
        vRPclient.isInComa(nplayer,{}, function(in_coma)
          if in_coma then
    			local revive_seq = {
    			  {"amb@medic@standing@kneel@enter","enter",1},
    			  {"amb@medic@standing@kneel@idle_a","idle_a",1},
    			  {"amb@medic@standing@kneel@exit","exit",1}
    			}
  			vRPclient.playAnim(player,{false,revive_seq,false}) -- anim
  			vRPclient.notify(player,{"~w~Roubando corpo, aguarde o término."})
  			TriggerEvent("b2k:storeWeapons", nplayer)
            SetTimeout(25000, function()
			  local npl = nil
			  vRPclient.playerIsNearOtherPlayer(player,{nplayer,2}, function(result)
			    if result then
				  local ndata = vRP.getUserDataTable({nuser_id})
				  if ndata ~= nil then
					if ndata.inventory ~= nil then -- gives inventory items
					  vRP.clearInventory({nuser_id})
					  for k,v in pairs(ndata.inventory) do 
						vRP.giveInventoryItem({user_id,k,v.amount,true})
						
						if string.match(k, "wbody") then
							vRPbm.logInfoToFile("lootWeaponsLog.txt","De: "..user_id.." - Para: "..nuser_id.." - Item: " .. ""..k .." - Amount: " .. v.amount)
						end
						
						if string.match(k, "wammo") then
							vRPbm.logInfoToFile("lootWeaponsLog.txt","De: "..user_id.." - Para: "..nuser_id.." - Item: " .. ""..k .." - Amount: " .. v.amount)
						end
						
					  end
					end
				  end
				  local nmoney = vRP.getMoney({nuser_id})
				  if vRP.tryPayment({nuser_id,nmoney}) then
					vRP.giveMoney({user_id,nmoney})
				  end
				  
				  loot_corpse_cd[user_id] = 0
				  npl = nplayer
			    else
				  npl = nil
				  loot_corpse_cd[user_id] = 120
				  vRPclient.notify(player,{"~r~Você ficou longe do corpo, Roubo cancelado."})
			    end
			  end)
            end)
			     vRPclient.stopAnim(player,{false})
          else
            vRPclient.notify(player,{lang.emergency.menu.revive.not_in_coma()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  else
	-- aguaurde 120 segundos para usar o comando saquear novamente
	vRPclient.notify(player,{"~r~Aguarde 120s para tentar Saquear novamente."})
  end
end,"Rouba jogador mais próximo em coma."}

--hack cooldown
local hack_cd = {}
function hackCooldown()
  for user_id,cd in pairs(hack_cd) do
    if cd > 0 then
      hack_cd[user_id] = cd - 1
    end
  end
  SetTimeout(1000,function()
    hackCooldown()
  end)
end
hackCooldown()
-- hack player
local ch_hack = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if (hack_cd[user_id] == nil or hack_cd[user_id] == 0) and user_id ~= nil then
    hack_cd[user_id] = 2
    vRPclient.getNearestPlayer(player,{25},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nbank = vRP.getBankMoney({nuser_id})
          local amount = math.floor(nbank*0.01)
		  local nvalue = nbank - amount
		  if math.random(1,100) == 1 then
        vRP.setBankMoney({nuser_id,nvalue})
        vRPclient.notify(nplayer,{"Hackeado R$".. amount .."."})
        vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
        vRPbm.logInfoToFile("hacker.txt",user_id .. " hackeou "..nuser_id.." e ganhou " .. amount .. " de dinheiro sujo")

		  else
            vRPclient.notify(nplayer,{"Falha na tentativa de Hackear."})
            vRPclient.notify(player,{"Falha na tentativa de Hackear."})
		  end
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  else
  -- aguaurde 120 segundos para usar o comando saquear novamente
  vRPclient.notify(player,{"~r~Aguarde 2s para tentar Hackear novamente."})
  end
end,"Hackeia jogador mais próximo."}

-- mug player
local ch_mug = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
          -- prompt number
		  local nmoney = vRP.getMoney({nuser_id})
          local amount = nmoney
		  if math.random(1,3) == 1 then
            if vRP.tryPayment({nuser_id,amount}) then
              vRPclient.notify(nplayer,{"Mugged "..amount.."$."})
		      vRP.giveInventoryItem({user_id,"dirty_money",amount,true})
            else
              vRPclient.notify(player,{lang.money.not_enough()})
            end
		  else
            vRPclient.notify(nplayer,{"Mugging attempt failed."})
            vRPclient.notify(player,{"Mugging attempt failed."})
		  end
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Mug closest player."}

-- drag player
local ch_drag = {function(player,choice)
  -- get nearest player
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    vRPclient.getNearestPlayer(player,{10},function(nplayer)
      if nplayer ~= nil then
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
		  vRPclient.isHandcuffed(nplayer,{},function(handcuffed)
			if handcuffed then
				TriggerClientEvent("dr:drag", nplayer, player)
			else
				vRPclient.notify(player,{"O jogador não está algemado."})
			end
		  end)
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      else
        vRPclient.notify(player,{lang.common.no_player_near()})
      end
    end)
  end
end, "Arrasta um jogador próximo."}

-- player check
local choice_player_check = {function(player,choice)
  vRPclient.getNearestPlayer(player,{5},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then
      vRPclient.notify(nplayer,{lang.police.menu.check.checked()})
      vRPclient.getWeapons(nplayer,{},function(weapons)
        -- prepare display data (money, items, weapons)
        local money = vRP.getMoney({nuser_id})
        local items = ""
        local data = vRP.getUserDataTable({nuser_id})
        if data and data.inventory then
          for k,v in pairs(data.inventory) do
            local item_name = vRP.getItemName({k})
            if item_name then
              items = items.."<br />"..item_name.." ("..v.amount..")"
            end
          end
        end

        local weapons_info = ""
        for k,v in pairs(weapons) do
          weapons_info = weapons_info.."<br />"..k.." ("..v.ammo..")"
        end

        vRPclient.setDiv(player,{"police_check",".div_police_check{ background-color: rgba(0,0,0,0.75); color: white; font-weight: bold; width: 500px; padding: 10px; margin: auto; margin-top: 150px; }",lang.police.menu.check.info({money,items,weapons_info})})
        -- request to hide div
        vRP.request({player, lang.police.menu.check.request_hide(), 1000, function(player,ok)
          vRPclient.removeDiv(player,{"police_check"})
        end})
      end)
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, lang.police.menu.check.description()}

-- player store weapons
local store_weapons_cd = {}
function storeWeaponsCooldown()
  for user_id,cd in pairs(store_weapons_cd) do
    if cd > 0 then
      store_weapons_cd[user_id] = cd - 1
	end
  end
  SetTimeout(1000,function()
	storeWeaponsCooldown()
  end)
end
storeWeaponsCooldown()
local choice_store_weapons = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if (store_weapons_cd[user_id] == nil or store_weapons_cd[user_id] == 0) and user_id ~= nil then
    store_weapons_cd[user_id] = 5
    vRPclient.getWeapons(player,{},function(weapons)
      for k,v in pairs(weapons) do
        -- convert weapons to parametric weapon items\
		
        vRP.giveInventoryItem({user_id, "wbody|"..k, 1, true})
        if v.ammo > 0 then
          vRP.giveInventoryItem({user_id, "wammo|"..k, v.ammo, true})
        end
      end
      -- clear all weapons
      vRPclient.giveWeapons(player,{{},true})
    end)
  else
    vRPclient.notify(player,{"Você já está guardando suas Armas."})
  end
end, lang.police.menu.store_weapons.description()}

RegisterServerEvent("b2k:storeWeapons")
AddEventHandler("b2k:storeWeapons", function(player)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    store_weapons_cd[user_id] = 5
    vRPclient.getWeapons(player,{},function(weapons)
      for k,v in pairs(weapons) do
        -- convert weapons to parametric weapon items\
		
        vRP.giveInventoryItem({user_id, "wbody|"..k, 1, true})
        if v.ammo > 0 then
          vRP.giveInventoryItem({user_id, "wammo|"..k, v.ammo, true})
        end
      end
      -- clear all weapons
      vRPclient.giveWeapons(player,{{},true})
    end)
  else
    vRPclient.notify(player,{"Você já está guardando suas Armas."})
  end
end)

-- armor item
vRP.defInventoryItem({"body_armor","Colete","Colete a prova de balas.",
function(args)
  local choices = {}

  choices["Equip"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
      if vRP.tryGetInventoryItem({user_id, "body_armor", 1, true}) then
        BMclient.setArmour(player,{100,true})
        vRP.closeMenu({player})
      end
    end
  end}

  return choices
end,
5.00,"Ilegal: <span class='ilegal-item'>Colete</span>"})

-- store armor
local store_armor_cd = {}
function storeArmorCooldown()
  for user_id,cd in pairs(store_armor_cd) do
    if cd > 0 then
      store_armor_cd[user_id] = cd - 1
	end
  end
  SetTimeout(1000,function()
	storeArmorCooldown()
  end)
end
storeArmorCooldown()

local choice_store_armor = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if (store_armor_cd[user_id] == nil or store_armor_cd[user_id] == 0) and user_id ~= nil then
    store_armor_cd[user_id] = 5
    BMclient.getArmour(player,{},function(armour)
      if armour > 95 then
        vRP.giveInventoryItem({user_id, "body_armor", 1, true})
        -- clear armor
	    BMclient.setArmour(player,{0,false})
	  else
	    vRPclient.notify(player, {"Colete danificado não pode ser guardado!"})
      end
    end)
  else
    vRPclient.notify(player,{"Você já está guardando seu Colete."})
  end
end, "Guarda colete intacto no inventário."}

local choice_trash_armor = {function(player, choice)
  local user_id = vRP.getUserId({player})
  if (store_armor_cd[user_id] == nil or store_armor_cd[user_id] == 0) and user_id ~= nil then
    store_armor_cd[user_id] = 5
    BMclient.getArmour(player,{},function(armour)
      if armour > 1 then
        -- clear armor
        BMclient.setArmour(player,{0,false})
      end
    end)
  else
    vRPclient.notify(player,{"Você já está jogando fora seu Colete."})
  end
end, "Joga o colete atual fora."}

local unjailed = {}
function jail_clock(target_id,timer)
  local target = vRP.getUserSource({tonumber(target_id)})
  local users = vRP.getUsers({})
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer>0 then
	   vRPclient.notify(target, {"Tempo Restante: " .. timer .. " minuto(s)."})
      vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(timer)})
  	  SetTimeout(60*1000, function()
  		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
  		  if v == tonumber(target_id) then
  	        unjailed[v] = nil
  		    timer = 0
  		  end
  		end
  		vRP.setHunger({tonumber(target_id), 0})
  		vRP.setThirst({tonumber(target_id), 0})
      vRPclient.setHealth(target, {400})
      checkPrisonXYZ(target)
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
  	  BMclient.loadFreeze(target,{false,true,true})
  	  SetTimeout(15000,function()
  		  BMclient.loadFreeze(target,{false,false,false})
  	  end)
  	  vRPclient.teleport(target,{1828.4290771484,2608.3032226563,45.588775634766}) -- teleport to outside jail
  	  vRPclient.setHandcuffed(target,{false})
      vRPclient.notify(target,{"Você foi libertado."})
  	  vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(-1)})
    end
  end
end

function checkPrisonXYZ(player)
  Citizen.CreateThread(function()
    vRPclient.playerIsNearCoords(player,{1712.1800537109,2565.8725585938,45.564868927002,200},function(result)
      if not result then
        vRPclient.teleport(player,{1712.1800537109,2565.8725585938,45.564868927002}) -- teleport to inside jail
        vRPclient.notify(player,{"Você foi visto por um Policial."})
      end
    end)
  end)
end      

function jail_clock_antirp(target_id,timer)
  local target = vRP.getUserSource({tonumber(target_id)})
  local users = vRP.getUsers({})
  local online = false
  for k,v in pairs(users) do
  if tonumber(k) == tonumber(target_id) then
    online = true
  end
  end
  if online then
    if timer>0 then
     vRPclient.notify(target, {"Tempo Restante: " .. timer .. " minuto(s)."})
      vRP.setUData({tonumber(target_id),"vRP:antirp:time",json.encode(timer)})
      SetTimeout(60*1000, function()
      for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
        if v == tonumber(target_id) then
            unjailed[v] = nil
          timer = 0
        end
      end
      vRP.setHunger({tonumber(target_id), 0})
      vRP.setThirst({tonumber(target_id), 0})
      vRPclient.setHealth(target, {400})
      jail_clock_antirp(tonumber(target_id),timer-1)
    end) 
    else 
      BMclient.loadFreeze(target,{false,true,true})
      SetTimeout(15000,function()
        BMclient.loadFreeze(target,{false,false,false})
      end)
      vRPclient.teleport(target,{1828.4290771484,2608.3032226563,45.588775634766}) -- teleport to outside jail
      vRPclient.setHandcuffed(target,{false})
      vRPclient.notify(target,{"Você foi libertado."})
      vRP.setUData({tonumber(target_id),"vRP:antirp:time",json.encode(-1)})
    end
  end
end



-- dynamic jail
local ch_jail = {function(player,choice) 
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
	          local target = vRP.getUserSource({tonumber(target_id)})
			  if target ~= nil then
		        if tonumber(jail_time) > 120 then
  			      jail_time = 120
		        end
		        if tonumber(jail_time) < 1 then
		          jail_time = 1
		        end
		  
                vRPclient.isHandcuffed(target,{}, function(handcuffed)  
                  if handcuffed then 
					BMclient.loadFreeze(target,{false,true,true})
					SetTimeout(20000,function()
					  BMclient.loadFreeze(target,{false,false,false})
            vRPclient.setHandcuffed(target,{false})
					end)
					TriggerClientEvent('chatMessage', -1, 'PRISÃO', { 0, 0, 0 }, '^2O ^3'.. vRP.getPlayerName({target}) ..' ^2foi preso(a) e condenado(a) por ^3'.. jail_time ..' ^2ano(s).')
				    --vRPclient.teleport(target,{1687.7401123047,2518.5849609375,-120.84125518799}) -- teleport to inside jail
            local selectedRoom = jailRooms[math.random(1, #jailRooms)]
            vRPclient.teleport(target,{selectedRoom.x,selectedRoom.y,selectedRoom.z}) -- teleport to inside jail
				    vRPclient.notify(target,{"~r~Você foi enviado para a prisão."})
				    vRPclient.notify(player,{"~b~Você enviou um jogador para a prisão."})
				    vRP.setHunger({tonumber(target_id),0})
				    vRP.setThirst({tonumber(target_id),0})
            vRPclient.setHealth(target, {400})
				    jail_clock(tonumber(target_id),tonumber(jail_time))
            local user_id = vRP.getUserId({player})
            vRPbm.logInfoToFile("jailLog.txt",user_id .. " jailed "..target_id.." for " .. jail_time .. " minutes")
			      else
				      vRPclient.notify(player,{"O jogador não está algemado."})
			      end
			    end)
			  else
				vRPclient.notify(player,{"Esse ID parece inválido."})
			  end
			else
			  vRPclient.notify(player,{"Tempo de Prisão não pode estar vazio."})
			end
	      end})
        else
          vRPclient.notify(player,{"Nenhum ID de jogador selecionado."})
        end 
	  end})
    else
      vRPclient.notify(player,{"Nenhum jogador por perto."})
    end 
  end)
end,"Envia um jogador próximo para Prisão."}

-- antirp
-- dynamic jail
local ch_jail_antirp = {function(player,choice) 
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
            local target = vRP.getUserSource({tonumber(target_id)})
        if target ~= nil then
            if tonumber(jail_time) > 120 then
              jail_time = 120
            end
            if tonumber(jail_time) < 1 then
              jail_time = 1
            end
      
                vRPclient.isHandcuffed(target,{}, function(handcuffed)  
                  if handcuffed then 
          BMclient.loadFreeze(target,{false,true,true})
          SetTimeout(20000,function()
            BMclient.loadFreeze(target,{false,false,false})
          end)
            TriggerClientEvent('chatMessage', -1, 'PRISÃO', { 0, 0, 0 }, '^2O ^3'.. vRP.getPlayerName({target}) ..' ^2foi preso(a) por conduta Anti-RP: ^3'.. jail_time ..' ^2ano(s).')
            vRPclient.setHandcuffed(target,{true})
            vRPclient.teleport(target,{-1055.8697509766,3813.2604980469,183.98435974121}) -- teleport to inside jail
            vRPclient.notify(target,{"~r~Você foi enviado para a prisão."})
            vRPclient.notify(player,{"~b~Você enviou um jogador para a prisão."})
            vRP.setHunger({tonumber(target_id),0})
            vRP.setThirst({tonumber(target_id),0})
            vRPclient.setHealth(target, {400})
            jail_clock_antirp(tonumber(target_id),tonumber(jail_time))
            local user_id = vRP.getUserId({player})
            vRPbm.logInfoToFile("jailLogAntiRP.txt",user_id .. " jailed "..target_id.." for " .. jail_time .. " minutes")
            else
              vRPclient.notify(player,{"O jogador não está algemado."})
            end
          end)
        else
        vRPclient.notify(player,{"Esse ID parece inválido."})
        end
      else
        vRPclient.notify(player,{"Tempo de Prisão não pode estar vazio."})
      end
        end})
        else
          vRPclient.notify(player,{"Nenhum ID de jogador selecionado."})
        end 
    end})
    else
      vRPclient.notify(player,{"Nenhum jogador por perto."})
    end 
  end)
end,"Envia um jogador próximo para Prisão."}

-- dynamic unjail
local ch_unjail = {function(player,choice) 
	vRP.prompt({player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		vRP.getUData({tonumber(target_id),"vRP:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = vRP.getUserId({player})
			  if tonumber(custom) > 0 or vRP.hasPermission({user_id,"admin.easy_unjail"}) then
	            local target = vRP.getUserSource({tonumber(target_id)})
				if target ~= nil then
	              unjailed[target] = tonumber(target_id)
				  vRPclient.notify(player,{"O Jogador será libertado em breve."})
				  vRPclient.notify(target,{"Alguém diminuiu sua sentença."})
				  vRPbm.logInfoToFile("jailLog.txt",user_id .. " freed "..target_id.." from a " .. custom .. " minutes sentence")
				else
				  vRPclient.notify(player,{"Esse ID parece inválido."})
				end
			  else
				vRPclient.notify(player,{"Jogador não está cumprindo sentença."})
			  end
			end
		  end
		end})
      else
        vRPclient.notify(player,{"Nenhum ID de jogador selecionado."})
      end 
	end})
end,"Liberta um jogador preso."}

-- (server) called when a logged player spawn to check for vRP:jail in user_data
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn) 
  local target = vRP.getUserSource({user_id})
  SetTimeout(35000,function()
    local custom = {}
    vRP.getUData({user_id,"vRP:jail:time",function(value)
  	  if value ~= nil then
  	    custom = json.decode(value)
  	    if custom ~= nil then
  		  if tonumber(custom) > 0 then
    			BMclient.loadFreeze(target,{false,true,true})
          vRPclient.setHandcuffed(target,{true})
    			SetTimeout(15000,function()
    			  BMclient.loadFreeze(target,{false,false,false})
            vRPclient.setHandcuffed(target,{false})
    			end)
              --vRPclient.teleport(target,{1687.7401123047,2518.5849609375,-120.84125518799}) -- teleport inside jail
              local selectedRoom = jailRooms[math.random(1, #jailRooms)]
              vRPclient.teleport(target,{selectedRoom.x,selectedRoom.y,selectedRoom.z}) -- teleport to inside jail
              vRPclient.notify(target,{"Termine sua sentença."})
        			vRP.setHunger({tonumber(user_id),0})
        			vRP.setThirst({tonumber(user_id),0})
        			vRPbm.logInfoToFile("jailLog.txt",user_id.." has been sent back to jail for " .. custom .. " minutes to complete his sentence")
              jail_clock(tonumber(user_id),tonumber(custom))
  		    end
  	    end
      end
      vRP.getUData({user_id,"vRP:antirp:time",function(value)
        if value ~= nil then
          custom = json.decode(value)
          if custom ~= nil then
          if tonumber(custom) > 0 then
            BMclient.loadFreeze(target,{false,true,true})
            vRPclient.setHandcuffed(target,{true})
            SetTimeout(15000,function()
              BMclient.loadFreeze(target,{false,false,false})
            end)
                vRPclient.teleport(target,{-1055.8697509766,3813.2604980469,183.98435974121}) -- teleport inside jail
                vRPclient.notify(target,{"Termine sua sentença."})
                vRP.setHunger({tonumber(user_id),0})
                vRP.setThirst({tonumber(user_id),0})
                vRPbm.logInfoToFile("jailLogAntiRP.txt",user_id.." has been sent back to jail for " .. custom .. " minutes to complete his sentence")
                jail_clock_antirp(tonumber(user_id),tonumber(custom))
            end
          end
        end
      end})
    end})
  end)
end)

-- dynamic fine
local ch_fine = {function(player,choice) 
  vRPclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
	if user_list ~= "" then
	  vRP.prompt({player,"Jogadores Próximos:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      vRP.prompt({player,"Valor da Multa:","1",function(player,fine)
			if fine ~= nil and fine ~= "" then 
	          vRP.prompt({player,"Motivo da Multa:","",function(player,reason)
			    if reason ~= nil and reason ~= "" then 
	              local target = vRP.getUserSource({tonumber(target_id)})
				  if target ~= nil then
		            if tonumber(fine) > 100000 then
  			          fine = 100000
		            end
		            if tonumber(fine) < 1 then
		              fine = 1
		            end
			  
		            if vRP.tryFullPayment({tonumber(target_id), tonumber(fine)}) then
                      vRP.insertPoliceRecord({tonumber(target_id), lang.police.menu.fine.record({reason,fine})})
                      vRPclient.notify(player,{lang.police.menu.fine.fined({reason,fine})})
                      vRPclient.notify(target,{lang.police.menu.fine.notify_fined({reason,fine})})
          					  local user_id = vRP.getUserId({player})
          					  vRPbm.logInfoToFile("fineLog.txt",user_id .. " fined "..target_id.." the amount of " .. fine .. " for ".. reason)
                      vRP.closeMenu({player})
                    else
                      vRPclient.notify(player,{lang.money.not_enough()})
                    end
				  else
					vRPclient.notify(player,{"Esse ID parece inválido."})
				  end
				else
				  vRPclient.notify(player,{"Você não pode multar sem motivo."})
				end
	          end})
			else
			  vRPclient.notify(player,{"Sua multa tem que ter um valor."})
			end
	      end})
        else
          vRPclient.notify(player,{"Nenhum ID de jogador selecionado."})
        end 
	  end})
    else
      vRPclient.notify(player,{"Nenhum jogador por perto."})
    end 
  end)
end,"Multa um jogador próximo."}

-- improved handcuff
local ch_handcuff = {function(player,choice)
  vRPclient.getNearestPlayer(player,{4},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then
      vRPclient.toggleHandcuff(nplayer,{})
	  local user_id = vRP.getUserId({player})
	  vRPbm.logInfoToFile("jailLog.txt",user_id .. " cuffed "..nuser_id)
      vRP.closeMenu({nplayer})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end,lang.police.menu.handcuff.description()}

-- admin god mode
local gods = {}
function task_god()
  SetTimeout(10000, task_god)

  for k,v in pairs(gods) do
    vRP.setHunger({v, 0})
    vRP.setThirst({v, 0})

    local player = vRP.getUserSource({v})
    if player ~= nil then
      vRPclient.setHealth(player, {400})
    end
  end
end
task_god()

function clear_task_god()
	SetTimeout(1000*60*30, clear_task_god)
	gods = {}
end
clear_task_god()

local ch_godmode = {function(player,choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Godmode** \n```\nAdmin ID: "..user_id.." Godmode```")
    if gods[player] then
	  gods[player] = nil
	  vRPclient.notify(player,{"Godmode desativado."})
	else
	  gods[player] = user_id
	  vRPclient.notify(player,{"Godmode ativado."})
	end
  end
end, "Toggles admin godmode."}

local player_lists = {}
local ch_userlist = {function(player,choice)
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    if player_lists[player] then -- hide
      player_lists[player] = nil
      vRPclient.removeDiv(player,{"user_list"})
    else -- show
      local content = "<span class=\"id\">ID</span><span class=\"pseudo\">NICKNAME</span><span class=\"name\">ROLEPLAY NAME</span><span class=\"job\">PROFESSION</span>"
      local count = 0
	  local users = vRP.getUsers({})
      for k,v in pairs(users) do
        count = count+1
        local source = vRP.getUserSource({k})
        vRP.getUserIdentity({k, function(identity)
		  if source ~= nil then
            content = content.."<br /><span class=\"id\">"..k.."</span><span class=\"pseudo\">"..vRP.getPlayerName({source}).."</span>"
            if identity then
              content = content.."<span class=\"name\">"..htmlEntities.encode(identity.nome).." "..htmlEntities.encode(identity.sobrenome).."</span><span class=\"job\">"..vRP.getUserGroupByType({k,"job"}).."</span>"
            end
          end
		  
          -- check end
          count = count-1
          if count == 0 then
            player_lists[player] = true
            local css = [[
              .div_user_list{ 
                margin: auto; 
				text-align: left;
                padding: 8px; 
                width: 650px; 
                margin-top: 100px; 
                background: rgba(50,50,50,0.0); 
                color: white; 
                font-weight: bold; 
                font-size: 1.1em;
              } 
              .div_user_list span{ 
				display: inline-block;
				text-align: center;
              } 
              .div_user_list .id{ 
                color: rgb(255, 255, 255);
                width: 45px; 
              }
              .div_user_list .pseudo{ 
                color: rgb(66, 244, 107);
                width: 145px; 
              }
              .div_user_list .name{ 
                color: rgb(92, 170, 249);
                width: 295px; 
              }
			  .div_user_list .job{ 
                color: rgb(247, 193, 93);
                width: 145px; 
			  }
            ]]
            vRPclient.setDiv(player,{"user_list", css, content})
          end
		end})
      end
    end
  end
end, "Toggles Userlist."}

function vRPbm.chargePhoneNumber(user_id,phone)
  local player = vRP.getUserSource({user_id})
  local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  vRP.prompt({player,"Amount to be charged to "..directory_name..":","0",function(player,charge)
	if charge ~= nil and charge ~= "" and tonumber(charge)>0 then 
	  vRP.getUserByPhone({phone, function(target_id)
		if target_id~=nil then
			if charge ~= nil and charge ~= "" then 
	          local target = vRP.getUserSource({target_id})
			  if target ~= nil then
				vRP.getUserIdentity({user_id, function(identity)
				  local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
				  if my_directory_name == "unknown" then
				    my_directory_name = identity.phone
				  end
			      local text = "" .. my_directory_name .. " is charging you $" .. charge .. " for his services."
				  vRP.request({target,text,600,function(req_player,ok)
				    if ok then
					  local target_bank = vRP.getBankMoney({target_id}) - tonumber(charge)
					  local my_bank = vRP.getBankMoney({user_id}) + tonumber(charge)
		              if target_bank>0 then
					    vRP.setBankMoney({user_id,my_bank})
					    vRP.setBankMoney({target_id,target_bank})
					    vRPclient.notify(player,{"You charged ~y~$"..charge.." from "..directory_name .." for your services."})
						vRPclient.notify(target,{""..my_directory_name.." charged you $"..charge.." for his services."})
					    vRPbm.logInfoToFile("mchargeLog.txt",user_id .. " mobile charged "..target_id.." the amount of " .. charge .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..user_id.." equals $"..target_bank)
					    vRP.closeMenu({player})
                      else
                        vRPclient.notify(target,{lang.money.not_enough()})
                        vRPclient.notify(player,{"" .. directory_name .. " tried to, but can't pay for your services."})
                      end
				    else
                      vRPclient.notify(player,{"" .. directory_name .. " refused to pay for your services."})
				    end
				  end})
				end})
			  else
			    vRPclient.notify(player,{"You can't make charges to offline players."})
			  end
			else
			  vRPclient.notify(player,{"Your charge has to have a value."})
			end
		else
		  vRPclient.notify(player,{"That phone number seems invalid."})
		end
	  end})
	else
	  vRPclient.notify(player,{"The value has to be bigger than 0."})
	end
  end})
end

function vRPbm.payPhoneNumber(user_id,phone)
  local player = vRP.getUserSource({user_id})
  local directory_name = vRP.getPhoneDirectoryName({user_id, phone})
  if directory_name == "unknown" then
	directory_name = phone
  end
  vRP.prompt({player,"Amount to be sent to "..directory_name..":","0",function(player,transfer)
	if transfer ~= nil and transfer ~= "" and tonumber(transfer)>0 then 
	  vRP.getUserByPhone({phone, function(target_id)
	    local my_bank = vRP.getBankMoney({user_id}) - tonumber(transfer)
		if target_id~=nil then
          if my_bank >= 0 then
		    local target = vRP.getUserSource({target_id})
			if target ~= nil then
			  vRP.setBankMoney({user_id,my_bank})
              vRPclient.notify(player,{"You tranfered $"..transfer.." to "..directory_name})
			  local target_bank = vRP.getBankMoney({target_id}) + tonumber(transfer)
			  vRP.setBankMoney({target_id,target_bank})
			  vRPbm.logInfoToFile("mpayLog.txt",user_id .. " mobile paid "..target_id.." the amount of " .. transfer .. ", user bank post-payment for "..user_id.." equals $"..my_bank.." and for "..target_id.." equals $"..target_bank)
			  vRP.getUserIdentity({user_id, function(identity)
		        local my_directory_name = vRP.getPhoneDirectoryName({target_id, identity.phone})
			    if my_directory_name == "unknown" then
		          my_directory_name = identity.phone
			    end
                vRPclient.notify(target,{"You received ~y~$"..transfer.." from "..my_directory_name})
			  end})
              vRP.closeMenu({player})
			else
			  vRPclient.notify(player,{"You can't make payments to offline players."})
			end
          else
            vRPclient.notify(player,{lang.money.not_enough()})
          end
		else
		  vRPclient.notify(player,{"That phone number seems invalid."})
		end
	  end})
	else
	  vRPclient.notify(player,{"The value has to be bigger than 0."})
	end
  end})
end

-- mobilepay
local ch_mobilepay = {function(player,choice) 
	local user_id = vRP.getUserId({player})
	local menu = {}
	menu.name = lang.phone.directory.title()
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
	menu["> Digitar Telefone"] = {
	  -- payment function
	  function(player,choice) 
	    vRP.prompt({player,"Telefone:","0000-0000",function(player,phone)
	      if phone ~= nil and phone ~= "" then 
		    vRPbm.payPhoneNumber(user_id,phone)
		  else
		    vRPclient.notify(player,{"Voce tem que digitar um numero de telefone."})
		  end
	    end})
	  end,"Digite o número do telefone manualmente."}
	local directory = vRP.getPhoneDirectory({user_id})
	for k,v in pairs(directory) do
	  menu[k] = {
	    -- payment function
	    function(player,choice) 
		  vRPbm.payPhoneNumber(user_id,v)
	    end
	  ,v} -- number as description
	end
	vRP.openMenu({player, menu})
end,"Envia dinheiro pelo telefone."}

-- mobilecharge
local ch_mobilecharge = {function(player,choice) 
	local user_id = vRP.getUserId({player})
	local menu = {}
	menu.name = lang.phone.directory.title()
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
	menu["> Digitar Telefone"] = {
	  -- payment function
	  function(player,choice) 
	    vRP.prompt({player,"Telefone:","0000-0000",function(player,phone)
	      if phone ~= nil and phone ~= "" then 
		    vRPbm.chargePhoneNumber(user_id,phone)
		  else
		    vRPclient.notify(player,{"Voce tem que digitar um numero de telefone."})
		  end
	    end})
	  end,"Digite o número do telefone manualmente."}
	local directory = vRP.getPhoneDirectory({user_id})
	for k,v in pairs(directory) do
	  menu[k] = {
	    -- payment function
	    function(player,choice) 
		  vRPbm.chargePhoneNumber(user_id,v)
	    end
	  ,v} -- number as description
	end
	vRP.openMenu({player, menu})
end,"Receba dinheiro pelo telefone."}

-- spawn vehicle
local ch_spawnveh = {function(player,choice) 
	vRP.prompt({player,"Vehicle Model:","",function(player,model)
	  if model ~= nil and model ~= "" then 
		SendWebhookMessage(ac_webhook_gameplay, "**Spawn Car** \n```\nUser: "..GetPlayerName(player).." Model: "..model.."```")
	    BMclient.spawnVehicle(player,{model})
	  else
		vRPclient.notify(player,{"You have to type a vehicle model."})
	  end
	end})
end,"Spawn a vehicle model."}

-- lockpick vehicle
local ch_lockpickveh = {function(player,choice) 
	BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
end,"Lockpick closest vehicle."}

-- dynamic freeze
local ch_freeze = {function(player,choice) 
	local user_id = vRP.getUserId({player})
	if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
	  vRP.prompt({player,"Player ID:","",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      local target = vRP.getUserSource({tonumber(target_id)})
		  if target ~= nil then
		    vRPclient.notify(player,{"You un/froze that player."})
		    BMclient.loadFreeze(target,{true,true,true})
		  else
		    vRPclient.notify(player,{"That ID seems invalid."})
		  end
        else
          vRPclient.notify(player,{"No player ID selected."})
        end 
	  end})
	else
	  vRPclient.getNearestPlayer(player,{10},function(nplayer)
        local nuser_id = vRP.getUserId({nplayer})
        if nuser_id ~= nil then
		  vRPclient.notify(player,{"You un/froze that player."})
		  BMclient.loadFreeze(nplayer,{true,false,false})
        else
          vRPclient.notify(player,{lang.common.no_player_near()})
        end
      end)
	end
end,"Freezes a player."}

-- lockpicking item
vRP.defInventoryItem({"lockpicking_kit","Lockpicking Kit","Used to lockpick vehicles.", -- add it for sale to vrp/cfg/markets.lua if you want to use it
function(args)
  local choices = {}

  choices["Lockpick"] = {function(player,choice)
    local user_id = vRP.getUserId({player})
    if user_id ~= nil then
      if vRP.tryGetInventoryItem({user_id, "lockpicking_kit", 1, true}) then
		BMclient.lockpickVehicle(player,{20,true}) -- 20s to lockpick, allow to carjack unlocked vehicles (has to be true for NoCarJack Compatibility)
        vRP.closeMenu({player})
      end
    end
  end,"Lockpick closest vehicle."}

  return choices
end,
5.00})

-- ADD STATIC MENU CHOICES // STATIC MENUS NEED TO BE ADDED AT vRP/cfg/gui.lua
vRP.addStaticMenuChoices({"police_weapons", police_weapons}) -- police gear
vRP.addStaticMenuChoices({"federal_weapons", federal_weapons}) -- police gear
vRP.addStaticMenuChoices({"emergency_medkit", emergency_medkit}) -- pills and medkits
vRP.addStaticMenuChoices({"emergency_heal", emergency_heal}) -- heal button
vRP.addStaticMenuChoices({"hospi_e", hospi_e})
vRP.addStaticMenuChoices({"hospi_s", hospi_s})
vRP.addStaticMenuChoices({"tribunal_e", tribunal_e})
vRP.addStaticMenuChoices({"tribunal_s", tribunal_s})
vRP.addStaticMenuChoices({"tribunal_lobbye", tribunal_lobbye})
vRP.addStaticMenuChoices({"tribunal_lobbys", tribunal_lobbys})
vRP.addStaticMenuChoices({"federal_entrada", federal_entrada})
vRP.addStaticMenuChoices({"federal_saida", federal_saida})
vRP.addStaticMenuChoices({"federal_entrada_heli", federal_entrada_heli})
vRP.addStaticMenuChoices({"federal_saida_heli", federal_saida_heli})
vRP.addStaticMenuChoices({"lavagem_entrada", lavagem_entrada})
vRP.addStaticMenuChoices({"lavagem_saida", lavagem_saida})
vRP.addStaticMenuChoices({"weed_entrada", weed_entrada})
vRP.addStaticMenuChoices({"weed_saida", weed_saida})
vRP.addStaticMenuChoices({"meth_entrada", meth_entrada})
vRP.addStaticMenuChoices({"meth_saida", meth_saida})
vRP.addStaticMenuChoices({"cocaine_entrada", cocaine_entrada})
vRP.addStaticMenuChoices({"cocaine_saida", cocaine_saida})
vRP.addStaticMenuChoices({"mina_entrada", mina_entrada})
vRP.addStaticMenuChoices({"mina_saida", mina_saida})
vRP.addStaticMenuChoices({"oab_entrada", oab_entrada})
vRP.addStaticMenuChoices({"oab_saida", oab_saida})
vRP.addStaticMenuChoices({"bahamas_entrada", bahamas_entrada})
vRP.addStaticMenuChoices({"bahamas_saida", bahamas_saida})
vRP.addStaticMenuChoices({"hospheli_entrada", hospheli_entrada})
vRP.addStaticMenuChoices({"hospheli_saida", hospheli_saida})
vRP.addStaticMenuChoices({"b2knewsheli_entrada", b2knewsheli_entrada})
vRP.addStaticMenuChoices({"b2knewsheli_saida", b2knewsheli_saida})
vRP.addStaticMenuChoices({"lsquarto01_entrada", lsquarto01_entrada})
vRP.addStaticMenuChoices({"lsquarto01_saida", lsquarto01_saida})
vRP.addStaticMenuChoices({"b2ktower_entrada", b2ktower_entrada})
vRP.addStaticMenuChoices({"b2ktower_saida", b2ktower_saida})
vRP.addStaticMenuChoices({"sicimembros_entrada", sicimembros_entrada})
vRP.addStaticMenuChoices({"sicimembros_saida", sicimembros_saida})
vRP.addStaticMenuChoices({"pripatio_entrada", pripatio_entrada})
vRP.addStaticMenuChoices({"pripatio_saida", pripatio_saida})
vRP.addStaticMenuChoices({"priacad_entrada", priacad_entrada})
vRP.addStaticMenuChoices({"priacad_saida", priacad_saida})
vRP.addStaticMenuChoices({"yazukamem_entrada", yazukamem_entrada})
vRP.addStaticMenuChoices({"yazukamem_saida", yazukamem_saida})
vRP.addStaticMenuChoices({"siciarmas_entrada", siciarmas_entrada})
vRP.addStaticMenuChoices({"siciarmas_saida", siciarmas_saida})


-- REMEMBER TO ADD THE PERMISSIONS FOR WHAT YOU WANT TO USE
-- CREATES PLAYER SUBMENU AND ADD CHOICES
local ch_player_menu = {function(player,choice)
	local user_id = vRP.getUserId({player})
	local menu = {}
	menu.name = "<img src='nui://vrp/gui/imgs/headset.png'/> Jogador"
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
	
	if vRP.hasPermission({user_id,"player.loot"}) then
      menu["<img src='nui://vrp/gui/imgs/thief.png'/> Roubar"] = choice_loot -- take the items of nearest player in coma
    end
	
	if vRP.hasPermission({user_id,"hacker.hack"}) then
      menu["<img src='nui://vrp/gui/imgs/thief.png'/> Hackear"] = ch_hack --  1 in 100 chance of stealing 1% of nearest player bank
    end
	
	if vRP.hasPermission({user_id,"toggle.service"}) then
      menu["<img src='nui://vrp/gui/imgs/emservico.png'/> On/Off Missões"] = choice_service -- toggle the receiving of missions
    end
	
    --if vRP.hasPermission({user_id,"player.store_money"}) then
    --  menu["Guardar Dinheiro"] = choice_store_money -- transforms money in wallet to money in inventory to be stored in houses and cars
    --end
	
    --if vRP.hasPermission({user_id,"player.fix_haircut"}) then
    --  menu["Desbugar Cabelo"] = ch_fixhair -- just a work around for barbershop green hair bug while I am busy
    --end
	
    --if vRP.hasPermission({user_id,"player.userlist"}) then
      --menu["User List"] = ch_userlist -- a user list for players with vRP ids, player name and identity names only.
    --end
	
    if vRP.hasPermission({user_id,"player.store_weapons"}) then
      menu["Armas: Guardar"] = choice_store_weapons -- store player weapons, like police store weapons from vrp
    end
	
    if vRP.hasPermission({user_id,"player.store_armor"}) then
      menu["Colete: Guardar"] = choice_store_armor -- store player armor
    end

    if vRP.hasPermission({user_id,"player.store_armor"}) then
      menu["Colete: Jogar Fora"] = choice_trash_armor -- store player armor
    end
	
    if vRP.hasPermission({user_id,"player.check"}) then
      menu["Revistar"] = choice_player_check -- checks nearest player inventory, like police check from vrp
    end
	
	vRP.openMenu({player, menu})
end}

local ch_comportamento_menu = {function(player,choice)
	local user_id = vRP.getUserId({player})
	local menu = {}
	menu.name = "<img src='nui://vrp/gui/imgs/man-dancing.png'/> Comportamento"
	menu.css = {top = "75px", header_color = "rgba(0,0,255,0.75)"}
    menu.onclose = function(player) vRP.openMainMenu({player}) end -- nest menu
	
	menu["> Limpar"] = {function(player,choice) BMclient.resetMovement(player,{false}) end}
	menu["Normal M"] = {function(player,choice) BMclient.playMovement(player, {"move_m@confident",true,true,false,false}) end}
  menu["Normal F"] = {function(player,choice) BMclient.playMovement(player, {"move_f@heels@c",true,true,false,false}) end}    
	menu["Depressivo"] = {function(player,choice) BMclient.playMovement(player, {"move_m@depressed@a",true,true,false,false}) end}	
	menu["Depressivo F"] = {function(player,choice) BMclient.playMovement(player, {"move_f@depressed@a",true,true,false,false}) end}	
	menu["Empresário"] = {function(player,choice) BMclient.playMovement(player, {"move_m@business@a",true,true,false,false}) end}	
	menu["Determinado"] = {function(player,choice) BMclient.playMovement(player, {"move_m@brave@a",true,true,false,false}) end}	
	menu["Casual"] = {function(player,choice) BMclient.playMovement(player, {"move_m@casual@a",true,true,false,false}) end}	
	menu["Gordo"] = {function(player,choice) BMclient.playMovement(player, {"move_m@fat@a",true,true,false,false}) end}	
	menu["Hipster"] = {function(player,choice) BMclient.playMovement(player, {"move_m@hipster@a",true,true,false,false}) end}	
	menu["Ferido"] = {function(player,choice) BMclient.playMovement(player, {"move_m@injured",true,true,false,false}) end}	
	menu["Nervoso"] = {function(player,choice) BMclient.playMovement(player, {"move_m@hurry@a",true,true,false,false}) end}
	menu["Vagabundo"] = {function(player,choice) BMclient.playMovement(player, {"move_m@hobo@a",true,true,false,false}) end}	
	menu["Infeliz"] = {function(player,choice) BMclient.playMovement(player, {"move_m@sad@a",true,true,false,false}) end}	
	menu["Musculoso"] = {function(player,choice) BMclient.playMovement(player, {"move_m@muscle@a",true,true,false,false}) end}
	menu["Sombrio"] = {function(player,choice) BMclient.playMovement(player, {"move_m@shadyped@a",true,true,false,false}) end}	
	menu["Fadiga"] = {function(player,choice) BMclient.playMovement(player, {"move_m@buzzed",true,true,false,false}) end}	
	menu["Prensado"] = {function(player,choice) BMclient.playMovement(player, {"move_m@hurry_butch@a",true,true,false,false}) end}	
	menu["Orgulhoso"] = {function(player,choice) BMclient.playMovement(player, {"move_m@money",true,true,false,false}) end}	
	menu["Corrida Curta"] = {function(player,choice) BMclient.playMovement(player, {"move_m@quick",true,true,false,false}) end}	
	menu["Comedor de homem"] = {function(player,choice) BMclient.playMovement(player, {"move_f@maneater",true,true,false,false}) end}	
	menu["Petulante"] = {function(player,choice) BMclient.playMovement(player, {"move_f@sassy",true,true,false,false}) end}
	menu["Arrogante"] = {function(player,choice) BMclient.playMovement(player, {"move_f@arrogant@a",true,true,false,false}) end}
	
	vRP.openMenu({player, menu})
end}

-- REGISTER MAIN MENU CHOICES
vRP.registerMenuBuilder({"main", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
    if vRP.hasPermission({user_id,"player.player_menu"}) then
      choices["<img src='nui://vrp/gui/imgs/headset.png'/> Jogador"] = ch_player_menu -- opens player submenu
    end

    if vRP.hasPermission({user_id,"mugger.mug"}) then
      choices["Mug"] = ch_mug -- steal nearest player wallet
    end
	
    if vRP.hasPermission({user_id,"carjacker.lockpick"}) then
      choices["Lockpick"] = ch_lockpickveh -- opens a locked vehicle
    end
	
	if vRP.hasPermission({user_id,"player.comportamento"}) then
      choices["<img src='nui://vrp/gui/imgs/man-dancing.png'/> Comportamento"] = ch_comportamento_menu -- opens player submenu
    end
	
    add(choices)
  end
end})

-- RESGISTER ADMIN MENU CHOICES
vRP.registerMenuBuilder({"admin", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
	if vRP.hasPermission({user_id,"admin.deleteveh"}) then
      choices["Car: Delete"] = ch_deleteveh -- Delete nearest vehicle (Fixed pull request https://github.com/Sighmir/vrp_basic_menu/pull/11/files/419405349ca0ad2a215df90cfcf656e7aa0f5e9c from benjatw)
	end
	
	if vRP.hasPermission({user_id,"admin.spawnveh"}) then
      choices["Car: SpawnVeh"] = ch_spawnveh -- Spawn a vehicle model
	end
	
	if vRP.hasPermission({user_id,"admin.godmode"}) then
      choices["Gameplay: Godmode"] = ch_godmode -- Toggles admin godmode (Disable the default admin.god permission to use this!) 
	end
	
    if vRP.hasPermission({user_id,"player.blips"}) then
      choices["Gameplay: Blips"] = ch_blips -- turn on map blips and sprites
    end
	
    if vRP.hasPermission({user_id,"player.sprites"}) then
      choices["Gameplay: Sprites"] = ch_sprites -- turn on only name sprites
    end
	
    if vRP.hasPermission({user_id,"admin.crun"}) then
      choices["Server: Crun"] = ch_crun -- run any client command, any GTA V client native http://www.dev-c.com/nativedb/
    end
	
    if vRP.hasPermission({user_id,"admin.srun"}) then
      choices["Server: Srun"] = ch_srun -- run any server command, any GTA V server native http://www.dev-c.com/nativedb/
    end

    if vRP.hasPermission({user_id,"admin.tptowaypoint"}) then
      choices["Gameplay: TpToWaypoint"] = choice_tptowaypoint -- teleport user to map blip
    end
	
    if vRP.hasPermission({user_id,"admin.easy_unjail"}) then
      choices["Gameplay: UnJail"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end
	
    if vRP.hasPermission({user_id,"admin.spikes"}) then
      choices["Gameplay: Spikes"] = ch_spikes -- Toggle spikes
    end
	
    if vRP.hasPermission({user_id,"admin.bm_freeze"}) then
      choices["Gameplay: Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER POLICE MENU CHOICES
vRP.registerMenuBuilder({"police", function(add, data)
  local user_id = vRP.getUserId({data.player})
  if user_id ~= nil then
    local choices = {}
	
    --if vRP.hasPermission({user_id,"police.store_money"}) then
    --  choices["Store money"] = choice_store_money -- transforms money in wallet to money in inventory to be stored in houses and cars
    --end
	
    if vRP.hasPermission({user_id,"police.base"}) then
      choices["Prender Tempo"] = ch_jail -- Send a nearby handcuffed player to jail with prompt for choice and user_list
    end

    if vRP.hasPermission({user_id,"police.base"}) then
      choices["Prender Anti-RP"] = ch_jail_antirp -- Send a nearby handcuffed player to jail with prompt for choice and user_list
    end

    if vRP.hasPermission({user_id,"police.oficial"}) then
      choices["Libertar Prisão"] = ch_unjail -- Un jails chosen player if he is jailed (Use admin.easy_unjail as permission to have this in admin menu working in non jailed players)
    end

    if vRP.hasPermission({user_id,"police.base"}) then
      choices["Multar"] = ch_fine -- Fines closeby player
    end
	
    if vRP.hasPermission({user_id,"police.base"}) then
      choices["Algemar/Desalgemar"] = ch_handcuff -- Toggle cuffs AND CLOSE MENU for nearby player
    end
	
	--if vRP.hasPermission({user_id,"police.spikes"}) then
    --  choices["Spikes"] = ch_spikes -- Toggle spikes
    --end
	
    if vRP.hasPermission({user_id,"police.base"}) then
      choices["Arrastar"] = ch_drag -- Drags closest handcuffed player
    end
	
	if vRP.hasPermission({user_id,"police.bm_freeze"}) then
      choices["Freeze"] = ch_freeze -- Toggle freeze
    end
	
    add(choices)
  end
end})

-- REGISTER PHONE MENU CHOICES
-- TO USE THIS FUNCTION YOU NEED TO HAVE THE ORIGINAL vRP UPDATED TO THE LASTEST VERSION
vRP.registerMenuBuilder({"phone", function(add) -- phone menu is created on server start, so it has no permissions.
	local choices = {} -- Comment the choices you want to disable by adding -- in front of them.

	choices["Mobile Pay"] = ch_mobilepay -- transfer money through phone
	--choices["Mobile Charge"] = ch_mobilecharge -- charge money through phone

	add(choices)
end})

Citizen.CreateThread(function()
	ac_webhook_joins = GetConvar("ac_webhook_joins", "none")
	ac_webhook_gameplay = GetConvar("ac_webhook_gameplay", "none")
	ac_webhook_bans = GetConvar("ac_webhook_bans", "none")
	ac_webhook_wl = GetConvar("ac_webhook_wl", "none")
	ac_webhook_arsenal = GetConvar("ac_webhook_arsenal", "none")

	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
		end
	end
end)