local htmlEntities = module("lib/htmlEntities")

local cfg = module("cfg/identity")
local lang = vRP.lang

local sanitizes = module("cfg/sanitizes")

-- this module describe the identity system

-- init sql
MySQL.createCommand("vRP/identity_tables", [[
CREATE TABLE IF NOT EXISTS vrp_user_identities(
  user_id INTEGER,
  registration VARCHAR(100),
  phone VARCHAR(100),
  nome VARCHAR(100),
  sobrenome VARCHAR(100),
  age INTEGER,
  CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
  CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE,
  INDEX(registration),
  INDEX(phone)
);
]])

MySQL.createCommand("vRP/get_user_identity","SELECT * FROM vrp_user_identities WHERE user_id = @user_id")
MySQL.createCommand("vRP/init_user_identity","INSERT IGNORE INTO vrp_user_identities(user_id,registration,phone,nome,sobrenome,age) VALUES(@user_id,@registration,@phone,@nome,@sobrenome,@age)")
MySQL.createCommand("vRP/update_user_identity","UPDATE vrp_user_identities SET nome = @nome, sobrenome = @sobrenome, age = @age, registration = @registration, phone = @phone WHERE user_id = @user_id")
MySQL.createCommand("vRP/get_userbyreg","SELECT user_id FROM vrp_user_identities WHERE registration = @registration")
MySQL.createCommand("vRP/get_userbyphone","SELECT user_id FROM vrp_user_identities WHERE phone = @phone")
MySQL.createCommand("vRP/update_user_first_spawn","UPDATE vrp_user_identities SET nome = @nome, sobrenome = @sobrenome, age = @age WHERE user_id = @user_id")

-- init
MySQL.execute("vRP/identity_tables")

-- api

-- cbreturn user identity
function vRP.getUserIdentity(user_id, cbr)
  local task = Task(cbr)

  MySQL.query("vRP/get_user_identity", {user_id = user_id}, function(rows, affected)
    task({rows[1]})
  end)
end

-- cbreturn user_id by registration or nil
function vRP.getUserByRegistration(registration, cbr)
  local task = Task(cbr)

  MySQL.query("vRP/get_userbyreg", {registration = registration or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

-- cbreturn user_id by phone or nil
function vRP.getUserByPhone(phone, cbr)
  local task = Task(cbr)

  MySQL.query("vRP/get_userbyphone", {phone = phone or ""}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].user_id})
    else
      task()
    end
  end)
end

function vRP.generateStringNumber(format) -- (ex: DDDLLL, D => digit, L => letter)
  local abyte = string.byte("A")
  local zbyte = string.byte("0")

  local number = ""
  for i=1,#format do
    local char = string.sub(format, i,i)
    if char == "D" then number = number..string.char(zbyte+math.random(0,9))
    elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
    else number = number..char end
  end

  return number
end

-- cbreturn a unique registration number
function vRP.generateRegistrationNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate registration number
    local registration = vRP.generateStringNumber(cfg.rg_format)
    vRP.getUserByRegistration(registration, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({registration})
      end
    end)
  end

  search()
end

-- cbreturn a unique phone number (0DDDDD, D => digit)
function vRP.generatePhoneNumber(cbr)
  local task = Task(cbr)

  local function search()
    -- generate phone number
    local phone = vRP.generateStringNumber(cfg.phone_format)
    vRP.getUserByPhone(phone, function(user_id)
      if user_id ~= nil then
        search() -- continue generation
      else
        task({phone})
      end
    end)
  end

  search()
end

