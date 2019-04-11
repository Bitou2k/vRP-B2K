
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_holdup")

local stores = cfg.holdups

local robbers = {}

local ultimoroubado = ""

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:b33:toofar')
AddEventHandler('es_holdup:b33:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:b33:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'AVISO', {255, 0, 0}, "O roubo foi cancelado na: ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:b33:playerdied')
AddEventHandler('es_holdup:b33:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:b33:playerdiedlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'AVISO', {255, 0, 0}, "O roubo foi cancelado na: ^2" .. stores[robb].nameofstore)
	end
end)

AddEventHandler("playerDropped", function()
	if(robbers[source])then
		local storie = robbers[source]
		local storierobbed = stores[storie].nameofstore
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "O roubo foi cancelado na: ^2" ..storierobbed.." Motivo: [Disconnected]")
	end
end)

RegisterServerEvent('es_holdup:b33:rob')
AddEventHandler('es_holdup:b33:rob', function(robb)
  local user_id = vRP.getUserId({source})
  local player = vRP.getUserSource({user_id})
  local cops = vRP.getUsersByPermission({cfg.permission})
  if vRP.hasPermission({user_id,cfg.permission}) then
    vRPclient.notify(player,{"~r~Policiais não podem roubar lojas/bancos."})
  else
    if #cops >= cfg.cops then
	  if stores[robb] then
		  local store = stores[robb]

		  if ultimoroubado == store.nameofstore then
			 TriggerClientEvent('chatMessage', player, 'ROUBO', {255, 0, 0}, "Esta Loja foi roubada recentemente. Impossível roubar seguido, mesmo após cooldown.")
			 return
		  end
		  
		  if (os.time() - store.lastrobbed) <  cfg.seconds+cfg.cooldown and store.lastrobbed ~= 0 then
			  TriggerClientEvent('chatMessage', player, 'ROUBO', {255, 0, 0}, "Já foi roubado recentemente, Aguarde: ^2" .. (cfg.seconds+cfg.cooldown - (os.time() - store.lastrobbed)) .. "^0 segundos.")
			  return
		  end
		  if(user_id)then
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Assault Loja** \n```\nUser ID: "..user_id.."```")
		  else
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Assault Loja** \n```\nUser ID: SEM ID ???```")
		  end
		  TriggerClientEvent('chatMessage', -1, 'AVISO', {255, 0, 0}, "Assalto em Andamento em ^2" .. store.nameofstore)
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Voce iniciou um Assalto a: ^2" .. store.nameofstore .. "^0, Não se afaste muito deste ponto!")
		  TriggerClientEvent('chatMessage', player, 'SYSTEM', {255, 0, 0}, "Segure por ^15 ^0minutos, e escape da Policia Vivo, e o Dinheiro é Seu!")
		  TriggerClientEvent('es_holdup:b33:currentlyrobbing', player, robb)
		  stores[robb].lastrobbed = os.time()
		  
		  robbers[player] = robb
		  local savedSource = player
		  SetTimeout(cfg.seconds*1000, function()
			  if(robbers[savedSource])then
				  if(user_id)then
				      ultimoroubado = store.nameofstore
					  vRP.giveInventoryItem({user_id,"dirty_money",store.reward,true})
					  TriggerClientEvent('chatMessage', -1, 'AVISO', {255, 0, 0}, "O Roubo de ^2" .. store.nameofstore .. "^0! foi concluido, Policiais deixaram os Bandidos Escaparem.")
					  TriggerClientEvent('es_holdup:b33:robberycomplete', savedSource, store.reward)
				  end
			  end
		  end)
	  end
    else
      vRPclient.notify(player,{"~r~Não há policiais online o suficiente."})
    end
  end
end)

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