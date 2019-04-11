--[[BASE]]--
MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_dmvschool")

--[[LANG]]--
local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

--[[SQL]]--
--[[MySQL.createCommand("vRP/dmv_column", "ALTER TABLE vrp_users ADD IF NOT EXISTS DmvTest varchar(50) NOT NULL default 'Required'")
MySQL.createCommand("vRP/dmv_column", "ALTER TABLE `vrp_users` ADD `DmvTest` VARCHAR(50) NOT NULL DEFAULT 'Required' AFTER `banned`")
MySQL.createCommand("vRP/dmv_success", "UPDATE vrp_users SET DmvTest='Passed' WHERE id = @id")
MySQL.createCommand("vRP/dmv_search", "SELECT * FROM vrp_users WHERE id = @id AND DmvTest = 'Passed'")]]

-- init
--MySQL.query("vRP/dmv_column")

--[[DMV Test]]--

RegisterServerEvent("dmv:success:b33")
AddEventHandler("dmv:success:b33", function()
	local user_id = vRP.getUserId({source})
	vRP.setUData({user_id,"vRP:dmv:license",json.encode(os.date("%x"))})
	--MySQL.query("vRP/dmv_success", {id = user_id})
end)

RegisterServerEvent("dmv:ttcharge")
AddEventHandler("dmv:ttcharge", function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryPayment({user_id,1000}) then
        TriggerClientEvent('dmv:startttest',player)
	else
		vRPclient.notify(player,{"~r~Dinheiro insuficiente."})
	end
end)

RegisterServerEvent("dmv:ptcharge")
AddEventHandler("dmv:ptcharge", function()
	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	if vRP.tryPayment({user_id,1200}) then
        TriggerClientEvent('dmv:startptest',player)
	else
		vRPclient.notify(player,{"~r~Dinheiro insuficiente."})
	end
end)

--[[ ***** SPAWN CHECK ***** ]]
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)

	local user_id = vRP.getUserId({source})
	local player = vRP.getUserSource({user_id})
	vRP.getUData({user_id,"vRP:dmv:license", function(data) 
		if data then
			local license = json.decode(data)
			if license and license ~= 0 then
				TriggerClientEvent('dmv:CheckLicStatus',source, true)
				--DMVclient.setLicense(player, true)
			end
		end
	end})

	--MySQL.query("vRP/dmv_search", {id = user_id}, function(rows, affected)
    --  if #rows > 0 then
    --      TriggerClientEvent('dmv:CheckLicStatus',source)
    --  end
    --end)
end)

--[[POLICE MENU]]--
local choice_asklc = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then
      vRPclient.notify(player,{"Perguntando sobre a Licença de motorista..."})
      vRP.request({nplayer,"Deseja mostrar sua licença?",15,function(nplayer,ok)
        if ok then
			vRP.getUData({nuser_id,"vRP:dmv:license", function(data)
				if data then
					local license = json.decode(data)
					if license and license ~= 0 then
						vRPclient.notify(player,{"Documento CNH: ~g~Tudo Certo"})
					else
						vRPclient.notify(player,{"Documento CNH: ~r~Não obtida"})
					end
				else
					vRPclient.notify(player,{"Documento CNH: ~r~Não obtida"})
				end
			end})
          --[[MySQL.query("vRP/dmv_search", {id = nuser_id}, function(rows, affected)
            if #rows > 0 then
			  vRPclient.notify(player,{"Licença de Motorista: ~g~Tudo Certo"})
			else
			  vRPclient.notify(player,{"Licença de Motorista: ~r~Não obtida"})
            end
          end)]]
        else
          vRPclient.notify(player,{lang.common.request_refused()})
        end
      end})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, "Verifique a licença do jogador mais próximo."}

local choice_takelc = {function(player,choice)
  vRPclient.getNearestPlayer(player,{10},function(nplayer)
    local nuser_id = vRP.getUserId({nplayer})
    if nuser_id ~= nil then
      vRP.request({player,"Você tem certeza de confiscar essa CNH?",15,function(player,ok)
        if ok then
			vRP.getUData({nuser_id,"vRP:dmv:license", function(data)
				if data then
					local license = json.decode(data)
					if license and license ~= 0 then
						TriggerClientEvent('dmv:CheckLicStatus', nplayer, false)
						vRP.setUData({nuser_id,"vRP:dmv:license",json.encode()})
						vRPclient.notify(player,{"~g~A CNH foi removida."})
						vRPclient.notify(nplayer,{"~r~Sua CNH foi removida!"})
					else
						vRPclient.notify(player,{"~r~Este jogador não tem CNH!"})
					end
				else
					vRPclient.notify(player,{"~r~Este jogador não tem CNH!"})
				end
			end})
        end
      end})
    else
      vRPclient.notify(player,{lang.common.no_player_near()})
    end
  end)
end, "Retire a CNH do jogador mais próximo."}


vRP.registerMenuBuilder({"police", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    local choices = {}

    -- build police menu
    if vRP.hasPermission({user_id,"police.asklc"}) then
       choices["CNH: Checar"] = choice_asklc
    end
	
    if vRP.hasPermission({user_id,"police.takelc"}) then
		choices["CNH: Confiscar"] = choice_takelc
	end
	
    add(choices)
  end
end})