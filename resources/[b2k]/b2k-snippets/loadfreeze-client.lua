local frozen = true
local unfrozen = false
function f(n)
	n = n + 0.00000
	return n
end
local oc = false
local cam = nil
local oc_height = f(1500)

RegisterNetEvent('b2k:unfreeze')
AddEventHandler('b2k:unfreeze', function()
	unfrozen = true
end)

function drawscaleform(scaleform)
	scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end
	PushScaleformMovieFunction(scaleform, "SET_YACHT_NAME")
	PushScaleformMovieFunctionParameterString("~r~B2k Roleplay")
	PushScaleformMovieFunctionParameterBool(true)
	PushScaleformMovieFunctionParameterString("~y~bitou2k.com/discord")
	PopScaleformMovieFunctionVoid()
	
	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
end

Citizen.CreateThread(function()
	SetEntityInvincible(GetPlayerPed(-1),true)
	SetEntityVisible(GetPlayerPed(-1),false)
	FreezeEntityPosition(GetPlayerPed(-1),true)

	SetPedDiesInWater(GetPlayerPed(-1), 0)
	
	if not DoesCamExist(cam) then
		cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
	end
	
	local pos = GetEntityCoords(GetPlayerPed(-1))
	SetCamCoord(cam,vector3(pos.x,pos.y,oc_height))
	SetCamRot(cam,-f(90),f(0),f(0),2)
	SetCamActive(cam, true)
	StopCamPointing(cam)
	RenderScriptCams(true,true,0,0,0,0)
	StartScreenEffect("DeathFailNeutralIn",0,true)
	PlaySound(-1, "RANK_UP", "HUD_AWARDS", 0, 0, 1)

	while frozen do
		--if frozen then
			if unfrozen then

				Citizen.Wait(1000)
				setCamHeight(1000)
				PlaySound(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 0, 0, 1)
				Citizen.Wait(1000)
				setCamHeight(750)
				PlaySound(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 0, 0, 1)
				Citizen.Wait(1000)
				setCamHeight(400)
				PlaySound(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 0, 0, 1)
				Citizen.Wait(1000)
				setCamHeight(100)
				PlaySound(-1, "Hit", "RESPAWN_ONLINE_SOUNDSET", 0, 0, 1)

				Citizen.Wait(2000)

				SetEntityInvincible(GetPlayerPed(-1),false)
				SetEntityVisible(GetPlayerPed(-1),true)
				FreezeEntityPosition(GetPlayerPed(-1),false)
				
				SetCamActive(cam,false)
				StopCamPointing(cam)
				RenderScriptCams(0,0,0,0,0,0)
				SetFocusEntity(GetPlayerPed(-1))
				StopScreenEffect("DeathFailNeutralIn")
				
				frozen = false
			else
			    drawscaleform("YACHT_NAME")
				SetEntityInvincible(GetPlayerPed(-1),true)
				SetEntityVisible(GetPlayerPed(-1),false)
				FreezeEntityPosition(GetPlayerPed(-1),true)
			end
		--end
		Citizen.Wait(0)
	end
end)

function setCamHeight(height)
	local pos = GetEntityCoords(GetPlayerPed(-1))
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
	StartScreenEffect("DeathFailNeutralIn", 0, true)
end