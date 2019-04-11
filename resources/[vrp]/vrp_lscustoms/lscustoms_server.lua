-- vRP TUNNEL/PROXY
MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP")

--[[
Los Santos Customs V1.1 
Credits - MythicalBro
/////License/////
Do not reupload/re release any part of this script without my permission
]]
local tbl = {
	[1] = { locked = false, player = nil},
	[2] = { locked = false, player = nil},
	[3] = { locked = false, player = nil},
	[4] = { locked = false, player = nil},
	[5] = { locked = false, player = nil},
	[6] = { locked = false, player = nil},
}
local carModelList = {
	[1] = { modelHash = 1039032026 , modelName = "blista2"},
	[2] = { modelHash = -344943009, modelName = "blista"},
	[3] = { modelHash = 80636076, modelName = "dominator"},
	[4] = { modelHash = -1800170043, modelName = "gauntlet"},
	[5] = { modelHash = 1221512915, modelName = "seminole"},
	[6] = { modelHash = 850565707, modelName = "bjxl"},
	[7] = { modelHash = -808831384, modelName = "baller"},
	[8] = { modelHash = -1842748181, modelName = "faggio"},
	[9] = { modelHash = -1543762099, modelName = "gresley"},
	[10] = { modelHash = -1372848492, modelName = "kuruma"},
	[11] = { modelHash = 970598228, modelName = "sultan"},
	[12] = { modelHash = 1032823388, modelName = "ninef"},
	[13] = { modelHash = -1461482751, modelName = "ninef2"},
	[14] = { modelHash = -304802106, modelName = "buffalo"},
	[15] = { modelHash = 723973206, modelName = "dukes"},
	[16] = { modelHash = -377465520, modelName = "penumbra"},
	-- Motos
	[17] = { modelHash = -909201658, modelName = "pcj"},
	[18] = { modelHash = -634879114, modelName = "nemesis"},
	[19] = { modelHash = -2140431165, modelName = "bagger"},
	[20] = { modelHash = -1009268949, modelName = "zombiea"},
	[21] = { modelHash = -570033273, modelName = "zombieb"},
	[22] = { modelHash = -893578776, modelName = "ruffian"},
	[23] = { modelHash = -1670998136, modelName = "double"},
	[24] = { modelHash = -757735410, modelName = "fcr2"},
	[25] = { modelHash = 1790834270, modelName = "diablous2"},
	[26] = { modelHash = -1606187161, modelName = "nightblade"},
	[27] = { modelHash = -114291515, modelName = "bati"},
	[28] = { modelHash = 788045382, modelName = "sanchez"},
	[29] = { modelHash = 6774487, modelName = "chimera"},
	[30] = { modelHash = 1265391242, modelName = "hakuchou"},
	
	[31] = { modelHash = 901237823, modelName = "fulux63"},
	[32] = { modelHash = -252643265, modelName = "ftoro"},
	[33] = { modelHash = 192820287, modelName = "vwstance"},
	[34] = { modelHash = 1876694905, modelName = "veloster"},
	
	[35] = { modelHash = -808457413, modelName = "patriot"},
	[36] = { modelHash = 142944341, modelName = "baller2"},
	[37] = { modelHash = -1651067813, modelName = "radi"},
	[38] = { modelHash = 2136773105, modelName = "rocoto"},
	[39] = { modelHash = -591610296, modelName = "f620"},
	[40] = { modelHash = -511601230, modelName = "oracle2"},
	[41] = { modelHash = -1930048799, modelName = "windsor2"},
	[42] = { modelHash = -1255452397, modelName = "schafter2"},
	[43] = { modelHash = 1909141499, modelName = "fugitive"},
	[44] = { modelHash = -566387422, modelName = "elegy2"},
	[45] = { modelHash = 661493923, modelName = "comet5"},
	[46] = { modelHash = 2072687711, modelName = "carbonizzare"},
	[47] = { modelHash = 633712403, modelName = "banshee2"},
	[48] = { modelHash = 384071873, modelName = "surano"},
	[49] = { modelHash = 2006667053, modelName = "voodoo"},
	[50] = { modelHash = 15219735, modelName = "hermes"},
	[51] = { modelHash = 223258115, modelName = "sabregt2"},
	[52] = { modelHash = -1479664699, modelName = "brawler"},
	[53] = { modelHash = -1532697517, modelName = "riata"},
	[54] = { modelHash = -121446169, modelName = "kamacho"},
	[55] = { modelHash = -2045594037, modelName = "rebel2"},
	[56] = { modelHash = 1896491931, modelName = "moonbeam2"},
	[57] = { modelHash = -1013450936, modelName = "buccaneer2"},
	[58] = { modelHash = -2040426790, modelName = "primo2"},

	[59] = { modelHash = -2107990196, modelName = "guardian"},
	[60] = { modelHash = -1529242755, modelName = "raiden"},
	[61] = { modelHash = -410205223, modelName = "revolter"},
	
	--
	[62] = { modelHash = 1254014755, modelName = "caracara"},
	[63] = { modelHash = -988501280, modelName = "cheburek"},
	[64] = { modelHash = -986944621, modelName = "dominator3"},
	[65] = { modelHash = -1267543371, modelName = "ellie"},
	[66] = { modelHash = -2120700196, modelName = "entity2"},
	[67] = { modelHash = 1617472902, modelName = "fagaloa"},
	[68] = { modelHash = -1259134696, modelName = "flashgt"},
	[69] = { modelHash = 1909189272, modelName = "gb200"},
	[70] = { modelHash = 1115909093, modelName = "hotring"},
	[71] = { modelHash = 931280609, modelName = "issi3"},
	[72] = { modelHash = -214906006, modelName = "jester3"},
	[73] = { modelHash = 1046206681, modelName = "michelli"},
	[74] = { modelHash = -1134706562, modelName = "taipan"},
	[75] = { modelHash = 1031562256, modelName = "tezeract"},
	[76] = { modelHash = -376434238, modelName = "tyrant"},
	
	[77] = { modelHash = -1530690737, modelName = "camaro2012"},

	[78] = { modelHash = -1961627517, modelName = "stretch"},

	[79] = { modelHash = 1478526932, modelName = "marconha"},
	[80] = { modelHash = -328440374, modelName = "f1"},
	[81] = { modelHash = -429774847, modelName = "teslax"},
	[82] = { modelHash = -1183566390, modelName = "r8v10"},
	[83] = { modelHash = 1718441594, modelName = "i8"},
 	[84] = { modelHash = -1978168465, modelName = "hondacivictr"},

	[85] = { modelHash = -1745203402, modelName = "gburrito"},
	[86] = { modelHash = 1491277511, modelName = "sanctus"},

	[87] = { modelHash = -255678177, modelName = "hakuchou2"},
	[88] = { modelHash = 1074745671, modelName = "specter2"},
	

	[89] = { modelHash = 159274291, modelName = "ardent"},
	[90] = { modelHash = -391595372, modelName = "viseris"},
	[91] = { modelHash = 758895617, modelName = "ztype"},
	[92] = { modelHash = 2049897956, modelName = "rapidgt3"},
	[93] = { modelHash = 838982985, modelName = "z190"},
	[94] = { modelHash = -982130927, modelName = "turismo2"},
	[95] = { modelHash = 223240013, modelName = "cheetah2"},
	[96] = { modelHash = 903794909, modelName = "savestra"},
	[97] = { modelHash = -1405937764, modelName = "infernus2"},
	[98] = { modelHash = 1011753235, modelName = "coquette2"},
	[99] = { modelHash = 1504306544, modelName = "torero"},
	[100] = { modelHash = 1051415893, modelName = "jb700"},
	[101] = { modelHash = -2079788230, modelName = "gt500"},
	[102] = { modelHash = 1830407356, modelName = "peyote"},
	[103] = { modelHash = 117401876, modelName = "btype"},
	[104] = { modelHash = -602287871, modelName = "btype3"},
	[105] = { modelHash = -831834716, modelName = "btype2"},
	[106] = { modelHash = 941800958, modelName = "casco"},
	[107] = { modelHash = -1660945322, modelName = "mamba"},
	[108] = { modelHash = -1566741232, modelName = "feltzer3"},
	[109] = { modelHash = 1841130506, modelName = "retinue"},
	[110] = { modelHash = -433375717, modelName = "monroe"},
	[111] = { modelHash = 1078682497, modelName = "pigalle"},
	[112] = { modelHash = 1545842587, modelName = "stinger"},
	[113] = { modelHash = -2098947590, modelName = "stingergt"},
	[114] = { modelHash = -1696146015, modelName = "bullet"},

	[115] = { modelHash = -1311154784, modelName = "cheetah"},
	[116] = { modelHash = 418536135, modelName = "infernus"},
	[117] = { modelHash = 272929391, modelName = "tempesta"},
	[118] = { modelHash = 408192225, modelName = "turismor"},
	[119] = { modelHash = 338562499, modelName = "vacca"},
	[120] = { modelHash = -142942670, modelName = "massacro"},
	[121] = { modelHash = -1934452204, modelName = "rapidgt"},
	[122] = { modelHash = 1737773231, modelName = "rapidgt2"},
	[123] = { modelHash = 1274868363, modelName = "bestiagts"},
	[124] = { modelHash = -1995326987, modelName = "feltzer2"},
	[125] = { modelHash = 1102544804, modelName = "verlierer2"},
	[126] = { modelHash = -1757836725, modelName = "seven70"},
	[127] = { modelHash = -1297672541, modelName = "jester"},
	[128] = { modelHash = 544021352, modelName = "khamelion"},
	[129] = { modelHash = -1089039904, modelName = "furoregt"},
	[130] = { modelHash = 482197771, modelName = "lynx"},
	[131] = { modelHash = -1622444098, modelName = "voltic"},
	[132] = { modelHash = 1886268224, modelName = "specter"},
	[133] = { modelHash = 917809321, modelName = "xa21"},
	[134] = { modelHash = 1987142870, modelName = "osiris"},
	[135] = { modelHash = -1758137366, modelName = "penetrator"},
	[136] = { modelHash = 1352136073, modelName = "sc1"},
	[137] = { modelHash = -1331336397, modelName = "bdivo"},

	[138] = { modelHash = 108773431, modelName = "coquette"},
	[139] = { modelHash = -1848994066, modelName = "neon"},
	[140] = { modelHash = -661719484, modelName = "c7r"},
	[141] = { modelHash = 62986539, modelName = "rmodveneno"},
	[142] = { modelHash = 1093792632, modelName = "nero2"},

	[143] = { modelHash = -2124201592, modelName = "manana"},
	[144] = { modelHash = 1507916787, modelName = "picador"},
	[145] = { modelHash = 699456151, modelName = "surfer"},

	[146] = { modelHash = -433961724, modelName = "senna"},
	[147] = { modelHash = -1304790695, modelName = "f150"}

	
	
	




	-- Novos carros
	--[[11] = {modelHash = -1361741677, modelName = "ballas"},
	[12] = {modelHash = 1197363446, modelName = "aztecas"},
	[13] = {modelHash = 661206304, modelName = "groove"},
	[14] = {modelHash = -1062104596, modelName = "lostmc"},
	[15] = {modelHash = 1439335383, modelName = "yakuza"},
	[16] = {modelHash = -401053916, modelName = "siciliana"},]]
	
	--[17] = {modelHash = -2107990196, modelName = "guardian"}, -- carro do lafa

	--[6] = {modelHash = , modelName = ""},
	
	--[18] = {modelHash = 901237823, modelName = "fulux63"}, -- fusca

}
-- verificar -1625373020

RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b,garage)
	tbl[tonumber(garage)].locked = b
	if not b then
		tbl[tonumber(garage)].player = nil
	else
		tbl[tonumber(garage)].player = source
	end
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
	TriggerClientEvent('lockGarage',-1,tbl)
	--print(json.encode(tbl))
end)
AddEventHandler('playerDropped', function()
	for i,g in pairs(tbl) do
		if g.player then
			if source == g.player then
				g.locked = false
				g.player = nil
				TriggerClientEvent('lockGarage',-1,tbl)
			end
		end
	end
end)

RegisterServerEvent("LSC:buttonSelected")
AddEventHandler("LSC:buttonSelected", function(name, button)
	--local mymoney = 999999 --Just so you can buy everything while there is no money system implemented
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		if button.price then -- check if button have price
			if vRP.tryFullPayment({user_id,button.price}) then
				TriggerClientEvent("LSC:buttonSelected", player, name, button, true)
				--mymoney = mymoney - button.price
			else
				TriggerClientEvent("LSC:buttonSelected", player, name, button, false)
			end
		else
			TriggerClientEvent("LSC:buttonSelected", player, name, button, false)
		end
	end
end)

RegisterServerEvent("LSC:finished")
AddEventHandler("LSC:finished", function(veh)
	local player = source
	local user_id = vRP.getUserId({player})
	if user_id ~= nil then
		
		local model = veh.model --Display name from vehicle model(comet2, entityxf)
		local modelName = nil
		for i,g in pairs(carModelList) do
			if g.modelHash == model then
				modelName = g.modelName
			end
		end
		
		print("LS Custom Save ModelHash: " .. tostring(model) .. " Name: " .. tostring(modelName) .. " User ID:" .. tostring(user_id))
		local mods = veh.mods
		local custom = {}
		--[[
		mods[0].mod - spoiler
		mods[1].mod - front bumper
		mods[2].mod - rearbumper
		mods[3].mod - skirts
		mods[4].mod - exhaust
		mods[5].mod - roll cage
		mods[6].mod - grille
		mods[7].mod - hood
		mods[8].mod - fenders
		mods[10].mod - roof
		mods[11].mod - engine
		mods[12].mod - brakes
		mods[13].mod - transmission
		mods[14].mod - horn
		mods[15].mod - suspension
		mods[16].mod - armor
		mods[23].mod - tires
		mods[23].variation - custom tires
		mods[24].mod - tires(Just for bikes, 23:front wheel 24:back wheel)
		mods[24].variation - custom tires(Just for bikes, 23:front wheel 24:back wheel)
		mods[25].mod - plate holder
		mods[26].mod - vanity plates
		mods[27].mod - trim design
		mods[28].mod - ornaments
		mods[29].mod - dashboard
		mods[30].mod - dial design
		mods[31].mod - doors
		mods[32].mod - seats
		mods[33].mod - steering wheels
		mods[34].mod - shift leavers
		mods[35].mod - plaques
		mods[36].mod - speakers
		mods[37].mod - trunk
		mods[38].mod - hydraulics
		mods[39].mod - engine block
		mods[40].mod - cam cover
		mods[41].mod - strut brace
		mods[42].mod - arch cover
		mods[43].mod - aerials
		mods[44].mod - roof scoops
		mods[45].mod - tank
		mods[46].mod - doors
		mods[48].mod - liveries
		
		--Toggle mods
		mods[20].mod - tyre smoke
		mods[22].mod - headlights
		mods[18].mod - turbo
		
		--]]
		
		custom.spoiler = mods[0].mod
		custom.fbumper = mods[1].mod
		custom.rbumper = mods[2].mod
		custom.skirts = mods[3].mod
		custom.exhaust = mods[4].mod
		custom.rollcage = mods[5].mod
		custom.grille = mods[6].mod
		custom.hood = mods[7].mod 
		custom.fenders = mods[8].mod
		custom.roof = mods[10].mod
		custom.engine = mods[11].mod
		custom.brakes = mods[12].mod
		custom.transmission = mods[13].mod
		custom.horn = mods[14].mod
		custom.suspension = mods[15].mod
		custom.armor = mods[16].mod
		custom.tires = mods[23].mod
		custom.tiresvariation = mods[23].variation
		
		custom.btires = mods[24].mod
		custom.btiresvariation = mods[24].variation
		
		custom.plateholder = mods[25].mod
		custom.vanityplates = mods[26].mod
		custom.trimdesign = mods[27].mod 
		custom.ornaments = mods[28].mod
		custom.dashboard = mods[29].mod
		custom.dialdesign = mods[30].mod
		custom.doors = mods[31].mod
		custom.seats = mods[32].mod
		custom.steeringwheels = mods[33].mod
		custom.shiftleavers = mods[34].mod
		custom.plaques = mods[35].mod
		custom.speakers = mods[36].mod
		custom.trunk = mods[37].mod 
		custom.hydraulics = mods[38].mod
		custom.engineblock = mods[39].mod
		custom.camcover = mods[40].mod
		custom.strutbrace = mods[41].mod
		custom.archcover = mods[42].mod
		custom.aerials = mods[43].mod
		custom.roofscoops = mods[44].mod
		custom.tank = mods[45].mod
		custom.doors = mods[46].mod
		custom.liveries = mods[48].mod
		
		custom.tyresmoke = mods[20].mod
		custom.headlights = mods[22].mod
		custom.turbo = mods[18].mod
		
		--custom.lscustom = mods
		--[[custom.mods = {}
		for i=0,48 do
			custom.mods[i] = mods[i].mod
		end
		if mods[23].variation then
			custom.variationa = 1
		else
			custom.variationa = 0
		end
		if mods[24].variation then
			custom.variationb = 1
		else
			custom.variationb = 0
		end]]
		custom.color = veh.color
		custom.extracolor = veh.extracolor
		custom.neon = veh.neon
		custom.neoncolor = veh.neoncolor
		custom.smokecolor = veh.smokecolor
		custom.plateindex = veh.plateindex
		custom.windowtint = veh.windowtint
		custom.wheeltype = veh.wheeltype
		custom.bulletProofTyres = veh.bulletProofTyres
		--Do w/e u need with all this stuff when vehicle drives out of lsc
		
		if modelName then
			MySQL.query("vRP/get_vehicle", {user_id = user_id, vehicle = modelName}, function(rows, affected)
				if #rows > 0 then -- has vehicle
					vRP.setUData({user_id,"custom:u"..user_id.."veh_"..modelName, json.encode(custom)})
				end
			end)
		end
	end
end)
