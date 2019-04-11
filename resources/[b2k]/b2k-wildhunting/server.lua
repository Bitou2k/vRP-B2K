-- DEFAULT --
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

RegisterServerEvent("b2k:tryStartWildHunterJob")
AddEventHandler("b2k:tryStartWildHunterJob", function()
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		--if vRP.hasPermission({user_id,"job.wildhunting"}) then -- "job.wildhunting"
			vRPclient.giveWeapons(player,{{
				["WEAPON_MUSKET"] = {ammo=100}, -- MUSKET    
			}, false})
			TriggerClientEvent("b2k:StartWildHunterJob", player)
		--else
		--	vRPclient.notify(player,{"~w~Você não é um ~r~Caçador~w~."})
		--end
	end
end)

local collect_seq = {
	{"oddjobs@hunter","idle_a",1},
	{"oddjobs@hunter","exit",1}
}

RegisterServerEvent("b2k:tryToCollectMeat")
AddEventHandler("b2k:tryToCollectMeat", function(v, animalModelSent)
	local user_id = vRP.getUserId({source})
	if user_id ~= nil then
		local player = vRP.getUserSource({user_id})
		--if vRP.hasPermission({user_id,"job.wildhunting"}) then
			
			local amount = 0
			local itemIdname = "carnesilvestre" -- default -- legal: carnelegal
			
			if animalModelSent == "a_c_boar" then amount = 2 end
			if animalModelSent == "a_c_cow" then amount = 2 end
			if animalModelSent == "a_c_coyote" then amount = 2 end
			
			if animalModelSent == "a_c_chickenhawk" then amount = 1 end
			if animalModelSent == "a_c_mtlion" then amount = 3 end
			if animalModelSent == "a_c_pig" then amount = 1 end
			if animalModelSent == "a_c_pigeon" then amount = 1 end
			if animalModelSent == "a_c_deer" then
				amount = 2
				itemIdname = "carnelegal"
			end
			if animalModelSent == "a_c_rabbit_01" then
				amount = 1
				itemIdname = "carnelegal"
			end
			if animalModelSent == "a_c_rat" then amount = 1 end
			if animalModelSent == "a_c_cormorant" then amount = 1 end
			
			local new_weight = vRP.getInventoryWeight({user_id})+vRP.getItemWeight({itemIdname})*amount
            if new_weight <= vRP.getInventoryMaxWeight({user_id}) then
				SetTimeout(5000, function()
					TriggerClientEvent("b2k:syncRemovedEntity", -1, v)
					vRP.giveInventoryItem({user_id, itemIdname, amount, true})
					vRPclient.playSound(player,{"WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET"})
				end)
            else
              vRPclient.notify(player,{"Inventário cheio."})
            end
		--end
	end
end)