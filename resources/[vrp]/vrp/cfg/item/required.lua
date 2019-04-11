
local items = {}

-- Venda Olhos
items["vendaolhos"] = {"Venda os Olhos","Coloca uma venda (pano) no rosto de um jogador próximo.",function(args)
	local choices = {}
	local idname = args[1]
	choices["Usar"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id then
			vRPclient.isInComa(player,{}, function(in_coma)
				if in_coma then
					vRPclient.notify(player,{"Você está em coma."})
				else
					vRPclient.getNearestPlayer(player,{10},function(nplayer)
						local nuser_id = vRP.getUserId(nplayer)
						if nuser_id ~= nil then
							vRPclient.isHandcuffed(nplayer,{}, function(handcuffed)
								if handcuffed then
									if vRP.tryGetInventoryItem(user_id, idname, 1, true) then
										vRPclient.setarVendado(nplayer,{})
										vRPclient.notify(player,{"Você vendou um jogador próximo."})
										vRP.closeMenu(player)
									end
								else
									vRPclient.notify(player,{vRP.lang.police.not_handcuffed()})
								end
							end)
						else
							vRPclient.notify(player,{vRP.lang.common.no_player_near()})
						end
					end)
				end
			end)
		end
	end}
	
	choices["Retirar"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id then
			vRPclient.isInComa(player,{}, function(in_coma)
				if in_coma then
					vRPclient.notify(player,{"Você está em coma."})
				else
					vRPclient.getNearestPlayer(player,{10},function(nplayer)
						local nuser_id = vRP.getUserId(nplayer)
						if nuser_id ~= nil then
							vRPclient.isVendado(nplayer,{}, function(vendado)
								if vendado then
									if vRP.tryGetInventoryItem(user_id, idname, 1, true) then
										vRPclient.removerVendado(nplayer,{})
										vRPclient.notify(player,{"Você retirou a venda no rosto de um jogador próximo."})
										vRP.closeMenu(player)
									end
								else
									vRPclient.notify(player,{"O jogador não está vendado."})
								end
							end)
						else
							vRPclient.notify(player,{vRP.lang.common.no_player_near()})
						end
					end)
				end
			end)
		end
	end}
  
  return choices
end, 0.5,"Ferramenta: <span class='job-item'>Venda os Olhos</span>"}

-- Algemas
items["algemas"] = {"Algemas","Algema/Desalgema um jogador próximo.",function(args)
	local choices = {}
	local idname = args[1]
	
	choices["Algemar/Desalgemar"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id then
			vRPclient.isInComa(player,{}, function(in_coma)
				if in_coma then
					vRPclient.notify(player,{"Você está em coma."})
				else
					vRPclient.getNearestPlayer(player,{4},function(nplayer)
						local nuser_id = vRP.getUserId(nplayer)
						if nuser_id ~= nil then
							if vRP.tryGetInventoryItem(user_id, idname, 1, true) then
								vRPclient.toggleHandcuff(nplayer,{})
								vRPclient.notify(player,{"Você algemou/desalgemou um jogador próximo."})
								vRP.closeMenu(player)
							end
						else
							vRPclient.notify(player,{vRP.lang.common.no_player_near()})
						end
					end)
				end
			end)
		end
	end}
  
  return choices
end, 4.0,"Ferramenta: <span class='job-item'>Algemas</span>"}
-- 

