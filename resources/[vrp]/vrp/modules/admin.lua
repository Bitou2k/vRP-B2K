local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

-- this module define some admin menu functions

local player_lists = {}

local function ch_list(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.list") then
    if player_lists[player] then -- hide
      player_lists[player] = nil
      vRPclient.removeDiv(player,{"user_list"})
    else -- show
      local content = ""
      local count = 0
      for k,v in pairs(vRP.rusers) do
        count = count+1
        local source = vRP.getUserSource(k)
        vRP.getUserIdentity(k, function(identity)
          if source ~= nil then
            content = content.."<br />"..k.." => <span class=\"pseudo\">"..vRP.getPlayerName(source).."</span> <span class=\"endpoint\">"..vRP.getPlayerEndpoint(source).."</span>"
            if identity then
              content = content.." <span class=\"name\">"..htmlEntities.encode(identity.nome).." "..htmlEntities.encode(identity.sobrenome).."</span> <span class=\"reg\">"..identity.registration.."</span> <span class=\"phone\">"..identity.phone.."</span>"
            end
          end

          -- check end
          count = count-1
          if count == 0 then
            player_lists[player] = true
            local css = [[
.div_user_list{ 
  margin: auto; 
  padding: 8px; 
  width: 650px; 
  margin-top: 80px; 
  background: black; 
  color: white; 
  font-weight: bold; 
  font-size: 1.1em;
} 

.div_user_list .pseudo{ 
  color: rgb(0,255,125);
}

.div_user_list .endpoint{ 
  color: rgb(255,0,0);
}

.div_user_list .name{ 
  color: #309eff;
}

.div_user_list .reg{ 
  color: rgb(0,125,255);
}
              
.div_user_list .phone{ 
  color: rgb(211, 0, 255);
}
            ]]
            vRPclient.setDiv(player,{"user_list", css, content})
          end
        end)
      end
    end
  end
end

local function ch_whitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.whitelist") then
    vRP.prompt(player,"User id to whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setWhitelisted(id,true)
      vRPclient.notify(player,{"whitelisted user "..id})
	  SendWebhookMessage(ac_webhook_wl, "**ADMIN Add Whitelist** \n```\nAdmin: "..user_id.." ID WL: "..id.."```")
    end)
  end
end

local function ch_unwhitelist(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.unwhitelist") then
    vRP.prompt(player,"User id to un-whitelist: ","",function(player,id)
      id = parseInt(id)
      vRP.setWhitelisted(id,false)
      vRPclient.notify(player,{"un-whitelisted user "..id})
	  SendWebhookMessage(ac_webhook_wl, "**ADMIN Rem Whitelist** \n```\nAdmin: "..user_id.." ID WL: "..id.."```")
    end)
  end
end

local function ch_addgroup(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.group.add") then
    vRP.prompt(player,"User id: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Group to add: ","",function(player,group)
		if group then
			vRP.addUserGroup(id,group)
			vRPclient.notify(player,{group.." added to user "..id})
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Add Group** \n```\nAdmin: "..user_id.." User: "..id.." Group: "..group.."```")
		end
      end)
    end)
  end
end

local function ch_removegroup(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.group.remove") then
    vRP.prompt(player,"User id: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Group to remove: ","",function(player,group)
		if group then
			vRP.removeUserGroup(id,group)
			vRPclient.notify(player,{group.." removed from user "..id})
			SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Rem Group** \n```\nAdmin: "..user_id.." User: "..id.." Group: "..group.."```")
		end
      end)
    end)
  end
end

local function ch_kick(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.kick") then
    vRP.prompt(player,"User ID para Kikar: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Motivo: ","",function(player,reason)
        local source = vRP.getUserSource(id)
        if source ~= nil then
          vRP.kick(source,reason)
          vRPclient.notify(player,{"kicked user "..id})
        end
      end)
    end)
  end
end

local function ch_reviveplayer(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"admin.revive") then
    vRP.prompt(player,"User ID para Reviver: ","",function(player,id)
      id = parseInt(id)
      local source = vRP.getUserSource(id)
      if source ~= nil then
        vRPclient.setHealth(source, {400})
        vRPclient.notify(player,{"Revive User ID "..id})
      end
    end)
  end
end

local function ch_ban(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.ban") then
    vRP.prompt(player,"User ID para banir: ","",function(player,id)
      id = parseInt(id)
      vRP.prompt(player,"Motivo: ","",function(player,reason)
	    vRP.setBanned(id,true)
		vRPclient.notify(player,{"Banido User ID:"..id})
        local source = vRP.getUserSource(id)
        if source ~= nil then
          vRP.ban(source,reason)
          vRPclient.notify(player,{"Expulsado ID "..id})
        end
		SendWebhookMessage(ac_webhook_bans, "**ADMIN BAN ** \n```\nAdmin: "..user_id.." User: "..id.."```")
      end)
    end)
  end
end

local function ch_unban(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.unban") then
    vRP.prompt(player,"User ID para Desbanir: ","",function(player,id)
      id = parseInt(id)
      vRP.setBanned(id,false)
      vRPclient.notify(player,{"Desbanido ID "..id})
	  SendWebhookMessage(ac_webhook_bans, "**ADMIN DESBANIR ** \n```\nAdmin: "..user_id.." User: "..id.."```")
    end)
  end
end

local function ch_emote(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.custom_emote") then
    vRP.prompt(player,"Animation sequence ('dict anim optional_loops' per line): ","",function(player,content)
      local seq = {}
      for line in string.gmatch(content,"[^\n]+") do
        local args = {}
        for arg in string.gmatch(line,"[^%s]+") do
          table.insert(args,arg)
        end

        table.insert(seq,{args[1] or "", args[2] or "", args[3] or 1})
      end

      vRPclient.playAnim(player,{true,seq,false})
    end)
  end
end

local function ch_sound(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.custom_sound") then
    vRP.prompt(player,"Sound 'dict name': ","",function(player,content)
      local args = {}
      for arg in string.gmatch(content,"[^%s]+") do
        table.insert(args,arg)
      end
      vRPclient.playSound(player,{args[1] or "", args[2] or ""})
    end)
  end
end

local function ch_coords(player,choice)
  vRPclient.getPosition(player,{},function(x,y,z)
    vRP.prompt(player,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) end)
  end)
end

local function ch_tptome(player,choice)
  vRPclient.getPosition(player,{},function(x,y,z)
    vRP.prompt(player,"User id:","",function(player,user_id) 
      local tplayer = vRP.getUserSource(tonumber(user_id))
      if tplayer ~= nil then
        vRPclient.teleport(tplayer,{x,y,z})
		SendWebhookMessage(ac_webhook_gameplay, "**ADMIN TpToMe** \n```\nAdmin ID: "..GetPlayerName(player).." TpToMe: "..user_id.."```")
      end
    end)
  end)
end

local function ch_tpto(player,choice)
  vRP.prompt(player,"User id:","",function(player,user_id) 
    local tplayer = vRP.getUserSource(tonumber(user_id))
    if tplayer ~= nil then
      vRPclient.getPosition(tplayer,{},function(x,y,z)
        vRPclient.teleport(player,{x,y,z})
		SendWebhookMessage(ac_webhook_gameplay, "**ADMIN TpTo** \n```\nAdmin ID: "..GetPlayerName(player).." TpTo: "..user_id.."```")
      end)
    end
  end)
end

local function ch_tptocoords(player,choice)
  vRP.prompt(player,"Coords x,y,z:","",function(player,fcoords) 
    local coords = {}
    for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
      table.insert(coords,tonumber(coord))
    end

    local x,y,z = 0,0,0
    if coords[1] ~= nil then x = coords[1] end
    if coords[2] ~= nil then y = coords[2] end
    if coords[3] ~= nil then z = coords[3] end

    vRPclient.teleport(player,{x,y,z})
  end)
end

local function ch_givemoney(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Amount:","",function(player,amount) 
      amount = parseInt(amount)
      vRP.giveMoney(user_id, amount)
	  SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Give Money** \n```\nAdmin: "..user_id.." Amount: "..amount.."```")
    end)
  end
end

local function ch_giveitem(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Id name:","",function(player,idname) 
      idname = idname or ""
      vRP.prompt(player,"Amount:","",function(player,amount) 
        amount = parseInt(amount)
        vRP.giveInventoryItem(user_id, idname, amount,true)
		SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Give Item** \n```\nAdmin: "..user_id.." Item: "..idname.." Amount: "..amount.."```")
      end)
    end)
  end
end

local function ch_calladmin(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,"Descreva seu problema:","",function(player,desc) 
      desc = desc or ""

      local answered = false
      local players = {}
      for k,v in pairs(vRP.rusers) do
        local player = vRP.getUserSource(tonumber(k))
        -- check user
        if vRP.hasPermission(k,"admin.tickets") and player ~= nil then
          table.insert(players,player)
        end
      end
	  SendWebhookMessage(ac_webhook_gameplay, "**Call ADMIN** \n```\nUser ID: "..user_id.." Desc: "..desc.."```")
      -- send notify and alert to all listening players
      for k,v in pairs(players) do
        vRP.request(v,"Admin ticket (user_id = "..user_id..") take/TP to ?: "..htmlEntities.encode(desc), 60, function(v,ok)
          if ok then -- take the call
            if not answered then
              -- answer the call
              vRPclient.notify(player,{"An admin took your ticket."})
              vRPclient.getPosition(player, {}, function(x,y,z)
                vRPclient.teleport(v,{x,y,z})
              end)
              answered = true
            else
              vRPclient.notify(v,{"Ticket already taken."})
            end
          end
        end)
      end
    end)
  end
end

local player_customs = {}

local function ch_display_custom(player, choice)
  vRPclient.getCustomization(player,{},function(custom)
    if player_customs[player] then -- hide
      player_customs[player] = nil
      vRPclient.removeDiv(player,{"customization"})
    else -- show
      local content = ""
      for k,v in pairs(custom) do
        content = content..k.." => "..json.encode(v).."<br />" 
      end

      player_customs[player] = true
      vRPclient.setDiv(player,{"customization",".div_customization{ margin: auto; padding: 8px; width: 500px; margin-top: 80px; background: black; color: white; font-weight: bold; ", content})
    end
  end)
end

local function ch_setmodel(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"player.setmodel") then
    vRP.prompt(player,"User ID: ","",function(player,id)
  		if id ~= nil then
  			id = parseInt(id)
  			local psource = vRP.getUserSource(id)
  			if psource ~= nil then
  				vRP.prompt(player,"Model: ","",function(player,pmodel)
  					if pmodel ~= nil then
  						local idle_copy = { model = pmodel }
  						for i=0,19 do
  						  idle_copy[i] = {0,0}
  						end
  						vRPclient.setCustomization(psource,{idle_copy})
  					end
  				end)
  			end
  		end
    end)
  end
end

local function ch_carupgrade(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"admin.carupgrade") then
    vRPclient.AdminUpgrade(player,{})
  end
end

local function ch_fixclean(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"admin.fixclean") then
    vRPclient.FixClean(player,{})
  end
end

local function ch_noclip(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.noclip") then
		vRPclient.toggleNoclip(player, {})
	end
end

local function ch_spectate(player, choice)
	local user_id = vRP.getUserId(player)
	if user_id ~= nil and vRP.hasPermission(user_id,"player.spec") then
		vRP.prompt(player,"User ID: (0 to terminate)","",function(player,pid)
			if pid ~= nil then
				local id = tonumber(pid)
				if id == 0 then
					vRPclient.notify(player, {"Saindo Modo Spectador"})
					vRPclient.stopSpec(player, {})
				elseif id == user_id then
					vRPclient.notify(player, {"ID Spec inválido."})
				else 
					local nplayer = vRP.getUserSource(id)
					if nplayer ~= nil then
						vRPclient.notify(player, {"Modo Spectador ID: " .. id})
						vRPclient.toggleSpec(player, {nplayer})
						SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Spec** \n```\nAdmin: "..user_id.." ID To Spc: "..id.."```")
					end
				end
			end
		end)
	end
end

local function ch_steamhex(player, choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil and vRP.hasPermission(user_id,"admin.hexsteam") then
    vRP.prompt(player,"Formato -> steam:1100001xxxxxxxx","steam:",function(player,steamhex)
      if steamhex ~= nil then
        vRP.addSteamHex(steamhex)
        vRPclient.notify(player, {"SteamHex Adicionada"})
        SendWebhookMessage(ac_webhook_wl, "**ADMIN SteamHex** \n```\nAdmin: "..user_id.." SteamHex: "..steamhex.."```")
      end
    end)
  end
end




-- Hotkey Open Admin Menu 1/2
function vRP.openAdminMenu(source)
  vRP.buildMenu("admin", {player = source}, function(menudata)
    menudata.name = "<img src='nui://vrp/gui/imgs/zhelp.png'/> Admin"
    menudata.css = {top="75px",header_color="rgba(200,0,0,0.75)"}
    vRP.openMenu(source,menudata)
  end)
end

-- Hotkey Open Admin Menu 2/2
function tvRP.openAdminMenu()
  vRP.openAdminMenu(source)
end

vRP.registerMenuBuilder("main", function(add, data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}

    -- build admin menu
    choices["<img src='nui://vrp/gui/imgs/zhelp.png'/> Admin"] = {function(player,choice)
      vRP.buildMenu("admin", {player = player}, function(menu)
        menu.name = "<img src='nui://vrp/gui/imgs/zhelp.png'/> Admin"
        menu.css={top="75px",header_color="rgba(200,0,0,0.75)"}
        menu.onclose = function(player) vRP.openMainMenu(player) end -- nest menu

        if vRP.hasPermission(user_id,"player.list") then
          menu["Gameplay: User list"] = {ch_list,"Show/hide user list."}
        end
        if vRP.hasPermission(user_id,"player.whitelist") then
          menu["Account: Whitelist user"] = {ch_whitelist}
        end
        if vRP.hasPermission(user_id,"player.group.add") then
          menu["Account: Add group"] = {ch_addgroup}
        end
        if vRP.hasPermission(user_id,"player.group.remove") then
          menu["Account: Remove group"] = {ch_removegroup}
        end
        if vRP.hasPermission(user_id,"player.unwhitelist") then
          menu["Account: Un-whitelist user"] = {ch_unwhitelist}
        end
        if vRP.hasPermission(user_id,"player.kick") then
          menu["Account: Kick"] = {ch_kick}
        end
        if vRP.hasPermission(user_id,"player.ban") then
          menu["Account: Ban"] = {ch_ban}
        end
        if vRP.hasPermission(user_id,"player.unban") then
          menu["Account: Unban"] = {ch_unban}
        end
        if vRP.hasPermission(user_id,"player.noclip") then
          menu["Gameplay: Noclip"] = {ch_noclip}
        end
        if vRP.hasPermission(user_id,"player.spec") then
          menu["Gameplay: Spectate"] = {ch_spectate}
        end
        if vRP.hasPermission(user_id,"player.custom_emote") then
          menu["Gameplay: Custom emote"] = {ch_emote}
        end
        if vRP.hasPermission(user_id,"player.custom_sound") then
          menu["Gameplay: Custom sound"] = {ch_sound}
        end
        if vRP.hasPermission(user_id,"player.coords") then
          menu["Gameplay: Coords"] = {ch_coords}
        end
        if vRP.hasPermission(user_id,"player.tptome") then
          menu["Gameplay: TpToMe"] = {ch_tptome}
        end
        if vRP.hasPermission(user_id,"player.tpto") then
          menu["Gameplay: TpTo"] = {ch_tpto}
        end
        if vRP.hasPermission(user_id,"player.tpto") then
          menu["Gameplay: TpToCoords"] = {ch_tptocoords}
        end
        if vRP.hasPermission(user_id,"player.givemoney") then
          menu["Gameplay: Give money"] = {ch_givemoney}
        end
        if vRP.hasPermission(user_id,"player.giveitem") then
          menu["Gameplay: Give item"] = {ch_giveitem}
        end
        if vRP.hasPermission(user_id,"admin.revive") then
          menu["Gameplay: Revive Player"] = {ch_reviveplayer}
        end
        if vRP.hasPermission(user_id,"player.display_custom") then
          menu["Gameplay:Display customization"] = {ch_display_custom}
        end
        if vRP.hasPermission(user_id,"player.calladmin") then
          menu["Gameplay: Call admin"] = {ch_calladmin}
        end
        if vRP.hasPermission(user_id,"player.setmodel") then
          menu["Ped: Model"] = {ch_setmodel}
        end
        if vRP.hasPermission(user_id,"admin.carupgrade") then
          menu["Car: Full Upgrade"] = {ch_carupgrade}
        end
        if vRP.hasPermission(user_id,"admin.fixclean") then
          menu["Car: Fix & Clean"] = {ch_fixclean}
        end
        if vRP.hasPermission(user_id,"admin.hexsteam") then
          menu["Account: Steam Hex"] = {ch_steamhex}
        end
        
        vRP.openMenu(player,menu)
      end)
    end}

    add(choices) -- remover do menu principal
	end
end)

--[[ admin god mode
function task_god()
	SetTimeout(10000, task_god)

	for k,v in pairs(vRP.getUsersByPermission("admin.god")) do
		vRP.setHunger(v, 0)
		vRP.setThirst(v, 0)

		local player = vRP.getUserSource(v)
		if player ~= nil then
			vRPclient.setHealth(player, {200})
		end
	end
end
task_god()]]

RegisterServerEvent("b2k:press")
AddEventHandler("b2k:press", function(key)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		local keyAscii = "" .. key
		if key == 288 then keyAscii = "F1" end
		if key == 166 then keyAscii = "F5" end
		if key == 167 then keyAscii = "F6" end
		if key == 56 then keyAscii = "F9" end
		if key == 108 then keyAscii = "N4" end
		if key == 107 then keyAscii = "N6" end
		if key == 111 then keyAscii = "N8" end
		if key == 112 then keyAscii = "N5" end
		SendWebhookMessage(ac_webhook_keys, "**ADMIN Press Monitor Key** \n```\nUser ID: "..user_id.." Key: "..keyAscii.." ```")
	end
end)

RegisterServerEvent("b2k:suppress")
AddEventHandler("b2k:suppress", function(infraction)
	local user_id = vRP.getUserId(source)
	if user_id ~= nil then
		SendWebhookMessage(ac_webhook_gameplay, "**ADMIN Lua Inject** \n```\nUser ID: "..user_id.." Infração: "..infraction.." ```")
	end
end)
