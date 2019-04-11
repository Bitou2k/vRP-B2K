
-- this module define the emotes menu

local cfg = module("cfg/emotes")
local lang = vRP.lang


local emotes_porns = cfg.emotes_porns
local emotes_festivo = cfg.emotes_festivo
local emotes_gestos = cfg.emotes_gestos
local emotes_sports = cfg.emotes_sports

-- add emotes menu to main menu

vRP.registerMenuBuilder("main", function(add, data)
  local choices = {}
  choices[lang.emotes.title()] = {function(player, choice)
    -- build emotes menu
    local menu = {name=lang.emotes.title(),css={top="75px",header_color="rgba(0,125,255,0.75)"}}
    local user_id = vRP.getUserId(player)

    if user_id ~= nil then
	  
		menu["Porn"] = {function(player,choice)
			local submenu = {name="Porn",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
			submenu.onclose = function() vRP.openMenu(player,menu) end
			
			local ch_emote = function(player,choice)
				local emote = emotes_porns[choice]
				if emote then
					vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
				end
			end
			
			for k,v in pairs(emotes_porns) do
				if vRP.hasPermissions(user_id, v.permissions or {}) then
					submenu[k] = {ch_emote}
				end
			end
			vRP.openMenu(player,submenu)
		end, "Emotes Pornográficos"}
		
		menu["Sports"] = {function(player,choice)
			local submenu = {name="Sports",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
			submenu.onclose = function() vRP.openMenu(player,menu) end
			
			local ch_emote = function(player,choice)
				local emote = emotes_sports[choice]
				if emote then
					vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
				end
			end
			
			for k,v in pairs(emotes_sports) do
				if vRP.hasPermissions(user_id, v.permissions or {}) then
					submenu[k] = {ch_emote}
				end
			end
			vRP.openMenu(player,submenu)
		end, "Emotes Esportivos"}
		
		menu["Gestos"] = {function(player,choice)
			local submenu = {name="Gestos",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
			submenu.onclose = function() vRP.openMenu(player,menu) end
			
			local ch_emote = function(player,choice)
				local emote = emotes_gestos[choice]
				if emote then
					vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
				end
			end
			
			for k,v in pairs(emotes_gestos) do
				if vRP.hasPermissions(user_id, v.permissions or {}) then
					submenu[k] = {ch_emote}
				end
			end
			vRP.openMenu(player,submenu)
		end, "Emotes Gesticulares"}
		
		menu["Festivo"] = {function(player,choice)
			local submenu = {name="Festivo",css={top="75px",header_color="rgba(0,125,255,0.75)"}}
			submenu.onclose = function() vRP.openMenu(player,menu) end
			
			local ch_emote = function(player,choice)
				local emote = emotes_festivo[choice]
				if emote then
					vRPclient.playAnim(player,{emote[1],emote[2],emote[3]})
				end
			end
			
			for k,v in pairs(emotes_festivo) do
				if vRP.hasPermissions(user_id, v.permissions or {}) then
					submenu[k] = {ch_emote}
				end
			end
			vRP.openMenu(player,submenu)
		end, "Emotes Festivos"}

    end

    -- clear current emotes
    menu[lang.emotes.clear.title()] = {function(player,choice)
      vRPclient.stopAnim(player,{true}) -- upper
      vRPclient.stopAnim(player,{false}) -- full
    end, lang.emotes.clear.description()}

    vRP.openMenu(player,menu)
  end}
  add(choices)
end)
