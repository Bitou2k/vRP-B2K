MySQL = module("vrp_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
Debug.active = config.debug
MySQL.debug = config.debug

-- open MySQL connection
MySQL.createConnection("vRP", config.db.host,config.db.user,config.db.password,config.db.database)

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources 

-- queries
MySQL.createCommand("vRP/base_tables",[[
CREATE TABLE IF NOT EXISTS vrp_users(
  id INTEGER AUTO_INCREMENT,
  last_login VARCHAR(100),
  whitelisted BOOLEAN,
  banned BOOLEAN,
  CONSTRAINT pk_user PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS vrp_user_ids(
  identifier VARCHAR(100),
  user_id INTEGER,
  CONSTRAINT pk_user_ids PRIMARY KEY(identifier),
  CONSTRAINT fk_user_ids_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_user_data(
  user_id INTEGER,
  dkey VARCHAR(100),
  dvalue TEXT,
  CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
  CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_srv_data(
  dkey VARCHAR(100),
  dvalue TEXT,
  CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
);
]])

MySQL.createCommand("vRP/create_user","INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false); SELECT LAST_INSERT_ID() AS id")
MySQL.createCommand("vRP/add_identifier","INSERT INTO vrp_user_ids(identifier,user_id) VALUES(@identifier,@user_id)")
MySQL.createCommand("vRP/userid_byidentifier","SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier")

MySQL.createCommand("vRP/set_userdata","REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("vRP/get_userdata","SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("vRP/set_srvdata","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("vRP/get_srvdata","SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")
MySQL.createCommand("vRP/del_srvdata","DELETE FROM vrp_srv_data WHERE dkey = @key")
MySQL.createCommand("vRP/del_usrdata","DELETE FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("vRP/get_banned","SELECT banned FROM vrp_users WHERE id = @user_id")
MySQL.createCommand("vRP/set_banned","UPDATE vrp_users SET banned = @banned WHERE id = @user_id")
MySQL.createCommand("vRP/get_whitelisted","SELECT whitelisted FROM vrp_users WHERE id = @user_id")
MySQL.createCommand("vRP/set_whitelisted","UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id")
MySQL.createCommand("vRP/set_last_login","UPDATE vrp_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("vRP/get_last_login","SELECT last_login FROM vrp_users WHERE id = @user_id")

-- init tables
print("[B2K] init base tables")
MySQL.execute("vRP/base_tables")

-- LOG SYSTEM
function vRP.logToFile(file,info)
  file = io.open(file, "a")
  if file then
    file:write(os.date("%c").." => "..info.."\r\n")
  end
  file:close()
end

function vRP.addSteamHex(info)
  fileWL = io.open("whitelist.txt", "a")
  if fileWL then
    fileWL:write(""..info.."\r\n")
  end
  fileWL:close()
end

function vRP.formatNumber(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$') 
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right 
end

-- identification system

--- sql.
-- cbreturn user id or nil in case of error (if not found, will create it)
function vRP.getUserIdByIdentifiers(ids, cbr)
  local task = Task(cbr)

  if ids ~= nil and #ids then
    local i = 0

    -- search identifiers
    local function search()
      i = i+1
      if i <= #ids then
        if not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil) then  -- ignore ip identifier
          MySQL.query("vRP/userid_byidentifier", {identifier = ids[i]}, function(rows, affected)
            if #rows > 0 then  -- found
              task({rows[1].user_id})
            else -- not found
              search()
            end
          end)
        else
          search()
        end
      else -- no ids found, create user
        MySQL.query("vRP/create_user", {}, function(rows, affected)
          if #rows > 0 then
            local user_id = rows[1].id
            -- add identifiers
            for l,w in pairs(ids) do
              if not config.ignore_ip_identifier or (string.find(w, "ip:") == nil) then  -- ignore ip identifier
                MySQL.execute("vRP/add_identifier", {user_id = user_id, identifier = w})
              end
            end

            task({user_id})
          else
            task()
          end
        end)
      end
    end

    search()
  else
    task()
  end
end

-- return identification string for the source (used for non vRP identifications, for rejected players)
function vRP.getSourceIdKey(source)
  local ids = GetPlayerIdentifiers(source)
  local idk = "idk_"
  for k,v in pairs(ids) do
    idk = idk..v
  end

  return idk
end

function vRP.getPlayerEndpoint(player)
  return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.getPlayerName(player)
  return GetPlayerName(player) or "unknown"
end

--- sql
function vRP.isBanned(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.query("vRP/get_banned", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].banned})
    else
      task()
    end
  end)
end

--- sql
function vRP.setBanned(user_id,banned)
  MySQL.execute("vRP/set_banned", {user_id = user_id, banned = true})
end

--- sql
function vRP.isWhitelisted(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.query("vRP/get_whitelisted", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].whitelisted})
    else
      task()
    end
  end)
end

--- sql
function vRP.setWhitelisted(user_id,whitelisted)
  MySQL.execute("vRP/set_whitelisted", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function vRP.getLastLogin(user_id, cbr)
  local task = Task(cbr,{""})
  MySQL.query("vRP/get_last_login", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].last_login})
    else
      task()
    end
  end)
end

function vRP.setUData(user_id,key,value)
  MySQL.execute("vRP/set_userdata", {user_id = user_id, key = key, value = value})
end

function vRP.getUData(user_id,key,cbr)
  local task = Task(cbr,{""})

  MySQL.query("vRP/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

function vRP.setSData(key,value)
  MySQL.execute("vRP/set_srvdata", {key = key, value = value})
end

function vRP.getSData(key, cbr)
  local task = Task(cbr,{""})

  MySQL.query("vRP/get_srvdata", {key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

-- Delete Server Data (Usado em Garages, para remover o custom do carro)
function vRP.delSData(key)
  MySQL.execute("vRP/del_srvdata", {key = key})
end

function vRP.delUData(user_id,key)
  MySQL.execute("vRP/del_usrdata", {user_id = user_id, key = key})
end

-- return user data table for vRP internal persistant connected user storage
function vRP.getUserDataTable(user_id)
  return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
  return vRP.user_tmp_tables[user_id]
end

function vRP.isConnected(user_id)
  return vRP.rusers[user_id] ~= nil
end

function vRP.isFirstSpawn(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  if tmp then
    return tmp.spawns or 0
  end

  return 0
end

--function vRP.isFirstSpawn(user_id)
--  local tmp = vRP.getUserTmpTable(user_id)
--  return tmp and tmp.spawns == 1
--end

function vRP.getUserId(source)
  if source ~= nil then
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
      return vRP.users[ids[1]]
    end
  end

  return nil
end

-- return map of user_id -> player source
function vRP.getUsers()
  local users = {}
  for k,v in pairs(vRP.user_sources) do
    users[k] = v
  end

  return users
end

-- return source or nil
function vRP.getUserSource(user_id)
  return vRP.user_sources[user_id]
end

function vRP.ban(source,reason)
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    vRP.setBanned(user_id,true)
    vRP.kick(source,"[B2K Roleplay - Banned] "..reason)
  end
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
  SetTimeout(config.save_interval*1000, task_save_datatables)
  TriggerEvent("vRP:save")

  Debug.pbegin("vRP save datatables")
  for k,v in pairs(vRP.user_tables) do
    vRP.setUData(k,"vRP:datatable",json.encode(v))
  end

  Debug.pend()
  
end
task_save_datatables()

--[[local max_pings = math.ceil(config.ping_timeout*60/30)+1
function task_timeout() -- kick users not sending ping event in 2 minutes
  local users = vRP.getUsers()
  for k,v in pairs(users) do
    local tmpdata = vRP.getUserTmpTable(tonumber(k))
    if tmpdata.pings == nil then
      tmpdata.pings = 0
    end

    tmpdata.pings = tmpdata.pings+1
    if tmpdata.pings >= max_pings then
      vRP.kick(v,"[B2K] Ping timeout.")
    end
  end

  SetTimeout(30000, task_timeout)
end
task_timeout()

function tvRP.ping()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local tmpdata = vRP.getUserTmpTable(user_id)
    tmpdata.pings = 0 -- reinit ping countdown
  end
end]]

local playerCount = 0
local list = {}

RegisterServerEvent('b2k:playerActivated')
AddEventHandler('b2k:playerActivated', function()
  if not list[source] then
    playerCount = playerCount + 1
    list[source] = true
  end
end)


-- handlers

--AddEventHandler("playerConnecting",function(name,setMessage, deferrals) -- old
AddEventHandler("queue:playerConnecting",function(source, ids, name, setKickReason, deferrals)
  deferrals.defer()
  
  local source = source
  Debug.pbegin("playerConnecting")
  local ids = ids --GetPlayerIdentifiers(source)
  local cv = GetConvarInt('sv_maxclients', 32)
  
  if ids ~= nil and #ids > 0 then
    deferrals.update("[B2K] Checando Identificadores (Contas Steam e Rockstar)...")
    vRP.getUserIdByIdentifiers(ids, function(user_id)
      -- if user_id ~= nil and vRP.rusers[user_id] == nil then -- check user validity and if not already connected (old way, disabled until playerDropped is sure to be called)
      if user_id ~= nil then -- check user validity 
        deferrals.update("[B2K] Checando Banimento...")
        vRP.isBanned(user_id, function(banned)
          if not banned then
            deferrals.update("[B2K] Checando Whitelist...")
            vRP.isWhitelisted(user_id, function(whitelisted)
              if not config.whitelist or whitelisted then
      			    if playerCount >= cv then
                  deferrals.done('[B2K] Ops! O servidor está cheio! (' .. tostring(cv) .. ' players).')
        				else
        					Debug.pbegin("playerConnecting_delayed")
        					if vRP.rusers[user_id] == nil then -- not present on the server, init

        					  -- load user data table
        					  deferrals.update("[B2K] Carregando Dados...")
        					  vRP.getUData(user_id, "vRP:datatable", function(sdata)

          						-- init entries
          						vRP.users[ids[1]] = user_id
          						vRP.rusers[user_id] = ids[1]
          						vRP.user_tables[user_id] = {}
          						vRP.user_tmp_tables[user_id] = {}
          						vRP.user_sources[user_id] = source
          						
          						local data = json.decode(sdata)
          						if type(data) == "table" then vRP.user_tables[user_id] = data end

          						-- init user tmp table
          						local tmpdata = vRP.getUserTmpTable(user_id)

          						deferrals.update("[B2K] Carregando Último Login...")
          						vRP.getLastLogin(user_id, function(last_login)
          						  tmpdata.last_login = last_login or ""
          						  tmpdata.spawns = 0

          						  -- set last login
          						  local ep = vRP.getPlayerEndpoint(source)
          						  --local last_login_stamp = ep.." "..os.date("%H:%M:%S %d/%m/%Y")
          						  local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
          						  MySQL.execute("vRP/set_last_login", {user_id = user_id, last_login = last_login_stamp})

          						  -- trigger join
          						  print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") joined (user_id = "..user_id..")")
          						  TriggerEvent("vRP:playerJoin", user_id, source, name, tmpdata.last_login)
          						  --TriggerClientEvent('sendSession:PlayerConnecting', source)
                        
          						  SendWebhookMessage(ac_webhook_joins, "**vRP Join** \n```\nUser ID: "..user_id.."```")
          						  
          						  deferrals.done()
          						end)
        					  end)
      					else -- already connected
      					  print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") re-joined (user_id = "..user_id..")")

      					  -- reset first spawn
      					  local tmpdata = vRP.getUserTmpTable(user_id)
      					  tmpdata.spawns = 0
      					  
      					  TriggerEvent("vRP:playerRejoin", user_id, source, name)
      					  SendWebhookMessage(ac_webhook_joins, "**vRP Re-Join** \n```\nUser ID: "..user_id.."```")
      					  deferrals.done()
      					end
      					Debug.pend()
      				end
            else
              print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: not whitelisted (user_id = "..user_id..")")
      				for i = 1, 2 do
      				  deferrals.update("[B2K] Para entrar, acesse nosso Discord: bitou2k.com/discord e solicite liberação do seu ID: "..user_id.."")
                Citizen.Wait(500)
      				end
              deferrals.done("[B2K] Para entrar, acesse nosso Discord: bitou2k.com/discord e solicite liberação do seu ID: "..user_id.."")
      				TriggerEvent("queue:playerConnectingRemoveQueues", ids)
            end
          end)
          else
            print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: banned (user_id = "..user_id..")")
            deferrals.done("[B2K] Banido (ID: "..user_id..").")
            TriggerEvent("queue:playerConnectingRemoveQueues", ids)
          end
        end)
      else
        print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: identification error - Acesse nosso Discord: discord.gg/YsDpQ5H")
        deferrals.done("[B2K] Identification Error. (Steam, Rockstar)")
        TriggerEvent("queue:playerConnectingRemoveQueues", ids)
      end
    end)
  else
    print("[B2K] "..name.." ("..vRP.getPlayerEndpoint(source)..") rejected: missing identifiers - Acesse nosso Discord: discord.gg/YsDpQ5H")
    deferrals.done("[B2K] Missing identifiers. (Steam, Rockstar)")
    TriggerEvent("queue:playerConnectingRemoveQueues", ids)
  end
  Debug.pend()
end)

--[[AddEventHandler("playerDropped",function(reason)
  local source = source
  Debug.pbegin("playerDropped")

  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})


  if list[source] then
    playerCount = playerCount - 1
    list[source] = nil
  end
  
  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    TriggerEvent("vRP:playerLeave", user_id, source)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))
	
    local endpoint = vRP.getPlayerEndpoint(source)
    print("[B2K] "..endpoint.." disconnected (user_id = "..user_id..")")
	
    vRP.users[vRP.rusers[user_id = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil
	
    SendWebhookMessage(ac_webhook_joins, "**vRP Left** \n```\nUser ID: "..user_id.."```")
  end
  Debug.pend()
end)]]

AddEventHandler("playerDropped",function(reason)
  local source = source
  Debug.pbegin("playerDropped "..source)

  vRP.dropPlayer(source)
end)

-- drop vRP player/user (internal usage)
function vRP.dropPlayer(source)
  local user_id = vRP.getUserId(source)
  local endpoint = vRP.getPlayerEndpoint(source)

  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})

  -- Hardcap
  if list[source] then
    playerCount = playerCount - 1
    list[source] = nil
  end

  if user_id then
    TriggerEvent("vRP:playerLeave", user_id, source)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))

    print("[B2K] "..endpoint.." disconnected (user_id = "..user_id..")")

    vRP.users[vRP.rusers[user_id]] = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil

    SendWebhookMessage(ac_webhook_joins, "**vRP Left** \n```\nUser ID: "..user_id.."```")
  end
