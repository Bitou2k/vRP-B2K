-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

-- E N G I N E --
RegisterCommand('motor', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		if args[1] ~= nil then
			local status = string.lower(args[1])
			if status == "off" then
				TriggerClientEvent('engineoff', s)
			elseif status == "on" then
				TriggerClientEvent('engineon', s)
			else
				TriggerClientEvent('engine', s)
			end
		else
			TriggerClientEvent('engine', s)
		end
	end
end)
-- T R U N K --
RegisterCommand('portamalas', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('trunk', s)
	end
end)
-- R E A R  D O O R S --
RegisterCommand('tportas', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('rdoors', s)
	end
end)
-- H O O D --
RegisterCommand('capo', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('hood', s)
	end
end)
-- L O C K --
RegisterCommand('trancar', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('lock', s)
	end
end)
-- S A V E --
RegisterCommand('salvar', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('save', s)
	end
end)
-- R E M O T E --
RegisterCommand('sveh', function(source, args, rawCommand)
	local s = source
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		TriggerClientEvent('controlsave', s)
	end
end)