-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

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


AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then
        return
    end

    --TriggerEvent('chatMessage', source, author, message)
	--TriggerClientEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        --TriggerClientEvent('chatMessage', -1, author, color, message)
		TriggerClientEvent('sendProximityMessage', -1, source, author, message, color)
    end

    print(author .. ': ' .. message)
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    --TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        --TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end
	--print(name .. ': ' .. command)
    CancelEvent()
end)

--[[ player join messages
AddEventHandler('vRP:playerSpawn', function(user_id, source, first_spawn)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, '', { 254, 158, 16 }, '^3[SERVIDOR]: ^1'.. identity.nome .. ' ' .. identity.sobrenome ..' entrou na cidade.')
			--TriggerClientEvent('chatMessage', -1, "[@Fora do RP] ".. GetPlayerName(source) .." ("..user_id..") ", {16, 255, 0}, rawCommand:sub(7))
		end})
	end
end)

AddEventHandler('playerDropped', function(reason)
	TriggerClientEvent('chatMessage', -1, '', { 254, 158, 16 }, '^3[SERVIDOR]: ^1' .. GetPlayerName(source) ..' saiu da cidade (' .. reason .. ')')
end)]]

RegisterCommand('say', function(source, args, rawCommand)
    TriggerClientEvent('chatMessage', -1, (source == 0) and 'console' or GetPlayerName(source), { 255, 255, 255 }, rawCommand:sub(5))
end)
-- Admin Commands
RegisterCommand('spawn', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) and args[1] ~= nil then
			local model = args[1]
			BMclient.spawnVehicle(player,{model})
			TriggerClientEvent('chatMessage', player, '', { 255, 255, 255 }, '^2* Spawn Car: ' .. model ..'')
			SendWebhookMessage(ac_webhook_gameplay, "**Spawn Car** \n```\nUser: "..GetPlayerName(source).." Model: "..model.."```")
		end
	end
end)
RegisterCommand('clearv', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) and args[1] ~= nil then
		
			if args[1] == "cuff" then
				vRPclient.toggleHandcuff(player,{})
				return
			end
			
			if args[1] == "gas" then
				TriggerClientEvent("essence:hasBuying", player, 100)
				return
			end
			
			if args[1] == "fix" then
				vRPclient.getNearestVehicle(player,{5},function(vehicle)
					if vehicle then
						vRPclient.checkOffSetAndHoodOpen(player,{vehicle,false},function(isok,netid)
							if isok then
								TriggerClientEvent("b2k:fixeVehicleByNetId", -1, netid)
							end
						end)
					end
				end)				
				return
			end
		
			local radius = 1
			radius = tonumber(args[1])
			
			vRPclient.getNearestVehicle(player,{4},function(vehicle)
				if vehicle then
					vRPclient.getObjToNet(player,{vehicle},function(netId)
						TriggerClientEvent("b2k:syncRemovedEntity", -1, netId)
						TriggerClientEvent('chatMessage', player, '', { 255, 255, 255 }, '^2* Clearing Vehicle Radius: ' .. radius ..'')
						SendWebhookMessage(ac_webhook_gameplay, "**Clearing Vehicle Radius** \n```\nUser: "..GetPlayerName(source).." Radius: "..radius.."```")
					end)
				end
			end)
		end
	end
end)
RegisterCommand('blackout', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) and args[1] ~= nil then
			local cond = tonumber(args[1])
			TriggerEvent("b2k:setBlackout", cond)
			TriggerClientEvent("b2k:blackout", -1, cond)
			TriggerClientEvent('chatMessage', player, '', { 255, 255, 255 }, '^2* Blackout: ' .. cond ..'')
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Blackout** \n```\nUser: "..GetPlayerName(source).." Arg: "..cond.."```")
		end
	end
end)

RegisterCommand('debug', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) then
			TriggerClientEvent("b2k:ToggleDebug", player)
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Debug** \n```\nUser: "..GetPlayerName(source).."```")
		end
	end
end)

RegisterCommand('lightning', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"admin.spawnveh"}) and args[1] ~= nil then
			local vezes = tonumber(args[1])
			TriggerClientEvent("b2k:lightning", -1, vezes)
			TriggerClientEvent('chatMessage', player, '', { 255, 255, 255 }, '^2* Raios: ' .. vezes ..'x')
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Raios** \n```\nUser: "..GetPlayerName(source).." Arg: "..vezes.."```")
		end
	end
end)

-- Reporter
RegisterCommand('cam', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"reporter.cmds"}) then
			TriggerClientEvent("Cam:ToggleCam", player)
		end
	end
end)

RegisterCommand('mic', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		if vRP.hasPermission({user_id,"reporter.cmds"}) then
			TriggerClientEvent("Mic:ToggleMic", player)
		end
	end
end)

-- Roleplay Commands
RegisterCommand('tweet', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@Tweet] ".. identity.nome .. " " .. identity.sobrenome .." ("..user_id..") ", {0, 170, 255}, rawCommand:sub(6))
			print("[Tweet] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(6))
		end})
	end
end)

RegisterCommand('ilegal', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@Anonimo]", {255, 255, 255}, rawCommand:sub(7))
			print("[Anonimo] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(7))
		end})
	end
end)

RegisterCommand('olx', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@OLX] ".. identity.nome .. " " .. identity.sobrenome .." ("..user_id..") ", {255, 225, 0}, rawCommand:sub(4))
			print("[OLX] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(4))
		end})
	end
end)

RegisterCommand('190', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@190]", {255, 0, 0}, rawCommand:sub(4))
			print("[190] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(4))
		end})
	end
end)

RegisterCommand('192', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@192] ".. identity.nome .. " " .. identity.sobrenome .." ("..user_id..") ", {255, 120, 120}, rawCommand:sub(4))
			print("[192] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(4))
		end})
	end
end)

RegisterCommand('forarp', function(source, args, rawCommand)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		vRP.getUserIdentity({user_id, function(identity)
			TriggerClientEvent('chatMessage', -1, "[@Fora do RP] ".. GetPlayerName(source) .." ("..user_id..") ", {16, 255, 0}, rawCommand:sub(7))
			CancelEvent()
			print("[ForaRP] " ..GetPlayerName(player).. " - " ..user_id .. ':' .. rawCommand:sub(7))
		end})
	end
end)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    refreshCommands(source)
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)