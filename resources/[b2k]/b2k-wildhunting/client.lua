vRP = Proxy.getInterface("vRP")

local coordsStartJob = { -398.35308837891, 4713.48828125, 264.87216186523 } -- apertar E para iniciar trabalho
local isHunting = false 
local secondsTimeRemaing = 0
local secondsSpammingE = 0
local isCollecting = false

local animalPeds = {
	[1] = "a_c_boar",
	[2] = "a_c_cow",
	[3] = "a_c_coyote",
	[4] = "a_c_deer",
	[5] = "a_c_chickenhawk",
	[6] = "a_c_mtlion",
	[7] = "a_c_pig",
	[8] = "a_c_pigeon",
	[9] = "a_c_rabbit_01",
	[10] = "a_c_rat",
	[11] = "a_c_cormorant"
}

local function NEAR (enumerator, _table)
    local output = _table or {}
    for entity in enumerator() do
        output[tostring(entity)] = entity
    end
    return output
end

function AllWorldPeds (...) return NEAR(EnumeratePeds, ...) end
local ALL_WORLD_ENTITIES = {}
Citizen.CreateThread(function ()
    while true do
        AllWorldPeds(ALL_WORLD_ENTITIES)
        Citizen.Wait(16)
    end
end)

function DrawText3DTest(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextDropshadow(0, 0, 0, 155)
	SetTextEdge(1, 0, 0, 0, 250)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 41, 41, 68)
end
function drawTxt(x,y, scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function EncerrarJob()
	RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_MUSKET"))
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	isHunting = false
	secondsTimeRemaing = 0
	TriggerEvent("b2k:missaoCompletada", 10, "~g~Missão Finalizada", "~w~Venda as ~r~Carnes~w~ no Frigorífico.")
end

function CancelarJob(msg)
	RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_MUSKET"))
	RemoveAllPedWeapons(GetPlayerPed(-1), true)
	isHunting = false
	secondsTimeRemaing = 0
	TriggerEvent("b2k:missaoCompletada", 10, "~r~Missão Falhou", msg)
end

local collect_seq = {
	{"oddjobs@hunter","idle_a",1},
	{"oddjobs@hunter","exit",1}
}

function coletarCarne(v, animalModel)
	isCollecting = true
	
	vRP.playAnim({false,collect_seq,false})
	local haveKnife = false
	if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"), true) then
		SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"), true)
		haveKnife = true
	else
		GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"), 0, false, true)
		SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"), true)
	end
	
	TriggerServerEvent("b2k:tryToCollectMeat", ObjToNet(v), animalModel)
	SetTimeout(8000, function()
		vRP.stopAnim({false})
		if not haveKnife then
			RemoveWeaponFromPed(GetPlayerPed(-1), GetHashKey("WEAPON_KNIFE"))
		end
		isCollecting = false
	end)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if secondsTimeRemaing > 0 then
			secondsTimeRemaing = secondsTimeRemaing - 1
		end
		
		if secondsSpammingE > 0 then
			secondsSpammingE = secondsSpammingE - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		
		local px,py,pz = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		
		if GetDistanceBetweenCoords(px,py,pz, coordsStartJob[1],coordsStartJob[2],coordsStartJob[3], true) < 3 and not isHunting then
			DrawText3DTest(coordsStartJob[1],coordsStartJob[2],coordsStartJob[3], "Guarde suas Armas antes e Pressione [E] para iniciar o Trabalho.")
			if IsControlJustPressed(2,38) then
				if secondsSpammingE < 1 then
					secondsSpammingE = 5
					TriggerServerEvent("b2k:tryStartWildHunterJob")
				else
					vRP.notify({"Aguarde 5 segundos para tentar novamente."})
				end
			end
		end
		if GetDistanceBetweenCoords(px,py,pz, coordsStartJob[1],coordsStartJob[2],coordsStartJob[3], true) < 3 and isHunting then
			DrawText3DTest(coordsStartJob[1],coordsStartJob[2],coordsStartJob[3], "Pressione [E] para finalizar o Trabalho.")
			if IsControlJustPressed(2,38) then
				if secondsSpammingE < 1 then
					secondsSpammingE = 5
					EncerrarJob()
				else
					vRP.notify({"Aguarde 5 segundos para tentar novamente."})
				end
			end
		end
	end
end)

RegisterNetEvent("b2k:StartWildHunterJob")
AddEventHandler("b2k:StartWildHunterJob",function()
	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
	TriggerEvent("b2k:missaoCompletada", 10, "~y~Missão Iniciada", "Você tem 10 minutos para Caçar com o ~g~Mosquete~w~, e não pode usar ~r~veículos~w~.")
	secondsTimeRemaing = 600
	isHunting = true
end)

RegisterNetEvent("b2k:syncRemovedEntity")
AddEventHandler("b2k:syncRemovedEntity",function(entIdSent)
	local v = NetToEnt(entIdSent)
	if DoesEntityExist(v) then
		SetEntityAsNoLongerNeeded(v)
		Citizen.InvokeNative(0xAD738C3085FE7E11, v, false, true) -- set not as mission entity
		SetVehicleAsNoLongerNeeded(Citizen.PointerValueIntInitialized(v))
		DeleteEntity(v)
	end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		if secondsTimeRemaing > 0 and isHunting then
			drawTxt(0.38, 0.9, 0.5, "~w~Tempo restante: ~r~" .. secondsTimeRemaing .. " ~w~segundos.", 255,255,255,255)
		end
		if secondsTimeRemaing < 1 and isHunting then
			EncerrarJob()
		end
		
		if isHunting then
			local pHealth = GetEntityHealth(GetPlayerPed(-1))
			if pHealth <= 105 then
				CancelarJob("~w~Você entrou em ~r~Coma~w~.")
			else
				--SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_MUSKET"), true)
				
				if (IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
					CancelarJob("~w~Você não pode usar ~r~Veículos~w~ neste trabalho.")
				else
					for k,v in pairs(ALL_WORLD_ENTITIES) do
						if not DoesEntityExist(v) then ALL_WORLD_ENTITIES[k] = nil -- Clean destroyed entities
						else
							local ex,ey,ez = table.unpack(GetEntityCoords(v))
							local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
							
							if GetDistanceBetweenCoords(ex,ey,ez, x,y,z, true) < 2 then
								for i = 1, #animalPeds do
									if GetEntityModel(v) == GetHashKey(animalPeds[i]) and IsEntityDead(v) and not isCollecting then
										DrawText3DTest(ex,ey,ez, "Pressione [E] para coletar a carne")
										if IsControlJustPressed(2,38) then
											coletarCarne(v, animalPeds[i])
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15000)
		if isHunting then
			SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_MUSKET"), true)
		end
	end
end)

