vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP")
HUDserver = Tunnel.getInterface("vrp_hud","vrp_hud")
vRPhud = {}
Tunnel.bindInterface("vrp_hud",vRPhud)

fome = 0
sede = 0

fadeIn = false
fadeOut = false
alphaFade = 0

--
local PlateVeh = ""
local GasVeh = 0

function GetMinimapAnchor()
	-- Safezone goes from 1.0 (no gap) to 0.9 (5% gap (1/20))
	-- 0.05 * ((safezone - 0.9) * 10)
	local safezone = GetSafeZoneSize()
	local safezone_x = 1.0 / 20.0
	local safezone_y = 1.0 / 20.0
	local aspect_ratio = GetAspectRatio(0)
	local res_x, res_y = GetActiveScreenResolution()

	local xscale = 1.0 / res_x
	local yscale = 1.0 / res_y
	local Minimap = {}
	Minimap.width = xscale * (res_x / (4 * aspect_ratio))
	Minimap.height = yscale * (res_y / 5.674)
	Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
	Minimap.right_x = Minimap.left_x + Minimap.width
	Minimap.top_y = Minimap.bottom_y - Minimap.height
	Minimap.x = Minimap.left_x
	Minimap.y = Minimap.top_y
	Minimap.xunit = xscale
	Minimap.yunit = yscale
	Minimap.res_x = res_x
	Minimap.res_y = res_y

	return Minimap
end

Citizen.CreateThread(function()
	while true do Citizen.Wait(1)
		local ui = GetMinimapAnchor()

		local minimap_bottom_y = ui.bottom_y-0.0195
		local speed = 0
		local addAspect = 0.0
		local addMaxBG = 22
		local hudAlpha = 255
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			hudAlpha = 255
		else
			hudAlpha = 180
		end
		if ui.res_x >= 1600 then
			addAspect = 0.012
			addMaxBG = 23.5
		else
			addAspect = 0.015
			addMaxBG = 20
			minimap_bottom_y = ui.bottom_y-0.0225
		end
		
		-- Fundo Preto Geral
		drawRct(ui.x, minimap_bottom_y, ui.width+0.001, addMaxBG * ui.yunit,42,40,41,hudAlpha) --  Fundo preto

		-- Vida
		drawRct(ui.x+0.0015, minimap_bottom_y+0.0015, (ui.width/2)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha) -- bg
		local health = GetEntityHealth(GetPlayerPed(-1)) - 100
		local varSet = (((ui.width/2)-0.0015) * (health / 300))
		drawRct(ui.x+0.0015, minimap_bottom_y+0.0015, varSet, 8 * ui.yunit,66,146,72,hudAlpha) -- Vida
		
		-- Colete Fundo
		drawRct((ui.width/2)+ui.x+0.0015, minimap_bottom_y+0.0015, (ui.width/2)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha)
		local armor = GetPedArmour(GetPlayerPed(-1))
		if armor > 100.0 then armor = 100.0 end
		local varSet = (((ui.width/1.99)-0.0025) * (armor / 100))
		drawRct((ui.width/2)+ui.x+0.0015, minimap_bottom_y+0.0015, varSet, 8 * ui.yunit,104,103,183,hudAlpha)
		
		-- Fome
		drawRct(ui.x+0.0015, minimap_bottom_y+addAspect, (ui.width/4)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha)
		if fome > 100.0 then fome = 100.0 end
		local varSet = (((ui.width/4)-0.0015) * (fome / 100))
		drawRct(ui.x+0.0015, minimap_bottom_y+addAspect, varSet, 8 * ui.yunit,66,146,72,hudAlpha) -- Fome
		
		-- Sede
		drawRct((ui.width/4)+ui.x+0.0015, minimap_bottom_y+addAspect, (ui.width/4)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha)
		if sede > 100.0 then sede = 100.0 end
		local varSet = (((ui.width/4)-0.0015) * (sede / 100))
		drawRct((ui.width/4)+ui.x+0.0015, minimap_bottom_y+addAspect, varSet, 8 * ui.yunit,78,80,181,hudAlpha) -- Sede
		
		-- Sono (Futuramente)
		sono = 0
		drawRct((ui.width/2)+ui.x+0.0015, minimap_bottom_y+addAspect, (ui.width/4)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha)
		local varSet = (((ui.width/4)-0.0015) * (sono / 100))
		drawRct((ui.width/2)+ui.x+0.0015, minimap_bottom_y+addAspect, varSet, 8 * ui.yunit,129,129,129,hudAlpha) -- Sono
		
		-- Talking Bar
		if NetworkIsPlayerTalking(PlayerId()) then
			drawRct((ui.width/4)+(ui.width/2)+ui.x+0.0015, minimap_bottom_y+addAspect, (ui.width/4)-0.0015, 8 * ui.yunit,190,0,165,hudAlpha)
		else
			drawRct((ui.width/4)+(ui.width/2)+ui.x+0.0015, minimap_bottom_y+addAspect, (ui.width/4)-0.0015, 8 * ui.yunit,88,87,88,hudAlpha)
		end
		
		if fadeIn and alphaFade < 250 then
			alphaFade = alphaFade + 10
			if alphaFade > 250 then alphaFade = 250 end
		end
		if fadeOut and alphaFade > 1 then
			alphaFade = alphaFade - 10
			if alphaFade < 0 then alphaFade = 0 end
		end
		
		-- Car Hud
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			fadeIn = true
			fadeOut = false
			DisplayRadar(true)
			
			Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6 -- km/h
			
			local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			if MyPedVeh then
				PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
				--GasVeh = GetVehicleFuelLevel(MyPedVeh)
				--local MaxGasVeh = GetVehicleHandlingFloat(MyPedVeh, "CHandlingData", "fPetrolTankVolume")
				--local CurrentGasVeh = DecorGetFloat(MyPedVeh, "_Fuel_Level") or 0.0
				--GasVeh = (100.0 / MaxGasVeh) * CurrentGasVeh
			end
		else
			fadeIn = false
			fadeOut = true
			DisplayRadar(false)
		end
		
		if alphaFade > 0 then
			drawTxt(ui.x, ui.top_y - 0.045, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, alphaFade)
			drawTxt(ui.x + 0.022, ui.top_y - 0.035, 1.0,1.0,0.4, "~w~ km/h", 255, 255, 255, alphaFade)
			
			drawTxt((ui.width/2)-0.005, ui.top_y - 0.040, 1.0,1.0,0.5 , "~w~" .. PlateVeh, 255, 255, 255, alphaFade)

			--drawTxt((ui.width)- 0.020, ui.top_y - 0.045, 1.0,1.0,0.64 , "~w~" .. math.ceil(GasVeh), 255, 255, 255, alphaFade)
			--drawTxt(ui.width, ui.top_y - 0.035, 1.0,1.0,0.4, "~w~ %", 255, 255, 255, alphaFade)
			
			
		end
	end
end)

