local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_bank")

local banks = cfg.banks

local robbers = {}

local ultimoroubado = ""

function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

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

RegisterServerEvent('es_bank:b2k:toofar')
AddEventHandler('es_bank:b2k:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:b2k:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Roubo foi cancelado em: ^2" .. banks[robb].nameofbank)
		TriggerClientEvent('es_bank:b2k:killblip', -1)
	end
end)

RegisterServerEvent('es_bank:b2k:playerdied')
AddEventHandler('es_bank:b2k:playerdied', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_bank:b2k:playerdiedlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Roubo foi cancelado em: ^2" .. banks[robb].nameofbank)
		TriggerClientEvent('es_bank:b2k:killblip', -1)
	end
end)

AddEventHandler("playerDropped", function()
	if(robbers[source])then
		local banke = robbers[source]
		local bankrobbed = banks[banke].nameofbank
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Roubo foi cancelado: ^2" ..bankrobbed.." Motivo: [Disconnected]")
		TriggerClientEvent('es_bank:b2k:killblip', -1)
	end
end)

RegisterServerEvent('es_bank:b2k:rob')
AddEventHandler('es_bank:b2k:rob', function(robb)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	local cops = vRP.getUsersByPermission({cfg.permission})
	if vRP.hasPermission({user_id,cfg.permission}) then
		vRPclient.notify(player,{"~r~Policiais não podem roubar banco."})
	else
		--[[vRP.getSData("globalbanktime", function(data)
			local delay = json.decode(data) or 0
			local cond = (os.time() >= delay+6*60*60)
			if cond or vRP.hasPermission({user_id,"bank.bypass"}) then
				delay = os.time()
				vRP.setSData("globalbanktime", json.encode(delay))]]

				if #cops >= cfg.cops then
					if banks[robb] then
						local bank = banks[robb]

						if ultimoroubado == bank.nameofbank then
							TriggerClientEvent('chatMessage', player, 'ROUBO', {255, 0, 0}, "Este Banco foi roubado recentemente. Impossível assaltar seguido, mesmo após cooldown.")
							return
						end

						if (os.time() - bank.lastrobbed) < cfg.seconds+cfg.cooldown and bank.lastrobbed ~= 0 then
							TriggerClientEvent('chatMessage', player, 'BANCO', {255, 0, 0}, "Esse banco foi roubado recentemente, vá para outro: ^2" .. (cfg.seconds+cfg.cooldown - (os.time() - bank.lastrobbed)) .. "^0 segundos.")
							return
						end
						if(user_id)then
							SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Assault Bank** \n```\nUser ID: "..user_id.."```")
						else
							SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Assault Bank** \n```\nUser ID: SEM ID ???```")
						end
						TriggerClientEvent("b2k:bankNews", -1, 10)
						TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Roubo em progresso em ^2" .. bank.nameofbank)
						TriggerClientEvent('chatMessage', player, 'BANCO', {255, 0, 0}, "Você iniciou roubo em: ^2" .. bank.nameofbank .. "^0, não vá muito longe deste ponto!")
						TriggerClientEvent('chatMessage', player, 'BANCO', {255, 0, 0}, "Aguente firme por ^10 ^0minutos, para escapar, e todo dinheiro e seu!")
						TriggerClientEvent('es_bank:b2k:currentlyrobbing', player, robb)
						TriggerClientEvent('es_bank:b2k:setblip', -1, bank.position)
						banks[robb].lastrobbed = os.time()
						robbers[player] = robb
						local savedSource = player
						SetTimeout(cfg.seconds*1000, function()
							if(robbers[savedSource])then
								if(user_id)then
									ultimoroubado = bank.nameofbank
									vRP.giveInventoryItem({user_id,"dirty_money",bank.reward,true})
									TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Roubo terminou em: ^2" .. bank.nameofbank .. "^0!")	
									TriggerClientEvent('es_bank:b2k:robberycomplete', savedSource, bank.reward)
									TriggerClientEvent('es_bank:b2k:killblip', -1)
								end
							end
						end)
					end
				else
					vRPclient.notify(player,{"~r~Sem Policiais Online."})
				end
			--[[else
				vRPclient.notify(player,{"~r~Banco ainda está indisponível. (Cooldown 6Hrs)"})
			end
		end)]]
	end
end)