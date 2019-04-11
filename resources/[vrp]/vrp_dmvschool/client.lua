maxErrors = 5 -- Change the amount of Errors allowed for the player to pass the driver test, any number above this will result in a failed test

local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "NPC",
    menu_subtitle = "Categories",
    color_r = 0,
    color_g = 128,
    color_b = 255,
}

local dmvped = {
  {type=4, hash=0xc99f21c4, x=239.471, y=-1380.96, z=32.74176, a=3374176},
}

local dmvpedpos = {
	{ ['x'] = 239.471, ['y'] = -1380.96, ['z'] = 33.74176 },
}

--[[Locals]]--

local dmvschool_location = {232.054, -1389.98, 29.4812}

local kmh = 3.6
local VehSpeed = 0

local speed_limit_resi = 50.0
local speed_limit_town = 80.0
local speed_limit_freeway = 120
local speed = kmh

local DTutOpen = false
TestDone = false

RegisterNetEvent('dmv:CheckLicStatus')
AddEventHandler('dmv:CheckLicStatus', function(license)
--Check if player has completed theory test
	TestDone = license
	theorylock = not license
	testlock = not license
end)

--[[Functions]]--

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function LocalPed()
	return GetPlayerPed(-1)
end

function GetCar() 
	return GetVehiclePedIsIn(GetPlayerPed(-1),false) 
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

--[[Arrays]]--
onTtest = false
onPtest = false
onTestEvent = 0
theorylock = true
testlock = true
DamageControl = 0
SpeedControl = 0
CruiseControl = 0
Error = 0

function startintro()
		DIntro() 
		theorylock = false
end

function startttest()
        if theorylock then
			DrawMissionText2("~r~Locked", 5000)			
		else
			TriggerServerEvent('dmv:ttcharge')
		end
end

RegisterNetEvent('dmv:startttest')
AddEventHandler('dmv:startttest', function()
	openGui()
	Menu.hidden = not Menu.hidden
end)

function startptest()
        if testlock then
			DrawMissionText2("~r~Locked", 5000)
		else
		    TriggerServerEvent('dmv:ptcharge')
		end
end

RegisterNetEvent('dmv:startptest')
AddEventHandler('dmv:startptest', function()
	onTestBlipp = AddBlipForCoord(255.13990783691,-1400.7319335938,30.5374584198)
	N_0x80ead8e2e1d5d52e(onTestBlipp)
	SetBlipRoute(onTestBlipp, 1)
	onTestEvent = 1
	DamageControl = 1
	SpeedControl = 1
	onPtest = true
	DTut()
end)

local scaleformCounter = 0
local scaleformTitle = ""
local scaleformSubTitle = ""
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
		if scaleformCounter > 0 then
			scaleformCounter = scaleformCounter - 1
		end
	end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if scaleformCounter > 0 then
			function Initialize(scaleform)
				local scaleform = RequestScaleformMovie(scaleform)

				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(0)
				end
				PushScaleformMovieFunction(scaleform, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE")
				PushScaleformMovieFunctionParameterString(scaleformTitle)
				PushScaleformMovieFunctionParameterString(scaleformSubTitle)
				PopScaleformMovieFunctionVoid()
				return scaleform
			end
			scaleformWasted = Initialize("MP_BIG_MESSAGE_FREEMODE")
			DrawScaleformMovieFullscreen(scaleformWasted, 255, 255, 255, 255, 0)
		end
	end
end)
function showScaleFormHUD(counter, title, subtitle)
	scaleformCounter = counter
	scaleformTitle = title
	scaleformSubTitle = subtitle
	PlaySound(-1, "RANK_UP", "HUD_AWARDS", 0, 0, 1)
end

function EndDTest()
        if Error > maxErrors then
			drawNotification("Você falhou\nVocê acumulou ".. Error.." ~r~Pontos de erro")
			onPtest = false
			EndTestTasks()
			
			showScaleFormHUD(10, "~r~Você Falhou", "Aguarde um pouco para tentar novamente.")
		else
			--local licID = 1
	        --TriggerServerEvent('ply_prefecture:CheckForLicences', licID)	--Uncomment this if youre using ply_prefecture, also make sure your drivers license has 1 as ID
			TriggerServerEvent('dmv:success:b33')
			onPtest = false
			TestDone = true
			theorylock = false
			testlock = false
			drawNotification("Você passou\nVocê acumulou ".. Error.." ~r~Pontos de erro")	
			EndTestTasks()
			
			showScaleFormHUD(10, "~g~Você Passou", "Agora você possui uma CNH para Dirigir.")
		end
