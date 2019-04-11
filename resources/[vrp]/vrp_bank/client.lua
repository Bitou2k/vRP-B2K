local robbing = false
local bank = ""
local secondsRemaining = 0
local blipRobbery = nil

function bank_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local banks = cfg.banks


RegisterNetEvent('es_bank:b2k:currentlyrobbing')
AddEventHandler('es_bank:b2k:currentlyrobbing', function(robb)
	robbing = true
	bank = robb
	secondsRemaining = cfg.seconds
end)

RegisterNetEvent('es_bank:b2k:toofarlocal')
AddEventHandler('es_bank:b2k:toofarlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "O Roubo foi cancelado, você recebeu nada.")
	robbingName = ""
	secondsRemaining = 0
	secondsRemainingScale = 0
	incircle = false
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('es_bank:b2k:playerdiedlocal')
AddEventHandler('es_bank:b2k:playerdiedlocal', function(robb)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "O Roubo foi cancelado, você morreu!.")
	robbingName = ""
	secondsRemaining = 0
	secondsRemainingScale = 0
	incircle = false
	RemoveBlip(blipRobbery)
end)


RegisterNetEvent('es_bank:b2k:robberycomplete')
AddEventHandler('es_bank:b2k:robberycomplete', function(reward)
	robbing = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Roubo concluido, você recebeu:^2" .. reward)
	bank = ""
	secondsRemaining = 0
	secondsRemainingScale = 0
	incircle = false
	RemoveBlip(blipRobbery)
end)

RegisterNetEvent('es_bank:b2k:setblip')
AddEventHandler('es_bank:b2k:setblip', function(position)
	blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery , 161)
	SetBlipScale(blipRobbery , 2.0)
	SetBlipColour(blipRobbery, 3)
	PulseBlip(blipRobbery)
end)

RegisterNetEvent('es_bank:b2k:killblip')
AddEventHandler('es_bank:b2k:killblip', function()
	RemoveBlip(blipRobbery)
end)

Citizen.CreateThread(function()
	while true do
		if robbing then
			Citizen.Wait(1000)
			if (secondsRemaining > 0) then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		for k,v in pairs(banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if IsPlayerWantedLevelGreater(PlayerId(),0) or ArePlayerFlashingStarsAboutToDrop(PlayerId()) then
					local wanted = GetPlayerWantedLevel(PlayerId())
					Citizen.Wait(5000)
				    SetPlayerWantedLevel(PlayerId(), wanted, 0)
					SetPlayerWantedLevelNow(PlayerId(), 0)
				end
			end
		end
		Citizen.Wait(0)
	end
end)

if cfg.blips then -- blip settings
  Citizen.CreateThread(function()
	for k,v in pairs(banks)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 278)
		SetBlipScale(blip, 0.8)
		SetBlipColour(blip, 1)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Banco Roubável")
		EndTextCommandSetBlipName(blip)
	end
  end)
end
incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(banks)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 6.0)then
				if not robbing then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
					
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 3)then
						if (incircle == false) then
							bank_DisplayHelpText("~w~Pressione ~INPUT_CONTEXT~ para Roubar. ~r~Cuidado~w~,~b~ os policiais serão alertados!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							TriggerServerEvent('es_bank:b2k:rob', k)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 3)then
						incircle = false
					end
				end
			end
		end

		if robbing then
		    SetPlayerWantedLevel(PlayerId(), 4, 0)
            SetPlayerWantedLevelNow(PlayerId(), 0)
			
			bank_drawTxt(0.66, 1.44, 1.0,1.0,0.4, "Roubando banco: ~r~" .. secondsRemaining .. "~w~ tempo restante", 255, 255, 255, 255)
			
			local pos2 = banks[bank].position
			local ped = GetPlayerPed(-1)
			
            if IsEntityDead(ped) then
			TriggerServerEvent('es_bank:b2k:playerdied', bank)
			elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 4)then
				TriggerServerEvent('es_bank:b2k:toofar', bank)
			end
		end

		Citizen.Wait(0)
	end
end)

-- Scaleform News
local newsScaleFormCounter = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if newsScaleFormCounter > 0 then
			newsScaleFormCounter = newsScaleFormCounter - 1
		end
	end
end)

RegisterNetEvent("b2k:bankNews")
AddEventHandler("b2k:bankNews", function(counter)
	newsScaleFormCounter = counter
	PlaySound(-1, "RANK_UP", "HUD_AWARDS", 0, 0, 1)
end)

Citizen.CreateThread(function()
	local scaleform = RequestScaleformMovie("BREAKING_NEWS")
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(100)
	end
	if HasScaleformMovieLoaded(scaleform) then

		PushScaleformMovieFunction(scaleform, "SET_DISPLAY_CONFIG")
		PushScaleformMovieFunctionParameterInt(1920)
		PushScaleformMovieFunctionParameterInt(1080)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterFloat(0.5)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()
		
		PushScaleformMovieFunction(scaleform, "SET_TEXT")
		PushScaleformMovieFunctionParameterString("Assalto a Banco!")
		PushScaleformMovieFunctionParameterString("<b>Policiais</b> <i>a</i> ~r~Caminho!")
		PopScaleformMovieFunctionVoid()
		
		PushScaleformMovieFunction(scaleform, "SET_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterString("~r~Noticia de Última Hora")
		PopScaleformMovieFunctionVoid()

		
		PushScaleformMovieFunction(scaleform, "DISPLAY_SCROLL_TEXT")
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(0)
		PushScaleformMovieFunctionParameterInt(100)
		PopScaleformMovieFunctionVoid()
		
		while true do
			Citizen.Wait(1)
			if newsScaleFormCounter > 0 then
				DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			end
        end
		
	end
end)