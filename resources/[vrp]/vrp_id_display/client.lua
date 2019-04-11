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

vRPidd = {}
Tunnel.bindInterface("vrp_id_display",vRPidd)
users = {}
blips = {}
myteam = nil

RegisterNetEvent("vrp:id:add")
AddEventHandler("vrp:id:add", function(user_id,source)
	users[user_id] = GetPlayerFromServerId(source)
end)

RegisterNetEvent("vrp:id:rem")
AddEventHandler("vrp:id:rem", function(user_id,source)
	users[user_id] = nil
end)

function vRPidd.insertUser(user_id,source)
	users[user_id] = GetPlayerFromServerId(source)
end

function vRPidd.removeUser(user_id)
	users[user_id] = nil
end

function vRPidd.insertBlip(user_id,source,group,btype)
	blips[user_id] = {player = GetPlayerFromServerId(source), job = group, team = btype}
	if GetPlayerPed( blips[user_id].player ) == GetPlayerPed( -1 ) then
	  myteam = btype
	end
end

function vRPidd.removeBlip(user_id)
	local ped = GetPlayerPed(blips[user_id].player)
	local blip = GetBlipFromEntity(ped)
	RemoveBlip(blip)
	blips[user_id] = {player = nil, job = nil, team = nil}
	if ped == GetPlayerPed( -1 ) then
	  myteam = nil
	end
end

function vRPidd.getGroupColour(group)
	return cfg.blips[group].id.r, cfg.blips[group].id.g, cfg.blips[group].id.b
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )

	return result
end

function DrawText3D(x,y,z, text, r,g,b) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function UpdateBlip(player, blip, sprite, colour, alpha)
	local blipSprite = GetBlipSprite( blip )
	HideNumberOnBlip( blip )
	if blipSprite ~= sprite then
	  SetBlipSprite( blip, sprite )
	  Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
	end
	SetBlipNameToPlayerName( blip, player )
	SetBlipScale( blip,  0.85 )
	SetBlipColour( blip, colour )
	SetBlipAlpha( blip, alpha )
end

function GetPedVehicleSeat(ped)
	local vehicle = GetVehiclePedIsIn(ped, false)
	local invehicle = IsPedInAnyVehicle(ped, false)
	if invehicle then
		for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
			if (GetPedInVehicleSeat(vehicle, i) == ped) then return i end
		end
	end
	return -2
end

Citizen.CreateThread(function()
    while true do
        for i=0,64 do
            N_0x31698aa80e0223f8(i)
        end
        for k,v in pairs(users) do
		  if v ~= nil then
		  
		  	local isDucking = IsPedDucking(GetPlayerPed(v))
			--local cansee = HasEntityClearLosToEntity(GetPlayerPed(-1), GetPlayerPed(v), 17)
			local cansee = true
			local seatnumber = GetPedVehicleSeat(GetPlayerPed(v))
			local isReadyToShoot = IsPedWeaponReadyToShoot(GetPlayerPed(v))
			local isStealth = 0--GetPedStealthMovement(GetPlayerPed(v))
			local isDriveBy = false--IsPedDoingDriveby(GetPlayerPed(v))
			local isInCover = IsPedInCover(GetPlayerPed(v), true)
			local isSwimming = IsPedSwimming(GetPlayerPed(v))
			local isUnderWater = IsPedSwimmingUnderWater(GetPlayerPed(v))
			if isStealth == nil then
				isStealth = 0
			end
			
			if isDucking or isStealth == 1 or isDriveBy or isInCover then
				cansee = false
			end
			
			if seatnumber ~= -2 then
				seatnumber = seatnumber + 0.25
			end
			
			seatnumber = tonumber(seatnumber)
			
			x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
			x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( v ), true ) )
			distance = math.floor(GetDistanceBetweenCoords(x1, y1, z1, x2, y2, z2, true))

			--if  ((GetPlayerPed( v ) ~= GetPlayerPed( -1 )) or cfg.showself) then -- disable your own
			--[[if GetPlayerPed(v) ~= GetPlayerPed(-1) then -- disable your own
				if ((distance < cfg.distance)) then
					if NetworkIsPlayerTalking(v) then
						if cansee then
							if seatnumber == -2 then
								DrawText3D(x2, y2, z2+1, k, cfg.talker.r, cfg.talker.g, cfg.talker.b)
							else
								DrawText3D(x2, (y2+seatnumber), z2+1, k, cfg.talker.r, cfg.talker.g, cfg.talker.b)
							end
						end
					else
						if cansee then
							if seatnumber == -2 then
								DrawText3D(x2, y2, z2+1, k, cfg.default.r, cfg.default.g, cfg.default.b)
							else
								DrawText3D(x2, (y2+seatnumber), z2+1, k, cfg.default.r, cfg.default.g, cfg.default.b)
							end
						end
					end
				end
			end]]
			
			if isUnderWater or isSwimming then
				cansee = false
			end
			
			if ((distance < cfg.drawCircleDist)) then
				local ped = GetPlayerPed(v)
				if not (IsPedInAnyVehicle(ped)) then
					local rainbow = RGBRainbow(1)
					if NetworkIsPlayerTalking(v) then
						if GetEntityHealth(ped) <= 105 then
							DrawMarker(cfg.drawComatype,x2,y2,z2+0.50, 0, 0, 0, 0, 180.0, 0, cfg.drawComascalex, cfg.drawComascaley, cfg.drawComascalez, cfg.drawredtalk, cfg.drawgreentalk, cfg.drawbluetalk, 155, 1, 0, 0, 1, 0, 0, 0)
						else
							if cansee then
								DrawMarker(cfg.drawtype,x2,y2,z2-0.95, 0, 0, 0, 0, 0, 0, cfg.drawscalex, cfg.drawscaley, cfg.drawscalez, cfg.drawredtalk, cfg.drawgreentalk, cfg.drawbluetalk, 105, 0, 0, 0, 1, 0, 0, 0)
								--DrawMarker(cfg.drawtype, x2,y2,z2-0.95, 0, 0, 0, 0, 0, 0, 1.0001,1.0001,1.0001, 0, 232, 255, 155, 0, 0, 0, 1, 0, 0, 0)
							end
						end
					else
						if GetEntityHealth(ped) <= 105 then
							--DrawMarker(cfg.drawComatype,x2,y2,z2+0.50, 0, 0, 0, 0, 180.0, 0, cfg.drawComascalex, cfg.drawComascaley, cfg.drawComascalez, cfg.drawred, cfg.drawblue, cfg.drawgreen, 105, 0, 0, 2, 0, 0, 0, 0)
							DrawMarker(cfg.drawComatype,x2,y2,z2+0.50, 0, 0, 0, 0, 180.0, 0, cfg.drawComascalex, cfg.drawComascaley, cfg.drawComascalez, rainbow.r, rainbow.g, rainbow.b, 155, 1, 0, 0, 1, 0, 0, 0)
						else
							if cansee then
								DrawMarker(cfg.drawtype,x2,y2,z2-0.95, 0, 0, 0, 0, 0, 0, cfg.drawscalex, cfg.drawscaley, cfg.drawscalez, cfg.drawred, cfg.drawgreen, cfg.drawblue, 105, 0, 0, 2, 0, 0, 0, 0)
							end
						end
					end
				end
			end
			
		  end
        end
		
		--if not IsAimCamActive() or not IsFirstPersonAimCamActive() then
		--	HideHudComponentThisFrame(14)
		--end

		if IsHudComponentActive(1) then
			HideHudComponentThisFrame(1)
		end
		
		if IsHudComponentActive(6) then
			HideHudComponentThisFrame(6)
		end
		
		if IsHudComponentActive(7) then
			HideHudComponentThisFrame(7)
		end
		
		if IsHudComponentActive(9) then
			HideHudComponentThisFrame(9)
		end
		
		if IsHudComponentActive(0) and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
			HideHudComponentThisFrame(0)
		end
		Citizen.Wait(0)
    end
