local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local cfg = {}
cfg.list = {
	[1] = { hash = 1557126584, x = 449.6, y = -986.4, z = 30.6, locked = true },
	[2] = { hash = 749848321, x = 452.6, y = -982.7, z = 30.6, locked = true },
	[3] = { hash = -1320876379, x = 447.2, y = -980.6, z = 30.6, locked = true },
	[4] = { hash = 631614199, x = 464.4, y = -992.2, z = 24.9, locked = true },
	[5] = { hash = 631614199, x = 462.3, y = -993.6, z = 24.9, locked = true },
	[6] = { hash = 631614199, x = 462.3, y = -998.1, z = 24.9, locked = true },
	[7] = { hash = 631614199, x = 462.3, y = -1001.9, z = 24.9, locked = true },
	[8] = { hash = -2023754432, x = 468.9, y = -1014.4, z = 26.5, locked = true, pair = 9 },
	[9] = { hash = -2023754432, x = 468.3, y = -1014.4, z = 26.5, locked = true, pair = 8 },
	[10] = { hash = 185711165, x = 443.9, y = -989.0, z = 30.6, locked = true, pair = 11 },
	[11] = { hash = 185711165, x = 445.3, y = -989.7, z = 30.6, locked = true, pair = 10 },
	[12] = { hash = -131296141, x = 443.0, y = -992.9, z = 30.8, locked = true, pair = 13 },
	[13] = { hash = -131296141, x = 443.0, y = -993.5, z = 30.8, locked = true, pair = 12 },
	[14] = { hash = 580361003, x = 253.0, y = -1360.9, z = 24.1, locked = true, pair = 15 },
	[15] = { hash = 1415151278, x = 253.9, y = -1359.8, z = 24.1, locked = true, pair = 14 },
	[16] = { hash = 580361003, x = 266.5, y = -1345.6, z = 24.1, locked = true, pair = 17 },
	[17] = { hash = 1415151278, x = 267.4, y = -1344.5, z = 24.1, locked = true, pair = 16 }
}


AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		TriggerClientEvent('vrpdoorsystem:load',source,cfg.list)
	end
end)

Citizen.CreateThread(function()
	TriggerClientEvent('vrpdoorsystem:load',-1,cfg.list)
end)

RegisterServerEvent('vrpdoorsystem:open')
AddEventHandler('vrpdoorsystem:open',function(id)
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.hasPermission({user_id,"portas.policia"}) then
		cfg.list[id].locked = not cfg.list[id].locked
		TriggerClientEvent('vrpdoorsystem:statusSend',-1,id,cfg.list[id].locked)
		if cfg.list[id].pair ~= nil then
			local idsecond = cfg.list[id].pair
			cfg.list[idsecond].locked = cfg.list[id].locked
			TriggerClientEvent('vrpdoorsystem:statusSend',-1,idsecond,cfg.list[id].locked)
		end
	end
end)