end

function EndTestTasks()
		onTestBlipp = nil
		onTestEvent = 0
		DamageControl = 0
		Error = 0
		TaskLeaveVehicle(GetPlayerPed(-1), veh, 0)
		Wait(1000)
		CarTargetForLock = GetPlayersLastVehicle(GetPlayerPed(-1))
		lockStatus = GetVehicleDoorLockStatus(CarTargetForLock)
		SetVehicleDoorsLocked(CarTargetForLock, 2)
		SetVehicleDoorsLockedForPlayer(CarTargetForLock, PlayerId(), false)
		SetEntityAsMissionEntity(CarTargetForLock, true, true)
		Wait(2000)
		Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( CarTargetForLock ) )
		

end
	  
function SpawnTestCar()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey('blista')

    RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end
	colors = table.pack(GetVehicleColours(veh))
	extra_colors = table.pack(GetVehicleExtraColours(veh))
	plate = math.random(100, 900)
	local spawned_car = CreateVehicle(vehicle, 249.40971374512,-1407.2303466797,30.409454345703, true, false)

	SetVehicleColours(spawned_car,4,5)
	SetVehicleExtraColours(spawned_car,extra_colors[1],extra_colors[2])
	SetEntityHeading(spawned_car, 317.64)
	SetVehicleOnGroundProperly(spawned_car)
	SetEntityInvincible(spawned_car,false)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	--Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
	SetModelAsNoLongerNeeded(spawned_car)
	SetVehicleHasBeenOwnedByPlayer(spawned_car,true)
	CruiseControl = 0
	DTutOpen = false
	SetEntityVisible(myPed, true)
	SetVehicleDoorsLocked(GetCar(), 4)
	FreezeEntityPosition(myPed, false) 
end

