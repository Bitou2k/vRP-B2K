-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")
vRPhud = {}
Tunnel.bindInterface("vrp_hud",vRPhud)

function vRPhud.checkHunger()
  local user_id = vRP.getUserId(source)
  return vRP.getHunger(user_id)
end

function vRPhud.checkThirst()
  local user_id = vRP.getUserId(source)
  return vRP.getThirst(user_id)
end


--------------------------------
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")

RegisterCommand('parall', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) then
			TriggerClientEvent("b2k:giveParachute", -1)
		end
	end
end)

RegisterCommand('tpall', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) then
			vRPclient.getPosition(player,{},function(x,y,z)
				TriggerClientEvent("b2k:tpall", -1, x, y, z)
			end)
		end
	end
end)

RegisterCommand('reviveall', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) then
			local users = vRP.getUsers({})
			for k,v in pairs(users) do
				local target_source = vRP.getUserSource({k})
				if target_source ~= nil then
					vRPclient.setHealth(target_source, {400})
				end
			end
		end
	end
end)