-- define some basic inventory items

local items = {}

local function play_eat(player)
  local seq = {
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp",1},
    {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

local function play_drink(player)
  local seq = {
    {"mp_player_intdrink","intro_bottle",1},
    {"mp_player_intdrink","loop_bottle",1},
    {"mp_player_intdrink","outro_bottle",1}
  }

  vRPclient.playAnim(player,{true,seq,false})
end

-- gen food choices as genfunc
-- idname
-- ftype: eat or drink
-- vary_hunger
-- vary_thirst
local function gen(ftype, vary_hunger, vary_thirst)
  local fgen = function(args)
    local idname = args[1]
    local choices = {}
    local act = "Unknown"
    if ftype == "eat" then act = "Comer" elseif ftype == "drink" then act = "Beber" end
    local name = vRP.getItemName(idname)

    choices[act] = {function(player,choice)
      local user_id = vRP.getUserId(player)
      if user_id ~= nil then
        if vRP.tryGetInventoryItem(user_id,idname,1,false) then
          if vary_hunger ~= 0 then vRP.varyHunger(user_id,vary_hunger) end
          if vary_thirst ~= 0 then vRP.varyThirst(user_id,vary_thirst) end

          if ftype == "drink" then
            vRPclient.notify(player,{"~b~ Bebendo "..name.."."})
            play_drink(player)
          elseif ftype == "eat" then
            vRPclient.notify(player,{"~o~ Comendo "..name.."."})
            play_eat(player)
          end

          vRP.closeMenu(player)
        end
      end
    end}

    return choices
  end

  return fgen
end

-- DRINKS --

items["water"] = {"Garrafa de Agua" ,"", gen("drink",0,-25),0.5, "<span class='food-item'>Garrafa de Agua</span>"}
items["milk"] = {"Leite" ,"", gen("drink",0,-5),0.5, "<span class='food-item'>Leite</span>"}
items["coffee"] = {"Café" ,"", gen("drink",0,-10),0.2, "<span class='food-item'>Café</span>"}
items["tea"] = {"Chá" ,"", gen("drink",0,-15),0.2, "<span class='food-item'>Chá</span>"}
items["icetea"] = {"Chá-Gelado" ,"", gen("drink",0,-20), 0.5, "<span class='food-item'>Chá-Gelado</span>"}
items["orangejuice"] = {"Suco de Laranja" ,"", gen("drink",0,-25),0.5, "<span class='food-item'>Suco de Laranja</span>"}
items["gocagola"] = {"Coca-Cola" ,"", gen("drink",0,-35),0.3, "<span class='food-item'>Coca-Cola</span>"}
items["redgull"] = {"Red Bull" ,"", gen("drink",0,-40),0.3, "<span class='food-item'>Red Bull</span>"}
items["lemonlimonad"] = {"Limonada" ,"", gen("drink",0,-45),0.3, "<span class='food-item'>Limonada</span>"}
items["vodka"] = {"Vodka" ,"", gen("drink",15,-65),0.5, "<span class='food-item'>Vodka</span>"}

--FOOD

-- create Breed item
items["bread"] = {"Pão", "", gen("eat",-10,0),0.5, "<span class='food-item'>Pão</span>"}
items["donut"] = {"Donut", "", gen("eat",-15,0),0.2, "<span class='food-item'>Donut</span>"}
items["tacos"] = {"Tacos", "", gen("eat",-20,0),0.2, "<span class='food-item'>Tacos</span>"}
items["sandwich"] = {"Sanduiche", "A tasty snack.", gen("eat",-25,0),0.5, "<span class='food-item'>Sanduiche</span>"}
items["kebab"] = {"Kebab", "", gen("eat",-45,0),0.85, "<span class='food-item'>Kebab</span>"}
items["pdonut"] = {"Premium Donut", "", gen("eat",-25,0),0.5, "<span class='food-item'>Premium Donut</span>"}
items["catfish"] = {"Catfish", "", gen("eat",10,15),0.3, "<span class='food-item'>Catfish</span>"}
items["bass"] = {"Bass", "", gen("eat",10,15),0.3, "<span class='food-item'>Bass</span>"}

-- Tower Item
items["lasanha"] = {"Lasanha","", gen("eat",-50,-50),1.0}
items["feijoada"] = {"Feijoada","", gen("eat",-80,30),1.0}
items["vitamina"] = {"Vitamina","", gen("drink",10,-80),1.0}
items["refeicao"] = {"Refeição Completa","", gen("eat",-100,-100),2.0}
items["ceianatalina"] = {"Ceia Natalina","", gen("eat",-100,-100),2.0,"<span class='food-item'>Ceia Natalina</span>"}

return items
