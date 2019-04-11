--[[
    FiveM Scripts
    Copyright C 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    at your option any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local htmlEntities = module("vrp", "lib/htmlEntities")
vRPhk = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_hotkeys")
HKclient = Tunnel.getInterface("vrp_hotkeys","vrp_hotkeys")
Tunnel.bindInterface("vrp_hotkeys",vRPhk)
-- USE FOR NECESSARY SERVER FUNCTIONS

local Lang = module("vrp", "lib/Lang")
local cfg = module("vrp", "cfg/base")
local lang = Lang.new(module("vrp", "cfg/lang/"..cfg.lang) or {})

function vRPhk.test(msg)
  print("msg "..msg.." received from "..source)
  return 42
end

function vRPhk.toggleHandcuff()
  local user_id = vRP.getUserId({source})
  if vRP.hasPermission({user_id,"police.base"}) then
    vRPclient.getNearestPlayer(source,{4},function(nplayer)
      local nuser_id = vRP.getUserId({nplayer})
      if nuser_id ~= nil then
        vRPclient.toggleHandcuff(nplayer,{})
        vRP.closeMenu({nplayer})
		vRPclient.notify(source,{"Você algemou/desalgemou um jogador próximo."})
		vRPclient.notify(nplayer,{"Você foi algemado/desalgemado."})
      else
        vRPclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

function vRPhk.sendQTHPolice(x,y,z)
  local user_id = vRP.getUserId({source})
  if user_id and vRP.hasPermission({user_id,"police.base"}) then
     
    vRP.getUserIdentity({user_id, function(identity)
		vRP.sendServiceAlert({source,"Policia",x,y,z,"QTH " .. identity.nome .. " " .. identity.sobrenome}) -- people will change this message anyway haha
	end})
  end
end

function vRPhk.docsOnline()
  local docs = vRP.getUsersByPermission({"emergency.revive"})
  return #docs
end

function vRPhk.canSkipComa(p1,p2)
  local user_id = vRP.getUserId({source})
  return vRP.hasPermission({user_id,p1}), vRP.hasPermission({user_id,p2})
end

function vRPhk.helpComa(x,y,z)
  vRP.sendServiceAlert({source,"emergency",x,y,z,"Help! I've fallen and can't get up!"}) -- people will change this message anyway haha
end

local vehStorage = {}
function vRPhk.canUserLockVehicle(plate, vehicleId, isPlayerInside)
	local player = source
	playerIdentifier = GetPlayerIdentifiers(player)[1]
	local randomMsg = {	"You have found the keys on the sun-shield",
     				"You found the keys in the glove box.",
    				"You found the keys on the passenger seat.",
    				"You found the keys on the floor.",
    				"The keys were already on the contact, you took them."}

   	result = 0
	for i=1, #(vehStorage) do
		if vehStorage[i].plate == plate then
			result = result + 1
			if vehStorage[i].owner == playerIdentifier then
				HKclient.lockVehicle(player,{vehStorage[i].lockStatus, vehStorage[i].id})
				break
			else
				vRPclient.notifyPicture(player,{"CHAR_LIFEINVADER", 3, "LockSystem", "vRP Hotkeys", "You don't have the key of this vehicle."})
				break
			end
		end
	end

	if result == 0 and isPlayerInside then

		length = #(randomMsg)
		randomNbr = math.random(1, tonumber(length))
		vRPclient.notifyPicture(player,{"CHAR_LIFEINVADER", 3, "LockSystem", "vRP Hotkeys", randomMsg[randomNbr]})
		
		table.insert(vehStorage, {plate=plate, owner=playerIdentifier, lockStatus=0, id=vehicleId})
	end
end

function vRPhk.lockSystemUpdate(param, plate)
    for i=1, #(vehStorage) do
		if vehStorage[i].plate == plate then
            vehStorage[i].lockStatus = param
            break
		end
	end
end

function vRPhk.playSoundWithinDistanceOfCoordsForEveryone(x, y, z, maxDistance, soundFile, soundVolume)
	local users = vRP.getUsers({})
    for k,v in pairs(users) do
	  HKclient.playSoundWithinDistanceOfCoords(v,{x, y, z, maxDistance, soundFile, soundVolume})
	end
end

function vRPhk.openPlayerList()
	local PlayerList = {}
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		local users = vRP.getUsers({})
		for k,v in pairs(users) do
			local user_source = vRP.getUserSource({k})
			if user_source ~= nil then
        local username = vRP.getPlayerName({user_source})
        if username ~= "unknown" then
				  PlayerList[k] = username
        end
			end
		end
		HKclient.showScoreboard(player,{PlayerList})
	end
end

local player_lists = {}
function vRPhk.openUserList()
  local player = source
  local user_id = vRP.getUserId({player})
  if user_id ~= nil then
    if player_lists[player] then -- hide
      player_lists[player] = nil
      vRPclient.removeDiv(player,{"user_list"})
    else -- show
      local content = "<span class=\"id\">ID</span><span class=\"pseudo\">NICKNAME</span><span class=\"name\">ROLEPLAY NAME</span><span class=\"job\">PROFESSION</span>"
      local count = 0
	  local users = vRP.getUsers({})
      for k,v in pairs(users) do
        count = count+1
        local user_source = vRP.getUserSource({k})
        vRP.getUserIdentity({k, function(identity)
		  if user_source ~= nil then
            content = content.."<br /><span class=\"id\">"..k.."</span><span class=\"pseudo\">"..vRP.getPlayerName({user_source}).."</span>"
            if identity then
              content = content.."<span class=\"name\">"..htmlEntities.encode(identity.nome).." "..htmlEntities.encode(identity.sobrenome).."</span><span class=\"job\">"..vRP.getUserGroupByType({k,"job"}).."</span>"
            end
          end
		  
          -- check end
          count = count-1
          if count == 0 then
            player_lists[player] = true
            local css = [[
              .div_user_list{ 
                margin: auto; 
				text-align: left;
                padding: 8px; 
                width: 650px; 
                margin-top: 100px; 
                background: rgba(50,50,50,0.0); 
                color: white; 
                font-weight: bold; 
                font-size: 1.1em;
              } 
              .div_user_list span{ 
				display: inline-block;
				text-align: center;
              } 
              .div_user_list .id{ 
                color: rgb(255, 255, 255);
                width: 45px; 
              }
              .div_user_list .pseudo{ 
                color: rgb(66, 244, 107);
                width: 145px; 
              }
              .div_user_list .name{ 
                color: rgb(92, 170, 249);
                width: 295px; 
              }
			  .div_user_list .job{ 
                color: rgb(247, 193, 93);
                width: 145px; 
			  }
            ]]
            vRPclient.setDiv(player,{"user_list", css, content})
          end
		end})
      end
    end
  end
end