end)
--[[
Citizen.CreateThread(function()
    while true do
        for k,v in pairs(blips) do
		  if v.player ~= nil then
			local ped = GetPlayerPed( v.player )
		    if ((ped ~= GetPlayerPed( -1 )) or cfg.showself) then
			  local blip = GetBlipFromEntity(ped)
			  x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
			  x2, y2, z2 = table.unpack( GetEntityCoords( ped, true ) )
			  distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
			  if v.job ~= nil then
			    if cfg.blips[v.job] ~= nil then
			      if distance < cfg.blips[v.job].distance and v.team == myteam then
				    local alpha = 255 - (255*(distance/cfg.blips[v.job].distance))
			        if not DoesBlipExist( blip ) then
				      blip = AddBlipForEntity( ped )
				      UpdateBlip(v.player, blip, cfg.blips[v.job].sprite, cfg.blips[v.job].colour, alpha)
			        else
				      UpdateBlip(v.player, blip, cfg.blips[v.job].sprite, cfg.blips[v.job].colour, alpha)
			        end
			      else
			        if DoesBlipExist( blip ) then
			          RemoveBlip(blip)
				    end
		          end
				end
			  end
		    end
		  end
		end
      Citizen.Wait(0)
    end
end)]]

--[[Citizen.CreateThread(function()
	print("Starting GameTags")
	while true do
		for id = -1, 31 do
			--if id ~= PlayerId() and NetworkIsPlayerActive(id) then
			if NetworkIsPlayerActive(id) then
				local playerPed = GetPlayerPed(id)
				
				local healthBarVisible = IsPlayerFreeAimingAtEntity(PlayerId(), playerPed)
				local isPlayerTalking = NetworkIsPlayerTalking(id)
				local visible = healthBarVisible or isPlayerTalking

				local gamerTag = CreateMpGamerTag(playerPed, GetPlayerName(id), false, false, "", 0)

				-- https://runtime.fivem.net/doc/reference.html#_0x63BB75ABEDC1F6A0
				SetMpGamerTagName(gamerTag, GetPlayerName(id))
				SetMpGamerTagColour(gamerTag, 0, 0)
				SetMpGamerTagColour(gamerTag, 4, 0)
				SetMpGamerTagHealthBarColour(gamerTag, 0)
				SetMpGamerTagAlpha(gamerTag, 0, 255)
				SetMpGamerTagAlpha(gamerTag, 2, 255)
				SetMpGamerTagAlpha(gamerTag, 4, 255)

				SetMpGamerTagVisibility(gamerTag, 0, visible) -- GAMER_NAME
				SetMpGamerTagVisibility(gamerTag, 2, healthBarVisible) -- HEALTH/ARMOR
				SetMpGamerTagVisibility(gamerTag, 4, isPlayerTalking) -- AUDIO_ICON
				SetMpGamerTagVisibility(gamerTag, 5, true) -- MP_USING_MENU
			end
		end

		Citizen.Wait(0)
	end
end)]]