function DIntro()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	DTutOpen = true
		SetEntityCoords(myPed,173.01181030273, -1391.4141845703, 29.408880233765,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Introdução do Detran</b> <br /><br />Teoria e prática são elementos importantes da instrução de condução.<br />Esta introdução abrangerá os conceitos básicos e assegurará que esteja preparado com informações e conhecimentos suficientes para o seu teste.<br /><br />As informações de suas lições de teoria combinadas com a experiência de sua lição prática são vitais para negociar as situações e dilemas que você enfrentará na estrada.<br /><br />Sente-se e aproveite o passeio quando começamos. É altamente recomendável que você preste atenção em todos os detalhes, a maioria dessas questões pode existir no seu teste de teoria.",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-428.49026489258, -993.306640625, 46.008815765381,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Acidentes, incidentes e preocupações ambientais</b><br /><br /><b style='color:#87CEFA'>Dever de ceder</b><br />Todos os condutores têm o dever de obedecer as regras da estrada, a fim de evitar danos previsíveis aos outros. A incapacidade de ceder o direito de passagem quando exigido por lei pode levar a responsabilidade por qualquer acidente resultante.<br /><br /> Quando você ouve uma sirene chegar, você deve ceder ao veículo de emergência, simplesmente puxar para a direita.<br />Você sempre deve parar quando um oficial de trânsito lhe disser.<br /><br /><b style='color:#87CEFA'>Condução agressiva</b><br />Um carro que põe em risco ou é susceptível de pôr em perigo pessoas ou propriedades é considerado uma condução agressiva.<br />No entanto, a condução agressiva, pode levar a acidentes trágicos. É muito mais sensato dirigir defensivamente e sempre estar atento ao risco potencial de falhas.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-282.55557250977, -282.55557250977, 31.633310317993,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Área residencial</b> <br /><br /> Manter uma velocidade adequada - Nunca mais rápido que o limite postado, mais lento se o tráfego for pesado.<br /><br />Fique centrado na sua pista. Nunca dirija na área reservada para carros estacionados.<br /><br />Mantenha uma distância segura seguindo - pelo menos 1 comprimento de carro por cada 10 mph.<br /><br />O limite de velocidade em uma área residencial é de 50 km/h.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })	
		Citizen.Wait(16500)
		SetEntityCoords(myPed,246.35220336914, -1204.3403320313, 43.669715881348,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Áreas Construida/Cidade</b> <br /><br />O limite de 80 km / h geralmente se aplica a todo o tráfego em todas as estradas com iluminação pública, a menos que seja especificado de outra forma.<br />Conduzir a velocidades muito rápidas para a estrada e condições de pilotagem pode ser perigoso.<br /><br />Você sempre deve reduzir sua velocidade quando:<br /><br />&bull; Dividir a rua com um pedestre<br />&bull; Dirigindo a noite, é mais difícil de ver outros condutores<br />&bull; Condições de clima tornam mais seguro para<br /><br />Lembre-se, veículos grandes e motocicletas precisam de uma boa distância para parar<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SetEntityCoords(myPed,-138.413, -2498.53, 52.2765,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Auto-estradas/Rodovia</b> <br /><br />O tráfego nas auto-estradas geralmente viaja mais rápido do que em outras estradas, então você tem menos tempo para reagir.<br />É especialmente importante usar seus sentidos mais cedo e olhar muito mais à frente do que você faria em outras estradas.<br /><br />Verifique o tráfego na auto-estrada e combine sua velocidade para se encaixar com segurança no fluxo de tráfego na pista da esquerda.<br /><br />O limite de velocidade em uma área de auto-estrada/rodovia é 120 km/h.<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })				
		Citizen.Wait(16500)		
		SetEntityCoords(myPed,187.465, -1428.82, 43.9302,true, false, false,true)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Álcool</b> <br /><br />Beber durante a condução é muito perigoso, álcool e / ou drogas prejudicam seu julgamento. O julgamento prejudicado afeta a forma como você reage aos sons e ao que vê. No entanto, o DETRAN permite uma certa quantidade de concentração de álcool para aqueles que dirigem com uma carteira de motorista válida.<br /><br />0.08% É o limite legal para a concentração de álcool no sangue de um motorista (BAC)<br />",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })				
		Citizen.Wait(16500)			
		SetEntityCoords(myPed,238.756, -1381.65, 32.743,true, false, false,true)
		SetEntityVisible(myPed, true)
		FreezeEntityPosition(myPed, false)
		DTutOpen = false
end

function DTut()
	Citizen.Wait(0)
	local myPed = GetPlayerPed(-1)
	DTutOpen = true
		SetEntityCoords(myPed,238.70791625977, -1394.7208251953, -1394.7208251953,true, false, false,true)
	    SetEntityHeading(myPed, 314.39)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Instrutor do DETRAN:</b> <br /><br /> Atualmente, estamos preparando seu veículo para o teste, enquanto você deve ler algumas linhas importantes.<br /><br /><b style='color:#87CEFA'>Limite de velocidade:</b><br />- Preste atenção ao tráfego e fique sob o <b style='color:#A52A2A'>Limite de</b> velocidade<br /><br />- Até agora, você deve saber o básico, no entanto, tentaremos lembrá-lo sempre que você <b style='color:#DAA520'>entrar/sair</b> em uma área com um limite de velocidade",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		TriggerEvent("pNotify:SendNotification",{
            text = "<b style='color:#1E90FF'>Instrutor do DETRAN:</b> <br /><br /> Use o <b style='color:#DAA520'>Cruise Control</b> feature to avoid <b style='color:#87CEFA'>speeding</b>, Ative isso durante o teste, pressionando o botão <b style='color:#20B2AA'>X</b> No seu teclado.<br /><br /><b style='color:#87CEFA'>Avaliação:</b><br />- Tente não bater o veículo ou superar o limite de velocidade postado. Você receberá <b style='color:#A52A2A;'>Pontos de erro</b> Sempre que você não seguir estas regras<br /><br />- Muitos <b style='color:#A52A2A'>Pontos de erro</b> Acumulado resultará em <b style='color:#A52A2A'>Falha</b> Teste",
            type = "alert",
            timeout = (15000),
            layout = "center",
            queue = "global"
        })
		Citizen.Wait(16500)
		SpawnTestCar()
		DTutOpen = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local veh = GetVehiclePedIsUsing(GetPlayerPed(-1))
		local ped = GetPlayerPed(-1)
		if HasEntityCollidedWithAnything(veh) and DamageControl == 1 then
		TriggerEvent("pNotify:SendNotification",{
            text = "O veículo foi <b style='color:#B22222'>danificado!</b><br /><br />Assista!",
            type = "alert",
            timeout = (2000),
            layout = "bottomCenter",
            queue = "global"
        })			
			Citizen.Wait(1000)
			Error = Error + 1	
		elseif(IsControlJustReleased(1, 23)) and DamageControl == 1 then
			drawNotification("Você não pode deixar o veículo durante o teste")
    	end
		
	if onTestEvent == 1 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 255.13990783691,-1400.7319335938,29.5374584198, true) > 4.0001 then
		   DrawMarker(1,255.13990783691,-1400.7319335938,29.5374584198,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(271.8747253418,-1370.5744628906,31.932783126831)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
		    DrawMissionText2("Dirija-se ao próximo ponto !", 5000)
			onTestEvent = 2
		end
	end
	
	if onTestEvent == 2 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),271.8747253418,-1370.5744628906,30.932783126831, true) > 4.0001 then
		   DrawMarker(1,271.8747253418,-1370.5744628906,30.932783126831,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(234.90780639648,-1345.3854980469, 30.542045593262)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Dirija-se ao próximo ponto!", 5000)
			onTestEvent = 3		
		end
	end
	
	if onTestEvent == 3 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),234.90780639648,-1345.3854980469, 29.542045593262, true) > 4.0001 then
		   DrawMarker(1,234.90780639648,-1345.3854980469, 29.542045593262,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(217.82102966309,-1410.5201416016,29.292112350464)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Faça uma parada ~r~rápida~s~ para o cruzamento de ~y~pedestres", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(4000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			DrawMissionText2("~g~Ótimo!~s~ Vamos continuar em movimento!", 5000)
			onTestEvent = 4
		end
	end	
	
		if onTestEvent == 4 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),217.82102966309,-1410.5201416016,28.292112350464, true) > 4.0001 then
		   DrawMarker(1,217.82102966309,-1410.5201416016,28.292112350464,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(178.55052185059,-1401.7551269531,28.725154876709)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Faça uma ~r~parada~s~ e veja a sua ~y~ESQUERDA~s~ antes de entrar no trânsito", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), true) -- Freeze Entity
			Citizen.Wait(6000)
			FreezeEntityPosition(GetVehiclePedIsUsing(GetPlayerPed(-1)), false) -- Freeze Entity
			DrawMissionText2("~g~Ótimo!~s~ Agora tome à ~y~DIREITA~s~ e escolha sua pista", 5000)
			drawNotification("Area: ~y~Cidade\n~s~Limite de velocidade: ~y~80 km/h\n~s~Pontos de erro: ~y~".. Error.."/"..maxErrors)
			SpeedControl = 2
			onTestEvent = 5
			Citizen.Wait(4000)
		end
	end	
	
		if onTestEvent == 5 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),178.55052185059,-1401.7551269531,27.725154876709, true) > 4.0001 then
		   DrawMarker(1,178.55052185059,-1401.7551269531,27.725154876709,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(113.16044616699,-1365.2762451172,28.725179672241)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Assista o trânsito ~y~Luzes~s~ !", 5000)
			onTestEvent = 6
		end
	end	

		if onTestEvent == 6 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),113.16044616699,-1365.2762451172,27.725179672241, true) > 4.0001 then
		   DrawMarker(1,113.16044616699,-1365.2762451172,27.725179672241,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-73.542953491211,-1364.3355712891,27.789325714111)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 7
		end
	end		
		
	
		if onTestEvent == 7 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-73.542953491211,-1364.3355712891,27.789325714111, true) > 4.0001 then
		   DrawMarker(1,-73.542953491211,-1364.3355712891,27.789325714111,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-355.14373779297,-1420.2822265625,27.868143081665)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Certifique-se de deixar os veículos passar !", 5000)
			onTestEvent = 8
		end
	end			
	
		if onTestEvent == 8 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-355.14373779297,-1420.2822265625,27.868143081665, true) > 4.0001 then
		   DrawMarker(1,-355.14373779297,-1420.2822265625,27.868143081665,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-439.14846801758,-1417.1004638672,27.704095840454)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 9
		end
	end			
	
		if onTestEvent == 9 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-439.14846801758,-1417.1004638672,27.704095840454, true) > 4.0001 then
		   DrawMarker(1,-439.14846801758,-1417.1004638672,27.704095840454,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-453.79092407227,-1444.7265625,27.665870666504)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 10
		end
	end		

		if onTestEvent == 10 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-453.79092407227,-1444.7265625,27.665870666504, true) > 4.0001 then
		   DrawMarker(1,-453.79092407227,-1444.7265625,27.665870666504,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-463.23712158203,-1592.1785888672,37.519771575928)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
		    DrawMissionText2("Tempo para entrar na estrada, verifique a sua velocidade e não bata!", 5000)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
			drawNotification("Area: ~y~Auto-estrada\n~s~Limite de velocidade: ~y~120 km/h\n~s~Pontos de erro: ~y~".. Error.."/"..maxErrors)
			onTestEvent = 11
			SpeedControl = 3
			Citizen.Wait(4000)
		end
	end		

		if onTestEvent == 11 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-463.23712158203,-1592.1785888672,37.519771575928, true) > 4.0001 then
		   DrawMarker(1,-463.23712158203,-1592.1785888672,37.519771575928,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(-900.64721679688,-1986.2814941406,26.109502792358)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 12
		end
	end
	
		if onTestEvent == 12 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),-900.64721679688,-1986.2814941406,26.109502792358, true) > 4.0001 then
		   DrawMarker(1,-900.64721679688,-1986.2814941406,26.109502792358,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(1225.7598876953,-1948.7922363281,38.718940734863)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 13
		end
	end	
	
		if onTestEvent == 13 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1225.7598876953,-1948.7922363281,38.718940734863, true) > 4.0001 then
		   DrawMarker(1,1225.7598876953,-1948.7922363281,38.718940734863,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(209.54621887207,-1412.8677978516,29.652387619019)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			onTestEvent = 14
		end
	end	
	
		if onTestEvent == 14 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1225.7598876953,-1948.7922363281,38.718940734863, true) > 4.0001 then
		   DrawMarker(1,1225.7598876953,-1948.7922363281,38.718940734863,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(1163.6030273438,-1841.7713623047,35.679168701172)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			DrawMissionText2("Entrando na cidade, veja sua velocidade!", 5000)
			drawNotification("~r~Desacelere!\n~s~Area: ~y~Cidade\n~s~Limite de Velocidade: ~y~80 km/h\n~s~Pontos de erro: ~y~".. Error.."/"..maxErrors)
			onTestEvent = 15
		end
	end		
	
		if onTestEvent == 15 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),1163.6030273438,-1841.7713623047,35.679168701172, true) > 4.0001 then
		   DrawMarker(1,1163.6030273438,-1841.7713623047,35.679168701172,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			onTestBlipp = AddBlipForCoord(235.28327941895,-1398.3292236328,28.921098709106)
			N_0x80ead8e2e1d5d52e(onTestBlipp)
			SetBlipRoute(onTestBlipp, 1)
			PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
		    DrawMissionText2("Bom trabalho, agora vamos voltar!", 5000)
			drawNotification("Area: ~y~Cidade\n~s~Limite de velocidade: ~y~80 km/h\n~s~Pontos de erro: ~y~".. Error.."/"..maxErrors)
			SpeedControl = 2
			onTestEvent = 16
		end
	end		

		if onTestEvent == 16 then
		if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)),235.28327941895,-1398.3292236328,28.921098709106, true) > 4.0001 then
		   DrawMarker(1,235.28327941895,-1398.3292236328,28.921098709106,0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)
		else
		    if onTestBlipp ~= nil and DoesBlipExist(onTestBlipp) then
				Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(onTestBlipp))
		    end
			EndDTest()
		end
	end		
