
-- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vrp_barbershop")

-- RESOURCE TUNNEL/PROXY
vRPbs = {}
Tunnel.bindInterface("vrp_barbershop",vRPbs)
Proxy.addInterface("vrp_barbershop",vRPbs)
BSclient = Tunnel.getInterface("vrp_barbershop", "vrp_barbershop")

-- CFG
local cfg = module("vrp_barbershop", "cfg/barbershop")
local barbershops = cfg.barbershops

-- LANG
local Lang = module("vrp", "lib/Lang")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

-- open the skin shop for the specified ped parts
-- name = partid
function vRPbs.openBarbershop(source,parts)
	local user_id = vRP.getUserId({source})
	if user_id then

		-- get old customization to compute the price
		BSclient.getOverlay(source, {}, function(overlay)
			local old_custom = overlay
			
			-- start building menu
			local menudata = {
				name=cfg.barbershops_title,
				css={top="75px", header_color="rgba(0,255,125,0.75)"}
			}

			local drawables = {}
			local textures = {}

			local ontexture = function(player, choice)
				-- change texture
				local texture = textures[choice]
				texture[1] = texture[1]+1
				if texture[1] >= texture[2] then texture[1] = 0 end -- circular selection

				-- apply change
				BSclient.getOverlay(source, {}, function(overlay)
					local custom = overlay
					custom[""..parts[choice]] = {drawables[choice][1],texture[1]}
					BSclient.setOverlay(source,{custom})
				end)
			end

			local ondrawable = function(player, choice, mod)
				if mod == 0 then -- tex variation
					ontexture(player,choice)
				else
					-- change drawable
					local drawable = drawables[choice]
					drawable[1] = drawable[1]+mod

					if isprop then
						if drawable[1] >= drawable[2] then drawable[1] = -1 -- circular selection (-1 for prop parts)
						elseif drawable[1] < -1 then drawable[1] = drawable[2]-1 end 
					else
						if drawable[1] >= drawable[2] then drawable[1] = 0 -- circular selection
						elseif drawable[1] < 0 then drawable[1] = drawable[2] end 
					end

					-- apply change
					BSclient.getOverlay(source, {}, function(overlay)
						local custom = overlay
						custom[""..parts[choice]] = {drawable[1],textures[choice][1]}
						BSclient.setOverlay(source,{custom})

						-- update max textures number
						BSclient.getTextures(source,{drawable[1]}, function(n) 
							textures[choice][2] = n

							if textures[choice][1] >= n then
							textures[choice][1] = 0 -- reset texture number
							end
						end)
					end)
				end
			end

			for k,v in pairs(parts) do -- for each part, get number of drawables and build menu
				drawables[k] = {0,0} -- {current,max}
				textures[k] = {0,0}  -- {current,max}

				-- init using old customization
				local old_part = old_custom[v]
				if old_part then
					drawables[k][1] = old_part[1]
					textures[k][1] = old_part[2]
				end

				-- get max drawables
				BSclient.getDrawables(source,{v},function(n)
					drawables[k][2] = n
				end) -- set max

				-- get max textures for this drawable
				BSclient.getTextures(source,{v},function(n)
					textures[k][2] = n 
				end) -- set max

				-- add menu choices
				menudata[k] = {ondrawable}
			end

			menudata.onclose = function(player)
				-- compute price
				BSclient.getOverlay(source,{}, function(overlay) 
					local custom = overlay
					local price = 0
					for k,v in pairs(custom) do
						local old = old_custom[k]

						if v[1] ~= old[1] then price = price + cfg.drawable_change_price end -- change of drawable
						if v[2] ~= old[2] then price = price + cfg.texture_change_price end -- change of texture
					end
					if price > 0 then
						if vRP.tryPayment({user_id,price}) then
							vRPclient.notify(source,{lang.money.paid({price})})
							vRP.setUData({user_id,"vRP:barbershop",json.encode(custom)})
						else
							vRPclient.notify(source,{lang.money.not_enough()})
							-- revert changes
							BSclient.setOverlay(source,{old_custom})
						end
					end
				end)
			end
			
			-- set default overlay
			menudata["> Resetar"] = {function(player, choice)
				BSclient.resetOverlay(source,{})
			end, "Reseta a Aparência para o Padrão"}

			-- open menu
			vRP.openMenu({source,menudata})
		end)
	end
end


local function build_client_barbershops(source)
  local user_id = vRP.getUserId({source})
  if user_id ~= nil then
    for k,v in pairs(barbershops) do
      local parts,x,y,z = table.unpack(v)

      local barbershop_enter = function(source)
        vRPbs.openBarbershop(source,parts)
      end

      local function barbershop_leave(source)
        vRP.closeMenu({source})
      end

	  vRPclient.addBlip(source,{x,y,z,71,13,cfg.barbershops_title})
      vRPclient.addMarker(source,{x,y,z,1.5,1.5,0.7,0,255,125,125,150})
	  
      vRP.setArea({source,"vRP:barbershop"..k,x,y,z,1,1.5,barbershop_enter,barbershop_leave})
    end
  end
end

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
  if first_spawn then
    build_client_barbershops(source)
    local custom = {}
    vRP.getUData({user_id,"vRP:barbershop", function(value) 
		if value ~= nil then
		  custom = json.decode(value)
		  BSclient.setOverlay(source,{custom})
		end
	end})
  end
end)

-- ADMIN BUTTON
ch_display_custom = {function(player, choice)
	BSclient.getOverlay(player, {}, function(overlay)
		local custom = overlay
		local content = "cfg.default = { \n"
		for k,v in pairs(custom) do
			content = content.."[\""..k.."\"] = {"..v[1]..","..v[2].."},".."\n" 
		end
		content = content.."}"
		vRP.prompt({player,"Head Overlay (Press CTRL+A and CTRL+C to copy):",content,function(ok) end})
	end)
end, cfg.barbershops_title}

vRP.registerMenuBuilder({"admin", function(add, data)
    local user_id = vRP.getUserId({data.player})
    if user_id ~= nil then
		local choices = {}

		if vRP.hasPermission({user_id,"player.display_overlays"}) then
			choices["Display Overlays"] = ch_display_custom
		end

		add(choices)
    end
end})