-- events, init user identity at connection
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
  vRP.getUserIdentity(user_id, function(identity)
    if identity == nil then
      vRP.generateRegistrationNumber(function(registration)
        vRP.generatePhoneNumber(function(phone)
          MySQL.execute("vRP/init_user_identity", {
            user_id = user_id,
            registration = registration,
            phone = phone,
            nome = cfg.random_first_names[math.random(1,#cfg.random_first_names)],
            sobrenome = cfg.random_last_names[math.random(1,#cfg.random_last_names)],
            age = math.random(25,40)
          })
        end)
      end)
    end
  end)
end)

-- city hall menu

local cityhall_menu = {name=lang.cityhall.title(),css={top="75px", header_color="rgba(0,125,255,0.75)"}}

local function ch_identity(player,choice)
  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.prompt(player,lang.cityhall.identity.prompt_nome(),"",function(player,nome)
      if string.len(nome) >= 2 and string.len(nome) < 50 then
        nome = sanitizeString(nome, sanitizes.name[1], sanitizes.name[2])
        vRP.prompt(player,lang.cityhall.identity.prompt_sobrenome(),"",function(player,sobrenome)
          if string.len(sobrenome) >= 2 and string.len(sobrenome) < 50 then
            sobrenome = sanitizeString(sobrenome, sanitizes.name[1], sanitizes.name[2])
            vRP.prompt(player,lang.cityhall.identity.prompt_age(),"",function(player,age)
              age = parseInt(age)
              if age >= 16 and age <= 150 then

                local pricenewidentity = cfg.new_identity_cost
                if vRP.hasPermission(user_id,"vip.identity") then
                  pricenewidentity = 0
                end

                if vRP.tryPayment(user_id,pricenewidentity) then
                  vRP.generateRegistrationNumber(function(registration)
                    vRP.generatePhoneNumber(function(phone)

                      MySQL.execute("vRP/update_user_identity", {
                        user_id = user_id,
                        nome = nome,
                        sobrenome = sobrenome,
                        age = age,
                        registration = registration,
                        phone = phone
                      })

                      -- update client registration
                      vRPclient.setRegistrationNumber(player,{registration})
                      vRPclient.notify(player,{lang.money.paid({pricenewidentity})})
                    end)
                  end)
                else
                  vRPclient.notify(player,{lang.money.not_enough()})
                end
              else
                vRPclient.notify(player,{lang.common.invalid_value()})
              end
            end)
          else
            vRPclient.notify(player,{lang.common.invalid_value()})
          end
        end)
      else
        vRPclient.notify(player,{lang.common.invalid_value()})
      end
    end)
  end
end

cityhall_menu[lang.cityhall.identity.title()] = {ch_identity,lang.cityhall.identity.description({cfg.new_identity_cost})}

local function cityhall_enter()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    vRP.openMenu(source,cityhall_menu)
  end
end

local function cityhall_leave()
  vRP.closeMenu(source)
end

local function build_client_cityhall(source) -- build the city hall area/marker/blip
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local x,y,z = table.unpack(cfg.city_hall)

    vRPclient.addBlip(source,{x,y,z,cfg.blip[1],cfg.blip[2],lang.cityhall.title()})
    vRPclient.addMarker(source,{x,y,z,1.5,1.5,0.7,0,255,125,125,150})

    vRP.setArea(source,"vRP:cityhall",x,y,z,1,1.5,cityhall_enter,cityhall_leave)
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  -- send registration number to client at spawn
  vRP.getUserIdentity(user_id, function(identity)
    if identity then
      vRPclient.setRegistrationNumber(source,{identity.registration or "AA000AAA"})
    end
  end)

  -- first spawn, build city hall
  if first_spawn then
    build_client_cityhall(source)
  end
end)

-- player identity menu

-- add identity to main menu
vRP.registerMenuBuilder("main", function(add, data)
  local player = data.player

  local user_id = vRP.getUserId(player)
  if user_id ~= nil then
    vRP.getUserIdentity(user_id, function(identity)

      if identity then
        -- generate identity content
        -- get address
        vRP.getUserAddress(user_id, function(address)
          local home = ""
          local number = ""
          if address then
            home = address.home
            number = address.number
          end
		  
          local job = vRP.getUserGroupByType(user_id,"job")
          if (job == nil or job == "") then job = "Nenhum" end
	  
          local content = lang.cityhall.menu.info({htmlEntities.encode(identity.nome),htmlEntities.encode(identity.sobrenome),identity.age,identity.registration,identity.phone,home,number,job})
          local choices = {}
          choices[lang.cityhall.menu.title()] = {function()end, content}

          add(choices)
        end)
      end
    end)
  end
end)