end
end)

----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
  onTtest = true
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if onTtest then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
  -- if question success
  closeGui()
  cb('ok')
  DrawMissionText2("~b~O teste passou, agora você pode passar ao teste de direção", 2000)	
  theorylock = true
  testlock = false
  onTtest = false
end)

RegisterNUICallback('kick', function(data, cb)
  closeGui()
  cb('ok')
  DrawMissionText2("~r~Você falhou no teste, você pode tentar novamente outro dia", 2000)	
  onTtest = false
  theorylock = false
end)

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
        Citizen.Wait(1)
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and not TestDone and not onPtest then
			--local seatnumber = GetPedVehicleSeat(GetPlayerPed(-1))
			--if seatnumber == -2 then
				DrawMissionText2("~r~Você está dirigindo sem carteira de Motorista", 2000)
			--end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		if onPtest then
			Citizen.Wait(1)
			CarSpeed = GetEntitySpeed(GetCar()) * speed
			if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 1 and CarSpeed >= speed_limit_resi then
			TriggerEvent("pNotify:SendNotification",{
				text = "Você está acelerando! <b style='color:#B22222'>Desacelere!</b><br /><br />Você está dirigindo em uma <b style='color:#DAA520'>50 km/h</b> zona!",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
				Error = Error + 1	
				Citizen.Wait(10000)
			elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 2 and CarSpeed >= speed_limit_town then
			TriggerEvent("pNotify:SendNotification",{
				text = "Você está acelerando! <b style='color:#B22222'>Desacelere!</b><br /><br />Você está dirigindo em uma <b style='color:#DAA520'>80 km/h</b> zona!",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
				Error = Error + 1
				Citizen.Wait(10000)
			elseif(IsPedInAnyVehicle(GetPlayerPed(-1), false)) and SpeedControl == 3 and CarSpeed >= speed_limit_freeway then
			TriggerEvent("pNotify:SendNotification",{
				text = "Você está acelerando! <b style='color:#B22222'>Desacelere!</b><br /><br />Você está dirigindo em uma <b style='color:#DAA520'>120 km/h</b> zona!",
				type = "alert",
				timeout = (2000),
				layout = "bottomCenter",
				queue = "global"
			})
				Error = Error + 1
				Citizen.Wait(10000)
			end
		else
			Citizen.Wait(30000)
		end
	end
end)


local speedLimit = 0
Citizen.CreateThread( function()
    while true do 
        Citizen.Wait( 0 )   
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)
        local speed = GetEntitySpeed(vehicle)
        local inVehicle = IsPedSittingInAnyVehicle(ped)
        local float Max = GetVehicleMaxSpeed(vehicleModel)
        if ( ped and inVehicle and DamageControl == 1 ) then
            if IsControlJustPressed(1, 73) then
                if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                    if CruiseControl == 0 then
                        speedLimit = speed
                        SetEntityMaxSpeed(vehicle, speedLimit)
						drawNotification("~y~Cruise Control: ~g~enabled\n~s~MAX speed ".. math.floor(speedLimit*3.6).."kmh")
						Citizen.Wait(1000)
				        DisplayHelpText("Ajuste sua velocidade máxima com ~INPUT_CELLPHONE_UP~ ~INPUT_CELLPHONE_DOWN~ controls")
						PlaySound(-1, "COLLECTED", "HUD_AWARDS", 0, 0, 1)
                        CruiseControl = 1
                    else
                        SetEntityMaxSpeed(vehicle, Max)
						drawNotification("~y~Cruise Control: ~r~disabled")						
                        CruiseControl = 0
                    end
                else
				    drawNotification("Você precisa estar dirigindo para executar esta ação")						
                end
            elseif IsControlJustPressed(1, 27) then
                if CruiseControl == 1 then
                    speedLimit = speedLimit + 0.45
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
					DisplayHelpText("Velocidade máxima ajustada para ".. math.floor(speedLimit*3.6).. "kmh")
                end
            elseif IsControlJustPressed(1, 173) then
                if CruiseControl == 1 then
                    speedLimit = speedLimit - 0.45
                    SetEntityMaxSpeed(vehicle, speedLimit)
					PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)	
					DisplayHelpText("Velocidade máxima ajustada para ".. math.floor(speedLimit*3.6).. "kmh")
                end
            end
        end
    end
end)

----Theory Test NUI Operator

-- ***************** Open Gui and Focus NUI
function openGui()
  onTtest = true
  SetNuiFocus(true)
  SendNUIMessage({openQuestion = true})
end

-- ***************** Close Gui and disable NUI
function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({openQuestion = false})
end

-- ***************** Disable controls while GUI open
Citizen.CreateThread(function()
  while true do
    if onTtest then
      local ply = GetPlayerPed(-1)
      local active = true
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)

Citizen.CreateThread(function()
  while true do
    if DTutOpen then
      local ply = GetPlayerPed(-1)
      local active = true
	  SetEntityVisible(ply, false)
	  FreezeEntityPosition(ply, true)
      DisableControlAction(0, 1, active) -- LookLeftRight
      DisableControlAction(0, 2, active) -- LookUpDown
      DisablePlayerFiring(ply, true) -- Disable weapon firing
      DisableControlAction(0, 142, active) -- MeleeAttackAlternate
      DisableControlAction(0, 106, active) -- VehicleMouseControlOverride
    end
    Citizen.Wait(0)
  end
end)

-- ***************** NUI Callback Methods
-- Callbacks pages opening
RegisterNUICallback('question', function(data, cb)
  SendNUIMessage({openSection = "question"})
  cb('ok')
end)

-- Callback actions triggering server events
RegisterNUICallback('close', function(data, cb)
  -- if question success
  closeGui()
  cb('ok')
  DrawMissionText2("~b~O teste passou, agora você pode passar ao teste de direção", 2000)	
  theorylock = true
  testlock = false
  onTtest = false
end)

RegisterNUICallback('kick', function(data, cb)
    closeGui()
    cb('ok')
    DrawMissionText2("~r~Você falhou no teste, você pode tentar novamente outro dia", 2000)	
    onTtest = false
end)

---------------------------------- DMV PED ----------------------------------

Citizen.CreateThread(function()

  RequestModel(GetHashKey("a_m_y_business_01"))
  while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
    Wait(1)
  end

  RequestAnimDict("mini@strip_club@idles@bouncer@base")
  while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
    Wait(1)
  end

 	    -- Spawn the DMV Ped
  for _, item in pairs(dmvped) do
    dmvmainped =  CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
    SetEntityHeading(dmvmainped, 137.71)
    FreezeEntityPosition(dmvmainped, true)
	SetEntityInvincible(dmvmainped, true)
	SetBlockingOfNonTemporaryEvents(dmvmainped, true)
    TaskPlayAnim(dmvmainped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

local talktodmvped = true
--DMV Ped interaction
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), false)
		for k,v in ipairs(dmvpedpos) do
			if(Vdist(v.x, v.y, v.z, pos.x, pos.y, pos.z) < 1.0)then
				DisplayHelpText("Pressione ~INPUT_CONTEXT~ para interagir com o ~y~NPC")
				if(IsControlJustReleased(1, 38))then
						if talktodmvped then
						    Notify("~b~Bem vindo ao ~h~Detran!")
						    Citizen.Wait(500)
							DMVMenu()
							Menu.hidden = false
							talktodmvped = false
						else
							talktodmvped = true
						end
				end
				Menu.renderGUI(options)
			end
		end
	end
end)

------------
------------ DRAW MENUS
------------
function DMVMenu()
	ClearMenu()
    options.menu_title = "Detran"
	Menu.addButton("Obter uma carteira de motorista","VehLicenseMenu",nil)
    Menu.addButton("Close","CloseMenu",nil) 
end

function VehLicenseMenu()
    ClearMenu()
    options.menu_title = "Licença de veículo"
	Menu.addButton("Introdução    Grátis","startintro",nil)
	Menu.addButton("Teste de teoria    R$1000","startttest",nil)
	Menu.addButton("Teste prático    R$1200","startptest",nil)
    Menu.addButton("Return","DMVMenu",nil) 
end

function CloseMenu()
		Menu.hidden = true
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(true, true)
end

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