-- Scuba Gear 
items["scubagear"] = {"Traje de Mergulho","Para mergulhar nas profundezas.",function(args)
	local choices = {}
	local idname = args[1]
  
	choices["Equipar/Desequipar"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id then
			vRPclient.isInComa(player,{}, function(in_coma)
				if in_coma then
					vRPclient.notify(player,{"Você está em coma."})
				else
					if vRP.getInventoryItemAmount(user_id, idname) < 1 then
						vRPclient.notify(player,{"Você não tem o Traje de Mergulho"})
					else
						TriggerClientEvent("b2k:scubaGear", player)
						vRP.closeMenu(player)
					end
				end
			end)
		end
	end}
  
	choices["Trash"] = {function(player,choice)
		local user_id = vRP.getUserId(player)
		if user_id then
			vRPclient.isInComa(player,{}, function(in_coma)
				if in_coma then
					vRPclient.notify(player,{"Você está em coma."})
				else
					if vRP.getInventoryItemAmount(user_id, idname) < 1 then
						vRPclient.notify(player,{"Você não tem o Traje de Mergulho"})
					else
						-- prompt number
						vRP.prompt(player,vRP.lang.inventory.trash.prompt({vRP.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
							local amount = parseInt(amount)
							if vRP.tryGetInventoryItem(user_id,idname,amount,false) then
								TriggerClientEvent("b2k:scubaGearClear", player)
								vRPclient.notify(player,{vRP.lang.inventory.trash.done({vRP.getItemName(idname),amount})})
								vRPclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
								vRP.closeMenu(player)
							else
								vRPclient.notify(player,{vRP.lang.common.invalid_value()})
							end
						end)
					end
				end
			end)
		end
	end}

  return choices
end, 5.0,"Ferramenta: <span class='job-item'>Traje de Mergulho</span>"}


items["medkit"] = {"Kit Médico","Usado para reanimar pessoas em coma.",nil, 0.1, "Emprego: <span class='job-item'>Kit Médico</span>"}
items["dirty_money"] = {"Dinheiro Sujo","Dinheiro ganho ilegalmente.",nil, 0, "Ilegal: <span class='ilegal-item'>Dinheiro Sujo</span>"}
items["niobio"] = {"Nióbio Ilegal","Nióbio extraído ilegalmente.",nil, 0, nil}
items["repairkit"] = {"Kit Reparador","Usado para reparar veículos.",nil,0.5, "Emprego: <span class='job-item'>Kit Reparador</span>"}


-- money
items["money"] = {"Dinheiro","Dinheiro empacotado.",function(args)
  local choices = {}
  local idname = args[1]

  choices["Desempacotar"] = {function(player,choice,mod)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      local amount = vRP.getInventoryItemAmount(user_id, idname)
      vRP.prompt(player, "Quantidade a desempacotar ? (max "..amount..")", "", function(player,ramount)
        ramount = parseInt(ramount)
        if vRP.tryGetInventoryItem(user_id, idname, ramount, true) then -- unpack the money
          vRP.giveMoney(user_id, ramount)
          vRP.closeMenu(player)
        end
      end)
    end
  end}

  return choices
end,0, "Pacote: <span class='food-item'>Dinheiro</span>"}

-- money binder
items["money_binder"] = {"Money binder","Used to bind 1000$ of money.",function(args)
  local choices = {}
  local idname = args[1]

  choices["Bind money"] = {function(player,choice,mod) -- bind the money
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      local money = vRP.getMoney(user_id)
      if money >= 1000 then
        if vRP.tryGetInventoryItem(user_id, idname, 1, true) and vRP.tryPayment(user_id,1000) then
          vRP.giveInventoryItem(user_id, "money", 1000, true)
          vRP.closeMenu(player)
        end
      else
        vRPclient.notify(player,{vRP.lang.money.not_enough()})
      end
    end
  end}

  return choices
end,0}

-- parametric weapon items
-- give "wbody|WEAPON_PISTOL" and "wammo|WEAPON_PISTOL" to have pistol body and pistol bullets

local get_wname = function(weapon_id)
  local name = string.gsub(weapon_id,"WEAPON_","")
  name = string.upper(string.sub(name,1,1))..string.lower(string.sub(name,2))
  return name
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2]).." Arma"
end

local wbody_desc = function(args)
  return ""
end

local wbody_itemlistname = function(args)
  return "Arma: <span class='ilegal-item'>".. get_wname(args[2]).."</span>"
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Equipar"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      vRPclient.isInComa(player,{}, function(in_coma)
        if in_coma then
        	vRPclient.notify(player,{"Você está em coma."})
        else
			if vRP.tryGetInventoryItem(user_id, fullidname, 1, true) then -- give weapon body
				local weapons = {}
				weapons[args[2]] = {ammo = 0}
				vRPclient.giveWeapons(player, {weapons})

				vRP.closeMenu(player)
			end
        end
      end)

    end
  end}

  return choices
end

local wbody_weight = function(args)
  return 0.75
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight,wbody_itemlistname}

--- weapon ammo
local wammo_name = function(args)
  return get_wname(args[2]).." Munição"
end

local wammo_desc = function(args)
  return ""
end

local wammo_itemlistname = function(args)
  return "Munição: <span class='ilegal-item'>".. get_wname(args[2]).."</span>"
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")

  choices["Carregar"] = {function(player,choice)
    local user_id = vRP.getUserId(player)
    if user_id ~= nil then
      local amount = vRP.getInventoryItemAmount(user_id, fullidname)
      vRP.prompt(player, "Quantidade a Carregar ? (max "..amount..")", "" .. amount, function(player,ramount)
        ramount = parseInt(ramount)
        
        if ramount > 250 then ramount = 250 end
        if ramount < 1 then ramount = 1 end

        vRPclient.getWeapons(player, {}, function(uweapons)
          if uweapons[args[2]] ~= nil then -- check if the weapon is equiped
            if vRP.tryGetInventoryItem(user_id, fullidname, ramount, true) then -- give weapon ammo
              local weapons = {}
              weapons[args[2]] = {ammo = ramount}
              vRPclient.giveWeapons(player, {weapons,false})
              vRP.closeMenu(player)
            end
          end
        end)
      end)
    end
  end}

  return choices
end

local wammo_weight = function(args)
  return 0.01
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight,wammo_itemlistname}

return items
