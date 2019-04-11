local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

RegisterCommand('rebocar', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"mecanico.tow"}) then
			TriggerClientEvent("pv:tow", player)
		else
			vRPclient.notify(player,{"Você não é um Mecânico."})
		end
	end
end)