function vRPhud.setHunger(hunger)
	fome = hunger
end

function vRPhud.setThirst(thirst)
	sede = thirst
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- U
local lockCounter = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if lockCounter > 0 then
			lockCounter = lockCounter - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = GetPlayerPed(-1)
		if not IsPauseMenuActive() and IsControlPressed(0,303) and lockCounter < 1 then -- U Key
			lockCounter = 2
			TriggerServerEvent("b2k:pressLockCar")
		end
	end
end)


RegisterNetEvent("b2k:giveParachute")
AddEventHandler("b2k:giveParachute", function()
	GiveDelayedWeaponToPed(PlayerPedId(), 0xFBAB5776, 1, 0) -- parachute
end)

RegisterNetEvent("b2k:tpall")
AddEventHandler("b2k:tpall", function(x,y,z)
	SetEntityCoordsNoOffset(GetPlayerPed(-1), x, y, z, 0, 0, 0)
end)



-- Add/remove weapon hashes here to be added for holster checks.
local weapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
}
-- HOLSTER/UNHOLSTER PISTOL --
 
 Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		if DoesEntityExist( ped ) and not IsEntityDead( ped ) and not IsPedInAnyVehicle(PlayerPedId(), true) then
			loadAnimDict( "rcmjosh4" )
			loadAnimDict( "weapons@pistol@" )
			if CheckWeapon(ped) then
				if holstered then
					TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(600)
					ClearPedTasks(ped)
					holstered = false
				end
			elseif not CheckWeapon(ped) then
				if not holstered then
					TaskPlayAnim(ped, "weapons@pistol@", "aim_2_holster", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
					Citizen.Wait(500)
					ClearPedTasks(ped)
					holstered = true
				end
			end
		end
	end
end)

function CheckWeapon(ped)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == GetSelectedPedWeapon(ped) then
			return true
		end
	end
	return false
end
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end