end

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
  Debug.pbegin("playerSpawned")
  -- register user sources and then set first spawn to false
  local user_id = vRP.getUserId(source)
  local player = source
  if user_id ~= nil then
    vRP.user_sources[user_id] = source
    local tmp = vRP.getUserTmpTable(user_id)
    tmp.spawns = tmp.spawns+1
    local first_spawn = (tmp.spawns == 1)

    if first_spawn then
      -- first spawn, reference player
      -- send players to new player
      for k,v in pairs(vRP.user_sources) do
        vRPclient.addPlayer(source,{v})
      end
      -- send new player to all players
      vRPclient.addPlayer(-1,{source})
    end

    -- set client tunnel delay at first spawn
    Tunnel.setDestDelay(player, config.load_delay)

    -- show loading
    vRPclient.setProgressBar(player,{"vRP:loading", "botright", "Carregando...", 0,0,0, 100})

    SetTimeout(2000, function()
      SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
        Tunnel.setDestDelay(player, config.global_delay)
        vRPclient.removeProgressBar(player,{"vRP:loading"})
      end)
    end)
	
	SetTimeout(2000, function() -- trigger spawn event
      TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)
    end)
  end

  Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")

Citizen.CreateThread(function()
	ac_webhook_joins = GetConvar("ac_webhook_joins", "none")
	ac_webhook_gameplay = GetConvar("ac_webhook_gameplay", "none")
	ac_webhook_bans = GetConvar("ac_webhook_bans", "none")
	ac_webhook_wl = GetConvar("ac_webhook_wl", "none")
	ac_webhook_arsenal = GetConvar("ac_webhook_arsenal", "none")
	ac_webhook_keys = GetConvar("ac_webhook_keys", "none")

	function SendWebhookMessage(webhook,message)
		if webhook ~= "none" then
			PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
		end
	end
end)