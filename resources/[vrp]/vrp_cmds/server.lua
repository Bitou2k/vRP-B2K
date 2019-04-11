local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")

vRPcmd = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_cmds")
CMDclient = Tunnel.getInterface("vrp_cmds","vrp_cmds")
Tunnel.bindInterface("vrp_cmds",vRPcmd)

RegisterCommand('placa', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"police.cmd_plate"}) then
			if args[1] ~= nil then
				vRP.getUserByRegistration({args[1], function(nuser_id)
					if nuser_id then
						vRP.getUserIdentity({nuser_id, function(identity)
							if identity then
								TriggerClientEvent('chatMessage', player, "COPOM", {255, 0, 0}, "^2Placa Responsável:^1 " .. identity.nome.." "..identity.sobrenome.."^2, Idade:^1 "..identity.age)
							else
								TriggerClientEvent('chatMessage', player, "COPOM", {255, 0, 0}, "Dono não encontrado, Veiculo Vendido ou Placa Inválida!")
							end
						end})
					else
						TriggerClientEvent('chatMessage', player, "COPOM", {255, 0, 0}, "Dono não encontrado, Veiculo Vendido ou Placa Inválida!")
					end
				end})
			else
				TriggerClientEvent('chatMessage', player, "SYSTEM", {255, 0, 0}, "Uso: /placa <placa>")
			end
		end
	end
end)

-- add tp areas areas on player first spawn
AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
	if first_spawn then

	end
end)
