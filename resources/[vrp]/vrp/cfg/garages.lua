
local cfg = {}
-- define garage types with their associated vehicles
-- (vehicle list: https://wiki.fivem.net/wiki/Vehicles)

-- each garage type is an associated list of veh_name/veh_definition 
-- they need a _config property to define the blip and the vehicle type for the garage (each vtype allow one vehicle to be spawned at a time, the default vtype is "default")
-- this is used to let the player spawn a boat AND a car at the same time for example, and only despawn it in the correct garage
-- _config: vtype, blipid, blipcolor, permissions (optional, only users with the permission will have access to the shop)
-- ["modelo"] = {"Nome Exibir", valor, "categoria", "maximo comprado em jogo"}

cfg.rent_factor = 0.1 -- 10% of the original price if a rent
cfg.sell_factor = 0.50 -- sell for 75% of the original price

cfg.garage_types = {
	-- Principais
	["Policia"] = {
		_config = {gpay="wallet",gtype={"rental"},permissions={"police.base"}},
		["paliorp"] = {"PM: Palio Weekend",0, "", -1},
		["spacefoxpm"] = {"PM: Spacefox",0, "", -1},
		["rocam"] = {"ROCAM: XT 660",0, "", -1},
		["tigerrocam"] = {"ROCAM: Tiger 800",0, "", -1},
		["hiluxft"] = {"FT: Hilux",0, "", -1},
		["hiluxft2"] = {"FT: Hilux (P4)",0, "", -1},
		["blazerft"] = {"FT: Blazer",0, "", -1},
		["hiluxrota"] = {"RT: Hilux",0, "", -1},
		["hiluxrota2"] = {"RT: Hilux (P4)",0, "", -1},
		["riotrt"] = {"RT: Blindado",0, "", -1},
		["policet"] = {"PM: Sprinter Base Movel",0, "", -1},
		["pbus"] = {"PM: Onibus",0, "", -1},
		["fbi"] = {"RT: Descaracterizado",0, "", -1},
	},
	["Policia Heli"] = {
		_config = {gpay="wallet",gtype={"rental"},permissions={"police.base"}},
		["as350"] = {"Heli Aguia SP",0, "", -1}
	},
	--["Federal"] = {
	--	_config = {gpay="wallet",gtype={"rental"},permissions={"federal.vehicle"}},
	--	["federal"] = {"Ford F150",0, "", -1},
	--	["hitman"] = {"BMW X6",0, "", -1}
	--},
	--["Federal Heli"] = {
	--	_config = {gpay="wallet",gtype={"rental"},permissions={"federal.vehicle"}},
	--},
	["Samu"] = {
		_config = {gpay="wallet",gtype={"rental"},permissions={"samu.vehicle"}},
		["ambulance"] = {"Ambulancia",0, "", -1},
		["hbomb"] = {"Hilux Samu",0, "", -1},
		["sprintersamu"] = {"Sprinter Samu",0, "", -1},
		["ems_gs1200"] = {"Moto Samu",0, "", -1},
		["riot2"] = {"Carro Halloween",0, "", -1},
	},
	["Samu Heli"] = {
		_config = {gpay="wallet",gtype={"rental"},permissions={"samu.vehicle"}},
		["mh65c"] = {"Heli MH65C",0, "", -1},
		["mh60t"] = {"Heli MH60T",0, "", -1}
	},
	--["Guarda Costeira"] = {
	--	_config = {gpay="wallet",gtype={"rental"},permissions={"cbm.vehicle"}},
	--	["dinghy"] = {"Barco Inflavel",0, "", -1},
	--	["lguard"] = {"SUV",0, "", -1},
	--	["blazer2"] = {"Quadriciclo",0, "", -1},
	--},

	["Concessionaria"] = {
		_config = {gpay="wallet",gtype={"store"},blipid=225,blipcolor=4},
		["manana"] = {"Dodge Monaco 1973", 37000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/e/ed/Manana-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160304225517' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 130 KM/h<br/>Peso: 2,100 KG<br/>Tração: Dianteira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["picador"] = {"Chevrolet El Camino 1969", 20000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/5a/Picador-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160304225738' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 135 KM/h<br/>Peso: 1,600 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["surfer"] = {"Volkswagen Kombi 1949", 35000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/ac/Surfer-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409182213' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Vans<br/>Portas: 2<br/>Top Speed: 100 KM/h<br/>Peso: 2,500 KG<br/>Tração: Dianteira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["panto"] = {"Smart Fortwo 2007", 40000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/ad/Panto-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160406180025' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 80 KG<br/><br/>Classe: Compacto<br/>Portas: 2<br/>Top Speed: 132 KM/h<br/>Peso: 800 KG<br/>Tração: Dianteira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 40},

		["blista2"] = {"VW Gol Quadrado", 20000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/0/06/BlistaCompact-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929162026' /><br/><br/>Estoque Max: 60<br/>Porta Malas: 120 KG<br/><br/>Classe: Compacto<br/>Portas: 2<br/>Top Speed: 132 KM/h<br/>Peso: 1,050 KG<br/>Tração: Dianteira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 60},
		["blista"] = {"VW Gol G6", 35000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/c/c0/Blista-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409171328' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Compacto<br/>Portas: 2<br/>Top Speed: 135 KM/h<br/>Peso: 1,200 KG<br/>Tração: Dianteira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["dominator"] = {"Ford Mustang GT", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/78/Dominator-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160702195350' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
		["camaro2012"] = {"Chevrolet Camaro 2010", 150000, "<img src='nui://vrp/gui/cars/camaross2010.png' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
		["seminole"] = {"Jeep Grand Cherokee", 80000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a0/Seminole-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160211192105' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 130 KM/h<br/>Peso: 2,400 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		["bjxl"] = {"Jeep Renegade", 70000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/da/BeeJayXL-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929171015' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 130 KM/h<br/>Peso: 2,400 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		["baller"] = {"Land Rover Discovery 3", 50000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/3d/Baller-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929171013' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 130 KM/h<br/>Peso: 2,400 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		["gresley"] = {"BMW X3", 80000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/f/ff/Gresley-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160308180844' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 135 KM/h<br/>Peso: 2,200 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 20},

		["kuruma"] = {"Lancer Evolution", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/53/Kuruma-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160501145849' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 4<br/>Top Speed: 143 KM/h<br/>Peso: 1,500 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 10},
		["sultan"] = {"Subaru Impreza", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/bb/Sultan-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20180331183641' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 4<br/>Top Speed: 145 KM/h<br/>Peso: 1,400 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
		["ninef"] = {"Audi R8", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/2/2d/9F-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150529201705' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,300 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 10},
		["ninef2"] = {"Audi R8 Spyder", 195000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a1/9FCabrio-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150529201708' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,300 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 10},
		["buffalo"] = {"Dodge Charger", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/7d/Buffalo-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20180331183432' /><br/><br/>Estoque Max: 14<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 4<br/>Top Speed: 145 KM/h<br/>Peso: 1,650 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		["dukes"] = {"Dodge Charger 1968", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/53/Dukes-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150530114053' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 144 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 6},
		["penumbra"] = {"Mitsubishi Eclipse", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/c/cc/Penumbra-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20171024163859' /><br/><br/>Estoque Max: 14<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		
		-- Novos carros Addons:
		["fulux63"] = {"Volkswagem Fusca 1963", 20000, "<img src='nui://vrp/gui/cars/fusca63.png' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Compacto<br/>Portas: 2<br/>Top Speed: 110 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["ftoro"] = {"Fiat Toro", 110000, "<img src='nui://vrp/gui/cars/ftoro.png' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 110 KM/h<br/>Peso: 1,200 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["vwstance"] = {"Volkswagem Passat", 150000, "<img src='nui://vrp/gui/cars/passat.png' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 120 KG<br/><br/>Classe: Sedan<br/>Portas: 4<br/>Top Speed: 130 KM/h<br/>Peso: 1,850 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 30},
		["veloster"] = {"Hyndai Veloster", 170000, "<img src='nui://vrp/gui/cars/veloster.png' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 120 KG<br/><br/>Classe: Compacto<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,300 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 20},
		
		-- Novos carros
		["patriot"] = {"Hummer H1", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/54/Patriot-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409181625' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 140 KM/h<br/>Peso: 2,500 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		["baller2"] = {"Range Rover Vogue", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/e/ef/Baller2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929171011' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 135 KM/h<br/>Peso: 2,200 KG<br/>Tração: Dianteira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		["radi"] = {"Ford Edge 2011", 60000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/b6/Radius-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409181754' /><br/><br/>Estoque Max: 15<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 140 KM/h<br/>Peso: 2,400 KG<br/>Tração: Dianteira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 30},
		["rocoto"] = {"Audi Q5", 90000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/2/28/Rocoto-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160213013426' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 160 KG<br/><br/>Classe: SUV<br/>Portas: 4<br/>Top Speed: 139 KM/h<br/>Peso: 2,400 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		
		["f620"] = {"Maserati GranTurismo", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/f/f8/F620-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929162327' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Coupe<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,700 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 40},
		["oracle2"] = {"BMW 7 Series", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a4/Oracle-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160406180530' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Sedan<br/>Portas: 4<br/>Top Speed: 110 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["windsor2"] = {"Rolls-Royce Dawn", 200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/31/WindsorDropUp-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160607131007' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 120 KG<br/><br/>Classe: Sedan<br/>Portas: 4<br/>Top Speed: 150 KM/h<br/>Peso: 3,000 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		["schafter2"] = {"Mercedes-Benz CL-Class C216", 190000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/57/Schafter-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409181945' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 120 KG<br/><br/>Classe: Sedan<br/>Portas: 4<br/>Top Speed: 145 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 20},
		["fugitive"] = {"Chevrolet Malibu", 130000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/5c/Fugitive-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161018180444' /><br/><br/>Estoque Max: 60<br/>Porta Malas: 120 KG<br/><br/>Classe: Sedan<br/>Portas: 4<br/>Top Speed: 145 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 60},
		
		["elegy2"] = {"Nissan GT-R", 300000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/4f/ElegyRH8-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160525194616' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,700 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 30},
		["comet5"] = {"Porsche 997 GT2 RS", 350000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/0/0f/CometSR-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218193000' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 160 KM/h<br/>Peso: 1,500 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 30},
		["carbonizzare"] = {"Ferrari F12", 400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/7b/CarbonizzareDown-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160917231442' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 158 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 30},
		["banshee2"] = {"Dodge Viper RT/10", 500000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9e/BansheeTopless-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929173526' /><br/><br/>Estoque Max: 24<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 148 KM/h<br/>Peso: 1,200 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 24},
		["surano"] = {"Jaguar F-Type", 350000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/f/fd/SuranoDown-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160305181513' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 30},
		["voodoo"] = {"Chevrolet Impala", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/f/fc/VoodooCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160502170144' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Classic<br/>Portas: 2<br/>Top Speed: 130 KM/h<br/>Peso: 2,100 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 10},
		["hermes"] = {"Hudson Hornet", 200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9b/Hermes-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218203929' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 137 KM/h<br/>Peso: 1,300 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 10},
		["sabregt2"] = {"Chevrolet Chevelle SS", 250000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/18/SabreTurboCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160316181730' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,300 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 6},
		["brawler"] = {"Rally Fighter", 250000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/6c/Brawler-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160929162450' /><br/><br/>Estoque Max: 32<br/>Porta Malas: 120 KG<br/><br/>Classe: Off-Road<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 2,100 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 32},
		["riata"] = {"Ford Bronco Concept", 330000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/67/Riata-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218203640' /><br/><br/>Estoque Max: 24<br/>Porta Malas: 120 KG<br/><br/>Classe: Off-Road<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 2,100 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 24},
		["kamacho"] = {"Jeep Crew Chief 715", 300000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/47/Kamacho-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218203725' /><br/><br/>Estoque Max: 24<br/>Porta Malas: 200 KG<br/><br/>Classe: Off-Road<br/>Portas: 4<br/>Top Speed: 150 KM/h<br/>Peso: 2,100 KG<br/>Tração: Integral<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 24},
		["rebel2"] = {"Toyota Hilux 1988", 50000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/6a/Rebel2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160702195655' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 120 KG<br/><br/>Classe: Off-Road<br/>Portas: 2<br/>Top Speed: 130 KM/h<br/>Peso: 2,400 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["moonbeam2"] = {"Chevrolet Astro 1985", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/94/MoonbeamCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160502165739' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Van<br/>Portas: 4<br/>Top Speed: 125 KM/h<br/>Peso: 2,400 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 6},
		["buccaneer2"] = {"Chevrolet Monte Carlo 1972", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a2/BuccaneerCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160502170017' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 146 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 6},
		["primo2"] = {"Toyota Carina", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/c/ca/PrimoCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20151021162950' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 4<br/>Top Speed: 140 KM/h<br/>Peso: 1,800 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
	},
	["Motos"] = {
		_config = {gpay="wallet",gtype={"store"}},
		["faggio"] = {"Honda Bis", 10000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/50/FaggioSport-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161004182412' /><br/><br/>Estoque Max: 60<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 95 KM/h<br/>Peso: 110 KG<br/>Tração: Traseira<br/>Marchas: 3<br/>Motor: Gasolina<br/>", 60},
		["pcj"] = {"Honda CB 400", 25000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/74/PCJ600-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160121201111' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["nemesis"] = {"Ducati Hypermotard", 50000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/4b/Nemesis-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160126214050' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["bagger"] = {"Harley D. T. Road", 45000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/10/Bagger-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160121202520' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 100 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 130 KM/h<br/>Peso: 230 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["zombiea"] = {"Harley D. Slim Bob", 65000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/af/ZombieBobber-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161004181721' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 1<br/>Top Speed: 137 KM/h<br/>Peso: 225 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["zombieb"] = {"Harley D. Fat Bob", 75000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/70/ZombieChopper-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161004181804' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 100 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 130 KM/h<br/>Peso: 230 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 40},
		["ruffian"] = {"Ducati Monster", 80000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/70/Ruffian-GTAV-front-variant2.png/revision/latest/scale-to-width-down/350?cb=20160204203513' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["double"] = {"Honda CBR 1000 RR", 100000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/8c/DoubleT-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160126212153' /><br/><br/>Estoque Max: 30<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 30},
		["fcr2"] = {"BMW R100", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/87/FCR1000Custom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161213202416' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 1<br/>Top Speed: 140 KM/h<br/>Peso: 200 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 20},
		["diablous2"] = {"Ducati Diavel Draxter", 120000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/11/DiabolusCustom-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161213202213' /><br/><br/>Estoque Max: 20<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 1<br/>Top Speed: 142 KM/h<br/>Peso: 210 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 20},
		["nightblade"] = {"Harley D. Dyna Street Bob", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/6b/Nightblade-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161014165516' /><br/><br/>Estoque Max: 14<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 125 KM/h<br/>Peso: 300 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		["bati"] = {"Ducati 1199", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/d9/Bati801-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160127211358' /><br/><br/>Estoque Max: 14<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
		["sanchez"] = {"Yamaha YZ 450F", 40000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/93/Sanchez2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160222221404' /><br/><br/>Estoque Max: 40<br/>Porta Malas: 30 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 190 KM/h<br/>Peso: 500 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 40},
		["chimera"] = {"Tricycle", 90000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/8a/Chimera-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161014164901' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 1<br/>Top Speed: 135 KM/h<br/>Peso: 401 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>Obs: Impossível Tunar<br/>", 10},
		["hakuchou"] = {"Suzuki Hayabusa", 150000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/ab/Hakuchou-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160302173513' /><br/><br/>Estoque Max: 14<br/>Porta Malas: 75 KG<br/><br/>Classe: Motos<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 250 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 14},
	},
	["Luxury Classics"] = {
		_config = {gpay="wallet",gtype={"store"}},
		["ardent"] = {"Lotus Esprit", 450000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/80/Ardent-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170614143447' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 148 KM/h<br/>Peso: 1,200 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["viseris"] = {"De Tomaso Pantera GTS", 1200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/b2/Viseris-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218193459' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["ztype"] = {"Bugatti Type 57SC Atlantic 1937", 1200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9d/Z-Type-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160917231447' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,000 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["rapidgt3"] = {"1972 Aston Martin V8", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/13/RapidGTClassic-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170916171351' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 1,570 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["z190"] = {"Nissan 240z", 400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/be/190z-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218203545' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: XXX KM/h<br/>Peso: X,X00 KG<br/>Tração: Traseira<br/>Marchas: X<br/>Motor: Gasolina<br/>", 7},
		["turismo2"] = {"Ferrari F40", 800000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9a/TurismoClassic-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170314170520' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 7},
		["cheetah2"] = {"Ferrari Testarossa", 750000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/38/CheetahClassic-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170614143349' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,500 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["savestra"] = {"Mazda Savanna 1970", 400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/d6/Savestra-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218204635' /><br/><br/>Estoque Max: 12<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: XXX KM/h<br/>Peso: X,X00 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 12},
		["infernus2"] = {"Lamborghini Diablo", 800000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/73/InfernusClassic-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170314170313' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 149 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["coquette2"] = {"Chevrolet Corvette C2 1967", 600000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/0/0b/CoquetteClassic-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160117175931' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 7},
		["torero"] = {"Lamborghini Countach 1990", 675000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/47/Torero-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170614143234' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 149 KM/h<br/>Peso: 1,470 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 7},
		["jb700"] = {"Aston Martin DB5", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/70/JB700-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409201623' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["gt500"] = {"Ferrari 250 GT SWB", 550000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/2/25/GT500-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218203343' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,764 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["peyote"] = {"Ford Thunderbird 1955", 180000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/c/c8/Peyote-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160409202014' /><br/><br/>Estoque Max: 8<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 135 KM/h<br/>Peso: 1,700 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 8},
		["btype"] = {"Cadillac 341A 1928", 1000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/b4/Roosevelt-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160214204307' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 6<br/>Top Speed: 125 KM/h<br/>Peso: 2,400 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["btype3"] = {"Cadillac 341A Al Capone 1928", 1200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/2/2a/RooseveltValor-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160214204109' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 6<br/>Top Speed: 125 KM/h<br/>Peso: 2,400 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["btype2"] = {"Cadillac 341A Hot Rod", 1500000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/63/FränkenStange-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161014163938' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 4<br/>Top Speed: 135 KM/h<br/>Peso: 1,800 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["casco"] = {"Maserati 3500 GT 1957", 800000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/86/Casco-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160304220406' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 151 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["mamba"] = {"AC-Shelby Cobra 1962", 950000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/d4/Mamba-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160117195426' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 148 KM/h<br/>Peso: 1,160 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 3},
		["feltzer3"] = {"Mercedes-Benz 300 SL 1952", 850000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/d2/StirlingGT-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150614114322' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,330 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 3},
		["retinue"] = {"Ford Escort Mk. I 1968", 550000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/b8/Retinue-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171220192309' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 900 KG<br/>Tração: Traseira<br/>Marchas: 4<br/>Motor: Gasolina<br/>", 10},
		["monroe"] = {"Lamborghini Miura 1966", 800000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/44/Monroe-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160529141803' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 1,200 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["pigalle"] = {"Citroen SM 1970", 300000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/d/d4/Pigalle-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160302171416' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 149 KM/h<br/>Peso: 1,500 KG<br/>Tração: Dianteira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
		["stinger"] = {"Corvette Split-Window 1963", 330000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/41/Stinger-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160917231452' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 7},
		["stingergt"] = {"Ferrari 250 GTO 1962", 400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/c/c5/StingerGT-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160606121633' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 7},
		["bullet"] = {"Ford GT40 1964", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/3d/Bullet-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20180331183434' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports Classics<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5}
	},
	["Luxury Autos"] = {
		_config = {gpay="wallet",gtype={"store"}},
		["cheetah"] = {"Ferrari FXX 2005", 650000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/1e/Cheetah-GTAV-Front.png/revision/latest/scale-to-width-down/350?cb=20180331183553' /><br/><br/>Estoque Max: 7<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 153 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 7},
		["infernus"] = {"Jaguar XJR-15 1990", 1100000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/0/0e/Infernus-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160429175116' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 160 KM/h<br/>Peso: 1,700 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 6},
		["tempesta"] = {"Lamborghini Huracan 2014", 2500000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/35/Tempesta-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161213203018' /><br/><br/>Estoque Max: 4<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 157 KM/h<br/>Peso: 1,422 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 4},
		["turismor"] = {"Ferrari LaFerrari", 1400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/61/TurismoR-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161111200407' /><br/><br/>Estoque Max: 4<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,350 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 4},
		["vacca"] = {"Lamborghini Gallardo", 1000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/b/b4/Vacca-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20180331183726' /><br/><br/>Estoque Max: 4<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,200 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 4},
		["massacro"] = {"Ferrari F12 Berlinetta", 750000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/12/Massacro-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20180331183607' /><br/><br/>Estoque Max: 8<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 156 KM/h<br/>Peso: 1,700 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 8},
		["rapidgt"] = {"Aston Martin Vantage", 400000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/42/RapidGT-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150529203102' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 10},
		["rapidgt2"] = {"Aston Martin Vantage Spyder", 450000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/f/f8/RapidGT2-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150529203104' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,600 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 10},
		["bestiagts"] = {"Ferrari GTC4Lusso", 1000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a5/BestiaGTS-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161014162647' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,800 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 5},
		["feltzer2"] = {"Mercedes-Benz SLK Brabus", 650000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/8f/Feltzer-GTAVPC-Front.png/revision/latest/scale-to-width-down/350?cb=20150718115304' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 10},
		["verlierer2"] = {"TVR Sagaris 2005", 850000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/8c/Verlierer-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20180331183730' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 150 KM/h<br/>Peso: 1,100 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 5},
		["seven70"] = {"Aston Martin One-77", 850000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/2/21/Seven70-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161014163258' /><br/><br/>Estoque Max: 4<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 159 KM/h<br/>Peso: 1,650 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 4},
		["jester"] = {"Acura NSX 2015", 750000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/af/Jester-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160917231438' /><br/><br/>Estoque Max: 8<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 158 KM/h<br/>Peso: 1,300 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 8},
		["khamelion"] = {"Fisker Karma 2011", 650000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/1f/Khamelion-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160917231447' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 140 KM/h<br/>Peso: 1,800 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["furoregt"] = {"Jaguar F-Type R", 950000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/56/FuroreGT-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20160302175246' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,350 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 6},
		["lynx"] = {"Jaguar F-Type SVR", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/a/a7/Lynx-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20160712123941' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 157 KM/h<br/>Peso: 1,725 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["voltic"] = {"Lotus Elise 1996", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/87/Voltic-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20161111200411' /><br/><br/>Estoque Max: 10<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 145 KM/h<br/>Peso: 1,030 KG<br/>Tração: Dianteira<br/>Marcha: 1<br/>Motor: Eletrico<br/>", 10},
		["specter"] = {"Aston Martin DB10", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/7/7b/Specter-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161213202907' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 155 KM/h<br/>Peso: 1,550 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 5},
		["dominator3"] = {"Ford Mustang 2015", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/8/8b/DominatorGTX-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20180328210557' /><br/><br/>Estoque Max: 6<br/>Porta Malas: 120 KG<br/><br/>Classe: Muscle<br/>Portas: 2<br/>Top Speed: 146 KM/h<br/>Peso: 1,670 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 6},
		["jester3"] = {"Toyota Supra", 700000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/1/1a/JesterClassic-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20180728193022' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Sports<br/>Portas: 2<br/>Top Speed: 152 KM/h<br/>Peso: 1,000 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 3},
		["entity2"] = {"Koenigsegg One", 2000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9a/EntityXXR-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20180325152709' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 170 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["xa21"] = {"Jaguar C-X75", 3000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/6/69/XA21-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20170614143529' /><br/><br/>Estoque Max: 5<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 160 KM/h<br/>Peso: 1,450 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 5},
		["taipan"] = {"Hennessey Venom F5", 1200000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/4/4c/Taipan-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20180328210610' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 170 KM/h<br/>Peso: 1,400 KG<br/>Tração: Traseira<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["osiris"] = {"Pagani Huayra", 4500000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/5/53/Osiris-GTAV-front.png/revision/latest/scale-to-width-down/350?cb=20150614104749' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 160 KM/h<br/>Peso: 1,350 KG<br/>Tração: Integral<br/>Marchas: 6<br/>Motor: Gasolina<br/>", 3},
		["penetrator"] = {"Jaguar XJ220", 1900000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/9/9c/Penetrator-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20161213202741' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: 160 KM/h<br/>Peso: 1,470 KG<br/>Tração: Integral<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 3},
		["sc1"] = {"BMW M1 Homage Concept", 1000000, "<img src='https://vignette.wikia.nocookie.net/gtawiki/images/3/3a/SC1-GTAO-front.png/revision/latest/scale-to-width-down/350?cb=20171218192734' /><br/><br/>Estoque Max: 3<br/>Porta Malas: 120 KG<br/><br/>Classe: Super<br/>Portas: 2<br/>Top Speed: XXX KM/h<br/>Peso: X,X00 KG<br/>Tração: Traseira<br/>Marchas: 5<br/>Motor: Gasolina<br/>", 3},
	},
	["Luxury Supers"] = {
		_config = {gpay="wallet",gtype={"store"}},
	},
	["Bicicletas"] = {
		_config = {gpay="wallet",gtype={"rental"},blipid=226,blipcolor=4},
		["BMX"] = {"BMX", 0, "", -1},
	},

	["BicicletasPrisao"] = {
		_config = {gpay="wallet",gtype={"rental"}},
		["BMX"] = {"BMX", 0, "", -1},
	},
	["Garagem Pessoal"] = {
		_config = {gpay="wallet",gtype={"personal"},blipid=357,blipcolor=3}
	},
	--[[
	["Compactos"]  = {
		_config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
		["blista"] = {"Blista", 15000, "", -1},
		["brioso"] = {"Brioso R/A", 45000, "", -1},
		["dilettante"] = {"Dilettante", 20000, "", -1},
		["issi2"] = {"Issi", 25000, "", -1},
		["panto"] = {"Panto", 15000, "", -1},
		["prairie"] = {"Prairie", 35000, "", -1},
		["rhapsody"] = {"Rhapsody", 20000, "", -1}
    },


  ["Coupe"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["cogcabrio"] = {"Cognoscenti Cabrio",60000, "", -1},
    ["exemplar"] = {"Exemplar", 80000, "", -1},
    ["f620"] = {"F620", 90000, "", -1},
    ["felon"] = {"Felon", 80000, "", -1},
    ["felon2"] = {"Felon GT", 90000, "", -1},
    ["jackal"] = {"Jackal", 80000, "", -1},
    ["oracle"] = {"Oracle", 75000, "", -1},
    ["oracle2"] = {"Oracle XS",90000, "", -1},
    ["sentinel"] = {"sentinel", 80000, "", -1},
    ["sentinel2"] = {"Sentinel XS", 90000, "", -1},
    ["windsor"] = {"Windsor",160000, "", -1},
    ["windsor2"] = {"Windsor Drop",250000, "", -1},
    ["zion"] = {"Zion", 80000, "", -1},
    ["zion2"] = {"Zion Cabrio", 90000, "", -1}
    },

  ["Esportivos"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["ninef"] = {"9F",140000, "", -1},
    ["ninef2"] = {"9F Cabrio",155000, "", -1},
    ["alpha"] = {"Alpha",130000, "", -1},
    ["banshee"] = {"Banshee",145000, "", -1},
    ["bestiagts"] = {"Bestia GTS",150000, "", -1},4
    ["blista2"] = {"Blista Compact",30000, "", -1},
    ["blista3"] = {"Blista Go Go Monkey",40000, "", -1},
    ["buffalo"] = {"Buffalo",110000, "", -1},
    ["buffalo2"] = {"Buffalo S",115000, "", -1},
    ["buffalo3"] = {"Buffalo Sprunk",130000, "", -1},
    ["carbonizzare"] = {"Carbonizzare",185000, "", -1},
    ["comet2"] = {"Comet",180000, "", -1},
    ["comet3"] = {"Comet Retro Custom",260000, "", -1},
    ["coquette"] = {"Coquette",200000, "", -1},
    ["tampa2"] = {"Drift Tampa",200000, "", -1},
    ["elegy2"] = {"Elegy RH8",130000, "", -1},
    ["elegy"] = {"Elegy Retro Custom",125000, "", -1},
    ["feltzer2"] = {"Feltzer",170000, "", -1},
    ["furoregt"] = {"Furore GT",200000, "", -1},
    ["fusilade"] = {"Fusilade",130000, "", -1},
    ["futo"] = {"Futo",100000, "", -1},
    ["jester"] = {"Jester",240000, "", -1},
    ["jester2"] = {"Jester (Racecar)",260000, "", -1},
    ["khamelion"] = {"Khamelion",190000, "", -1},
    ["kuruma"] = {"Kuruma",120000, "", -1},
    ["lynx"] = {"Lynx",180000, "", -1},
    ["massacro"] = {"Massacro",160000, "", -1},
    ["massacro2"] = {"Massacro (Racecar)",250000, "", -1},
    ["omnis"] = {"Omnis",140000, "", -1},
    ["penumbra"] = {"Penumbra",70000, "", -1},
    ["rapidgt"] = {"Rapid GT",140000, "", -1},
    ["rapidgt2"] = {"Rapid GT Convertible",150000, "", -1},
    ["raptor"] = {"Raptor",100000, "", -1},
    ["ruston"] = {"Ruston",160000, "", -1},
    ["schafter3"] = {"Schafter V12",90000, "", -1},
    ["schafter4"] = {"Schafter LWB",40000, "", -1},
    ["schwarzer"] = {"Schwarzer",90000, "", -1},
    ["seven70"] = {"Seven-70",360000, "", -1},
    ["specter"] = {"Specter",370000, "", -1},
    ["specter2"] = {"Specter Custom",400000, "", -1},
    ["sultan"] = {"Sultan",120000, "", -1},
    ["surano"] = {"Surano",180000, "", -1},
    ["tropos"] = {"Tropos",500000, "", -1},
    ["verlierer2"] = {"Verlierer",180000,"", -1}
    },

  ["Classicos Esportivos"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=5},
    --["ardent"] = {"Ardent",1150000, "", -1},
    ["casco"] = {"Casco",680000, "", -1},
    ["cheetah2"] = {"Cheetah Classic",865000, "", -1},
    ["coquette2"] = {"Coquette Classic",665000, "", -1},
    ["btype2"] = {"Franken Stange",550000, "", -1},
    ["infernus2"] = {"Infernus Classic",915000, "", -1},
    ["jb700"] = {"JB 700",350000, "", -1},
    ["mamba"] = {"Mamba",995000, "", -1},
    ["manana"] = {"Manana",80000, "", -1},
    ["monroe"] = {"Monroe",490000, "", -1},
    ["peyote"] = {"Peyote",100000, "", -1},
    ["btype"] = {"Roosevelt",750000, "", -1},
    ["btype3"] = {"Roosevelt",982000, "", -1},
    ["pigalle"] = {"Pigalle",400000, "", -1},
    ["stinger"] = {"Stinger",850000, "", -1},
    ["stingergt"] = {"Stinger GT",875000, "", -1},
    ["feltzer3"] = {"Stirling",975000, "", -1},
    ["torero"] = {"Torero",998000, "", -1},
    ["tornado"] = {"Tornado",30000, "", -1},
    ["tornado5"] = {"Tornado Custom",375000, "", -1},
    ["tornado6"] = {"Tornado Rat Rod",378000, "", -1},
    ["turismo2"] = {"Turismo Classic",378000, "", -1},
    ["ztype"] = {"Z-Type",950000,"", -1}
  },

  ["Carros Super"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=5},
    ["pfister811"] = {"811",1100000, "", -1},
    ["adder"] = {"Adder",1000000, "", -1},
    ["banshee2"] = {"Banshee 900R",800000, "", -1},
    ["bullet"] = {"Bullet",800000, "", -1},
    ["cheetah"] = {"Cheetah",1500000, "", -1},
    ["entityxf"] = {"Entity XF",950000, "", -1},
    ["sheava"] = {"ETR1",975000, "4 - (smaller number better car", -1},
    --["fmj"] = {"FMJ",1750000, "10 - (smaller number better car,carro n spawna"},
    ["gp1"] = {"GP1",1260000, "", -1},
    ["infernus"] = {"Infernus",600000, "", -1},
    ["italigtb"] = {"Itali GTB",1189000, "", -1},
    ["italigtb2"] = {"Itali GTB Custom",1450000, "", -1},
    ["nero"] = {"Nero",1440000, "", -1},
    ["nero2"] = {"Nero Custom",1600000, "", -1},
    ["osiris"] = {"Osiris",1550000, "8 - (smaller number better car", -1},
    ["penetrator"] = {"Penetrator",880000, "", -1},
    ["le7b"] = {"RE-7B",5075000, "1 - (smaller number better car", -1},
    ["reaper"] = {"Reaper",1595000, "", -1},
    --["voltic2"] = {"Rocket Voltic",3830400, ""}, EVENTO
    ["sultanrs"] = {"Sultan RS",795000, "", -1},
    ["t20"] = {"T20",1400000,"7 - (smaller number better car", -1},
    ["tempesta"] = {"Tempesta",1329000, "", -1},
    ["turismor"] = {"Turismo R",500000, "9 - (smaller number better car", -1},
    ["tyrus"] = {"Tyrus",2550000, "5 - (smaller number better car", -1},
    ["vacca"] = {"Vacca",240000, "", -1},
    ["vagner"] = {"Vagner",1535000, "", -1},
    ["voltic"] = {"Voltic",140000, "", -1},
    ["prototipo"] = {"X80 Proto",1400000, "6 - (smaller number better car", -1},
    ["xa21"] = {"XA-21",2375000, "", -1},
    ["zentorno"] = {"Zentorno",1250000,"3 - (smaller number better car", -1}
  },

  ["Carros Muscle"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["blade"] = {"Blade",160000, "", -1},
    ["buccaneer"] = {"Buccaneer",29000, "", -1},
    ["buccaneer2"] = {"Buccaneer Custom",390000, "", -1},
    ["stalion2"] = {"Stallion Burger Shot",277000, "", -1},
    ["chino"] = {"Chino",225000, "", -1},
    ["chino2"] = {"Chino Custom",325000, "", -1},
    ["coquette3"] = {"Coquette BlackFin",695000, "", -1},
    ["dominator"] = {"Dominator",35000, "", -1},
    ["dukes"] = {"Dukes",62000, "", -1},
    ["faction"] = {"Faction",36000, "", -1},
    ["faction2"] = {"Faction Custom",335000, "", -1},
    ["faction3"] = {"Faction Custom Donk",695000, "", -1},
    ["gauntlet"] = {"Gauntlet",32000, "", -1},
    ["hotknife"] = {"Hotknife",90000, "", -1},
    ["lurcher"] = {"Lurcher",650000, "", -1},
    ["moonbeam"] = {"Moonbeam",32500, "", -1},
    ["moonbeam2"] = {"Moonbeam Custom",370000, "", -1},
    ["nightshade"] = {"Nightshade",585000, "", -1},
    ["phoenix"] = {"Phoenix",30000, "", -1},
    ["picador"] = {"Picador",9000, "", -1},
    ["dominator2"] = {"Dominator Pibwasser",315000, "", -1},
    ["ratloader"] = {"Rat-Loader",6000, "", -1},
    ["ratloader2"] = {"Rat-Truck",37500, "", -1},
    ["gauntlet2"] = {"Gauntlet Redwood",230000, "", -1},
    ["ruiner"] = {"Ruiner",45000, "", -1},
    ["sabregt"] = {"Sabre Turbo",15000, "", -1},
    ["sabregt2"] = {"Sabre Turbo Custom",490000, "", -1},
    ["slamvan"] = {"Slamvan",49500, "", -1},
    ["slamvan3"] = {"Slamvan Custom",415000, "", -1},
    ["stalion"] = {"Stalion",71000, "", -1},
    ["tampa"] = {"Tampa",375000, "", -1},
    ["vigero"] = {"Vigero",21000, "", -1},
    ["virgo"] = {"Virgo",195000, "", -1},
    ["virgo3"] = {"Virgo Classic",295000, "", -1},
    ["virgo2"] = {"Virgo Classic Custom",395000, "", -1},
    ["voodoo"] = {"Voodoo Custom",420000, "", -1},
    ["voodoo2"] = {"Voodoo Beater",5500, "", -1}
  },

  ["Off-Road"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["bifta"] = {"Bifta",10000, "", -1},
    ["blazer"] = {"Blazer",12000, "", -1},
    ["bodhi2"] = {"Bodhi",20000, "", -1},
    ["brawler"] = {"Brawler",80000, "", -1},
    ["trophytruck2"] = {"Desert Raid",100000, "", -1},
    ["dubsta3"] = {"Dubsta 6x6",250000, "", -1},
    ["dune"] = {"Dune Buggy",35000, "", -1},
    ["blazer3"] = {"Hot Rod Blazer",55000, "", -1},
    ["bfinjection"] = {"Injection",20000, "", -1},
    ["kalahari"] = {"Kalahari",80000, "", -1},
    ["marshall"] = {"Marshall",560000, "", -1},
    ["rebel2"] = {"Rebel",35000, "", -1},
    ["rebel"] = {"Rusty Rebel",15000, "", -1},
    ["sandking"] = {"Sandking XL",65000, "", -1},
    ["blazer4"] = {"Street Blazer",81000, "", -1}
    --["trophytruck"] = {"Trophy Truck",250000, ""}EVENTO
  },

  ["SUVs"]  = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["baller"] = {"Baller",20000, "", -1},
    ["baller2"] = {"Baller 2nd",150000, "", -1},
    ["baller4"] = {"Baller LE LWB",250000, "", -1},
    ["bjxl"] = {"BeeJay XL",95000, "", -1},
    ["cavalcade"] = {"Cavalcade",75000, "", -1},
    ["cavalcade2"] = {"Cavalcade 2nd",85000, "", -1},
    ["contender"] = {"Contender",175000, "", -1},
    ["dubsta2"] = {"Dubsta",56000, "", -1},
    ["fq2"] = {"FQ 2",45000, "", -1},
    ["granger"] = {"Granger",66000, "", -1},
    ["gresley"] = {"Gresley",49000, "", -1},
    ["habanero"] = {"Habanero",32500, "", -1},
    ["huntley"] = {"Huntley",100000, "", -1},
    ["landstalker"] = {"Landstalker",78000, "", -1},
    ["mesa"] = {"Mesa",45000, "", -1},
    ["mesa3"] = {"Mesa Merryweather",90000, "", -1},
    ["patriot"] = {"Patriot",56000, "", -1},
    ["radi"] = {"Radius",45000, "", -1},
    ["rocoto"] = {"Rocoto",65000, "", -1},
    ["sadler"] = {"Sadler",78000, "", -1},
    ["seminole"] = {"Seminole",34000, "", -1},
    ["serrano"] = {"Serrano",89000, "", -1},
    ["xls"] = {"XLS",65000, "", -1}
  },

  ["Vans"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["bison"] = {"Bison",79000, "", -1},
    ["bobcatxl"] = {"Bobcat XL",190000, "", -1},
    ["burrito3"] = {"Burrito",85000, "", -1},
    ["camper"] = {"Camper",375000, "", -1},
    ["journey"] = {"Journey",275000, "", -1},
    ["minivan"] = {"Minivan",30000, "", -1},
    ["minivan2"] = {"Minivan Custom",45000, "", -1},
    ["paradise"] = {"Paradise",89000, "", -1},
    ["rumpo"] = {"Rumpo",69000, "", -1},
    ["rumpo3"] = {"Rumpo Custom",195000, "", -1},
    ["speedo"] = {"Speedo",49000, "", -1},
    ["youga"] = {"Youga",78000, "", -1}
  },

  ["Sedans"] = {
    _config = {gpay="bank",gtype={"store"},vtype="car",blipid=50,blipcolor=4},
    ["cognoscenti"] = {"Cognoscenti",130000, "", -1},
    ["cog55"] = {"Cognoscenti 55",160000, "", -1},
    ["emperor"] = {"Emperor",95000, "", -1},
    ["emperor2"] = {"Emperor Rusty",67000, "", -1},
    ["fugitive"] = {"Fugitive",98000, "", -1},
    ["glendale"] = {"Glendale",160000, "", -1},
    ["ingot"] = {"Ingot",38000, "", -1},
    ["intruder"] = {"Intruder",50000, "", -1},
    ["premier"] = {"Premier",24000, "", -1},
    ["primo"] = {"Primo",25000, "", -1},
    ["primo2"] = {"Primo Custom",45000, "", -1},
    ["regina"] = {"Regina",65000, "", -1},
    ["schafter2"] = {"Schafter",65000, "", -1},
    ["stanier"] = {"Stanier",35000, "", -1},
    ["stratum"] = {"Stratum",56000, "", -1},
    ["stretch"] = {"Stretch",650000, "", -1},
    ["superd"] = {"Super Diamond",95000, "", -1},
    ["surge"] = {"Surge",75000, "", -1},
    ["tailgater"] = {"Tailgater",65000, "", -1},
    ["warrener"] = {"Warrener",95000, "", -1},
    ["washington"] = {"Washington",34000, "", -1}
  },
  
  ["Motos"] = {
    _config = {gpay="bank",gtype={"store"},vtype="bike",blipid=226,blipcolor=4},
    ["akuma"] = {"Akuma",65000, "", -1},
    ["avarus"] = {"Avarus",116000, "", -1},
    ["bagger"] = {"Bagger",35000, "", -1},
    ["bati"] = {"Bati 801",70000, "", -1},
    ["bati2"] = {"Bati 801RR",80000, "", -1},
    ["bf400"] = {"BF400",95000, "", -1},
    ["carbonrs"] = {"Carbon RS",85000, "", -1},
    ["chimera"] = {"Chimera",210000, "", -1},
    ["cliffhanger"] = {"Cliffhanger",225000, "", -1},
    ["daemon2"] = {"Daemon",150000, "", -1},
    ["daemon"] = {"Daemon Variant",145000, "", -1},
    ["defiler"] = {"Defiler",90000, "", -1},
    ["diablous"] = {"Diabolus",169000, "", -1},
    ["diablous2"] = {"Diabolus Custom",245000, "", -1},
    ["double"] = {"Double T",47000, "", -1},
    ["enduro"] = {"Enduro",25000, "", -1},
    ["esskey"] = {"Esskey",55000, "", -1},
    ["faggio"] = {"Faggio",15000, "", -1},
    ["faggio2"] = {"Faggio 2nd",17000, "", -1},
    ["faggio3"] = {"Faggio Mod",25000, "", -1},
    ["fcr"] = {"FCR 1000",85000, "", -1},
    ["fcr2"] = {"FCR 1000 Custom",150000, "", -1},
    ["gargoyle"] = {"Gargoyle",120000, "", -1},
    ["hakuchou"] = {"Hakuchou",82000, "", -1},
    ["hakuchou2"] = {"Hakuchou Drag",350000, "", -1},
    ["hexer"] = {"Hexer",160000, "", -1},
    ["innovation"] = {"Innovation",250000, "", -1},
    ["lectro"] = {"Lectro",35000, "", -1},
    ["manchez"] = {"Manchez",30000, "", -1},
    ["nemesis"] = {"Nemesis",18000, "", -1},
    ["nightblade"] = {"Nightblade",345000, "", -1},
    ["pcj"] = {"PCJ-600",28000, "", -1},
    ["ratbike"] = {"Rat Bike",52000, "", -1},
    ["ruffian"] = {"Ruffian",24000, "", -1},
    ["sanchez"] = {"Sanchez",18000, "", -1},
    ["sanchez2"] = {"Sanchez 2nd",20000, "", -1},
    ["sanctus"] = {"Sanctus",1500000, "", -1},
    --["shotaro"] = {"Shotaro",2225000, "", -1},EVENTO
    --["sovereign"] = {"Sovereign",90000, "", -1},evento
    ["thrust"] = {"Thrust",75000, "", -1},
    ["vader"] = {"Vader",32000, "", -1},
    ["vindicator"] = {"Vindicator",345000,"", -1},
    ["vortex"] = {"Vortex",190000,"", -1},
    ["wolfsbane"] = {"Wolfsbane",95000,"", -1}
    --["zombiea"] = {"Zombie Bobber",99000,""},
    --["zombieb"] = {"Zombie Chopper",122000,""}
  }, 

  ["Barco Pesqueiro"] = {
    _config = {gpay="bank",gtype={"rental"},vtype="boat",permissions={"fisher.vehicle"},blipid=266,blipcolor=4},
    ["suntrap"] = {"Barco Pesqueiro",0, "Seu barco favorito!", -1}
  },]]
  
  ["Mecanico"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"mecanico.vehicle"}},
    ["towtruck"] = {"Caminhao Guincho",0, "", -1},
    ["towtruck2"] = {"Guincho",0, "", -1},
	["flatbed"] = {"Caminhão Cegonha",0, "", -1}
  },
  ["Entregador"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"entregador.vehicle"},blipid=226,blipcolor=5},
    ["faggio2"] = {"Honda Entregador",0, "", -1},
	["taco"] = {"Food Truck",0, "", -1},
  },
  ["Taxi"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"taxi.vehicle"},blipid=225,blipcolor=5},
    ["taxi"] = {"Taxi",0, "", -1}
  },
  ["B2K News"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"reporter.vehicle"},blipid=184,blipcolor=57},
    ["globovan"] = {"Furgão de Noticias",0, "", -1}
  },
  ["B2K News Heli"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"reporter.vehicle"}},
    ["b2kheli"] = {"Heli News",0, "", -1}
  },
  
  ["Barcos"] = {
    _config = {gpay="wallet",gtype={"rental"},blipid=410,blipcolor=3,permissions={"vip.barcos"}},
    --["tug"] = {"Tug Boat", 10000, "", -1},
    ["squalo"] = {"Squalo", 10000, "", -1},
    ["marquis"] = {"Marquis", 10000, "", -1},
    ["speeder"] = {"Speeder", 10000, "", -1},
    ["dinghy"] = {"Dinghy", 10000, "", -1},
    ["jetmax"] = {"Jetmax", 10000, "", -1},
    ["tropic"] = {"Tropic", 10000, "", -1},
    ["seashark"] = {"Seashark", 10000, "", -1},
    ["toro"] = {"Toro", 20000, "", -1}
  },
	
  ["Yakuza"] = {
    _config = {gpay="wallet",gtype={"store","personal"},permissions={"yakuza.vehicle"}},
    ["yakuza"] = {"Carro da Máfia Yakuza",50000, "", -1},
    ["cognoscenti2"] = {"Carro do Lider",100000, "", 6},
  },
  ["Siciliana"] = {
    _config = {gpay="wallet",gtype={"personal"},permissions={"siciliana.vehicle"}},
    ["siciliana"] = {"Carro da Máfia Siciliana",50000, "", -1},
    ["cognoscenti2"] = {"Carro do Lider",100000, "", 6},
  },
  ["LostMC"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"lostmc.vehicle"}},
    ["bagger"] = {"Bagger", 0, "", -1},
    ["daemon"] = {"Daemon", 0, "", -1},
    ["sovereign"] = {"Sovereign", 0, "", -1},
    ["innovation"] = {"Innovation", 0, "", -1},
    ["cliffhanger"] = {"Cliffhanger", 0, "", -1},
    ["gargoyle"] = {"Gargoyle", 0, "", -1},

  },
  ["LoveStory"] = {
    _config = {gpay="wallet",gtype={"personal"},permissions={"lovestory.vehicle"}},
  },
  ["Gangues"] = {
    _config = {gpay="wallet",gtype={"store","personal"},permissions={"gangue.vehicle"}},
    ["aztecas"] = {"Carro dos Aztecas",25000, "", -1},
	["ballas"] = {"Carro dos Ballas",25000, "", -1},
	["groove"] = {"Carro dos Groove Street",25000, "", -1},
	["lostmc"] = {"Moto dos TheLost MC",25000, "", -1},
	["cognoscenti2"] = {"Carro do Lider",100000, "", 6}
  },
  ["Admins"] = {
    _config = {gpay="wallet",gtype={"personal"},permissions={"admin.vehicle"}},
    ["guardian"] = {"Ford F-650",0, "", -1},
	["raiden"] = {"Tesla Model S",0, "", -1},
	["revolter"] = {"Cadillac Escala Concept",0, "", -1},
	["caracara"] = {"Caracara",0, "", -1},
	["cheburek"] = {"Cheburek",0, "", -1},
	["ellie"] = {"Ellie",0, "", -1},
	["fagaloa"] = {"Fagaloa",0, "", -1},
	["flashgt"] = {"FlashGT",0, "", -1},
	["gb200"] = {"GB200",0, "", -1},
	["hotring"] = {"Hotring",0, "", -1},
	["issi3"] = {"Issi3",0, "", -1},
	["michelli"] = {"Michelli",0, "", -1},
	["tezeract"] = {"Tezaract",0, "", -1},
	["tyrant"] = {"Tyrant",0, "", -1},
	["stretch"] = {"Limosine",0, "", -1},

	["r8v10"] = {"Cabritoz",0, "", -1},
	["i8"] = {"i8",0, "", -1},
	["marconha"] = {"Marconha",0, "", -1},
	["teslax"] = {"Rabico",0, "", -1},
	["f1"] = {"Skip",0, "", -1},
	["hondacivictr"] = {"Honda Civic Type R",0, "", -1},

	["sanctus"] = {"Poderoso",0, "", -1},
	["gburrito"] = {"Van Lost MC", 0, "", -1},

	["hakuchou2"] = {"Hakuchou 2", 0, "", -1},
	["specter2"] = {"Specter 2", 0, "", -1},
	--["bdivo"] = {"Bugatti Divo 2019", 0, "", -1},
	["coquette"] = {"Corvette Stingray", 0, "", -1},
	["c7r"] = {"Corvette Stingray Limited Edition", 0, "", -1},
	["neon"] = {"Porsche Taycan", 0, "", -1},
	["rmodveneno"] = {"Lamborghini Veneno", 0, "", -1},
	["nero2"] = {"Nero Custom", 0, "", -1},
	["f150"] = {"F150", 0, "", -1},
	["senna"] = {"Senna", 0, "", -1},
	["gtr"] = {"Nissan GTR", 0, "", -1},
  },
  ["Carros Streamers"] = {
    _config = {gpay="wallet",gtype={"rental"},permissions={"vip.streamerscars"},blipid=357,blipcolor=46},
    ["guardian"] = {"Carro Lafa - Ford F-650",0, "", -1},
	["raiden"] = {"Carro Poderoso - Tesla Model S",0, "", -1},
	["ellie"] = {"Carro do VovoFps - Ellie",0, "", -1},
	["r8v10"] = {"Carro do Cabritoz - Audi R8",0, "", -1},
	["i8"] = {"Carro do JonVlogs - BMW i8",0, "", -1},
	["f1"] = {"Carro do LIL Frogg",0, "", -1},
	["hondacivictr"] = {"Carro do SkipSenna - Honda Civic Type R",0, "", -1},
	["gtr"] = {"Carro do Cabritoz - Nissan GTR", 0, "", -1},
	["revolter"] = {"Carro do Prefeito - Cadillac Escala Concept",0, "", -1},
	["hakuchou2"] = {"Hakuchou 2", 0, "", -1},
	["specter2"] = {"Specter 2", 0, "", -1},
  },
  ["Heli"] = {
    _config = {gpay="wallet",gtype={"store","personal"},permissions={"vip.heli"},blipid=43,blipcolor=3},
    ["volatus"] = {"Volatus", 0, "", 1},
	["supervolito"] = {"Super Volito", 0, "", 1}
  },


}

-- {garage_type,x,y,z}
cfg.garages = {
  -- default garages
  --[[{"Compactos",-354.988891601563,-115.710586547852,38.6966323852539},
  {"Coupe",698.135375976563,-1130.54235839844,24.348726272583},
  {"SUVs",-1117.03161621094,-2012.15710449219,14.1818408966064},
  {"Carros Super",2132.22802734375,4780.6083984375,41.9702758789063},
  {"Motos",74.1576232910156,3643.208984375,40.5487213134766},
  {"Motos",981.791748046875,-113.413665771484,75.0816955566406},
  {"Vans",1224.89562988281,2722.58666992188,39.0041313171387},
  {"Sedans",233.66178894043,-789.788513183594,30.5983638763428},
  {"Esportivos",-2294.12915039063,372.463104248047,174.601791381836},
  {"Carros Muscle",-2186.0439453125,-410.179321289063,13.095627784729},
  {"Off-Road",-81.005973815918,6494.27587890625,31.490894317627},
  {"Classicos Esportivos",-205.789, -1308.02, 31.2916},]]
  --{"Taxi",907.12554931641,-175.74459838867,74.11962890625}, -- jobs garage
  {"Entregador",126.9338760376,-1474.3255615234,29.141597747803}, -- jobs garage 
  {"Mecanico",-208.77543640137,-1392.7048339844,31.248970031738}, -- jobs garage 
  {"Bicicletas",-1221.6668701172,-1498.92578125,4.3533811569214},
  {"BicicletasPrisao",1674.4901123047,2518.0380859375,45.564895629883},
  {"Taxi",905.99749755859,-185.86431884766,73.99976348877},
  
  {"B2K News", -616.16241455078,-920.45422363281,23.421892166138},
  {"B2K News Heli", -583.36456298828,-930.54565429688,36.833576202393},
  
  -- Garagens Pessoais
  {"Garagem Pessoal", 215.124 ,-791.377,30.646},
  {"Garagem Pessoal", -334.685,289.773,85.705},
  {"Garagem Pessoal", 126.434,6610.040,31.750},
  {"Garagem Pessoal", -56.305,-1116.774,26.434},
  {"Garagem Pessoal", -783.891,-190.193,37.283},
  {"Garagem Pessoal", 905.212,-33.414,78.353}, -- ao lado motoclub
  {"Garagem Pessoal", 420.521,-1639.059,29.291}, -- CET

  
  -- Principais 
  {"Policia", 451.60464477539,-1020.9896850586,28.370601654053},
  {"Policia Heli", 449.12008666992,-981.23260498047,43.691646575928},
  --{"Federal", 419.97576904297,-1068.5307617188,29.213247299194},
  --{"Federal Heli", 475.12741088867,-1104.9821777344,45.09969329834},
  
  {"Samu", 287.07693481445,-611.10772705078,43.365867614746},
  {"Samu Heli", 351.86273193359,-588.46722412109,74.165664672852},
  --{"Bombeiros", -371.34973144532,6125.513671875,31.440160751342}, -- Interior
  --{"Bombeiros Heli",1200.544921875,-1497.4106445313,34.692543029785}, 
  --{"Bombeiros Heli",-375.27688598632,6136.0004882812,31.38268661499}, -- Interior
  --{"Guarda Costeira",-1268.4659423828,-1832.080078125,1.0893447399139},
  
  -- Showroom
  {"Motos",-50.047779083252, -1095.0140380859,26.422353744507},
  {"Concessionaria",-42.501167297363, -1097.8708496094,26.422367095947},
  -- 
  {"Luxury Classics", -814.58111572266,-193.9592590332,37.59001159668},
  {"Luxury Autos", -808.67474365234,-191.06307983398,42.669406890869},
  {"Luxury Supers", -814.10375976563,-193.95024108887,42.669387817383},

  -- Mafias
  {"Yakuza", -960.0551147461, -1492.9155273438, 5.0088691711426},
  {"Siciliana", -2642.2336425782, 1307.234375, 145.75036621094},
  {"LoveStory", 1413.2116699218, 1118.2453613282, 114.83791351318},
  --{"LostMC", 974.43505859375,-139.01496887207,74.238265991211},
  
  --{"Carros Streamers",-809.38055419922,-227.91435241699,37.126129150391},
  {"Barcos",-794.43011474609,-1486.0489501953,0.7056310415268},
  {"Barcos",-1603.5191650391,5258.546875,0.7056310415268},
  {"Barcos",3369.8908691406,5186.2607421875,0.7056310415268},

  --{"Heli",-724.70104980469,-1444.1351318359,5.0005226135254},

  --{"Gangues", -47.600589752197,-1116.5639648438,26.434041976929},
  
  --{"OAB", 157.84490966797,-1125.1856689453,29.200927734375}
}

return cfg