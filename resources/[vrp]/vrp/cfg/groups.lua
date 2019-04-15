
local cfg = {}

function police_onjoin(player)
  vRPclient.setCop(player,{true})
  vRPclient.notify(player,{"Você é um Policial."})
end

function police_onleave(player)
  vRPclient.setCop(player,{false})
end

function police_onspawn(player, message)
  vRPclient.setCop(player,{true})
end

function player_onspawn(player, message)
  vRPclient.notify(player,{message})
end

-- define each group with a set of permissions
-- _config property:
--- gtype (optional): used to have only one group with the same gtype per player (example: a job gtype to only have one job)
--- onspawn (optional): function(player) (called when the player spawn with the group)
--- onjoin (optional): function(player) (called when the player join the group)
--- onleave (optional): function(player) (called when the player leave the group)
--- (you have direct access to vRP and vRPclient, the tunnel to client, in the config callbacks)

cfg.groups = {
  ["superadmin"] = {
    _config = { onspawn = function(player) vRPclient.notify(player,{"You are Superadmin."}) end },
    "player.group.add",
    "player.group.remove",
    "player.givemoney",
    "player.giveitem",
	"admin.crun",
	"admin.srun",
	"player.custom_emote",
    "player.custom_sound",
	"admin.spawnveh",
	"player.setmodel",
	"player.spec",
	"admin.carupgrade",
	"admin.fixclean",
	"admin.hexsteam",
	"player.unban",
	"player.list",
	"vip.unlimitedcars"
  },
  ["admin"] = {
  	"admin.revive",
    "admin.tickets",
    "admin.announce",
	"admin.menu",
	"admin.easy_unjail",
	--"admin.spikes",
	"admin.godmode",
	"admin.deleteveh",
	"player.blips",
	"admin.tptowaypoint",
    "player.whitelist",
    "player.unwhitelist",
    "player.kick",
    "player.ban",
    "player.noclip",
    "player.display_custom",
	"player.display_overlays",
    "player.coords",
    "player.tptome",
	--"emergency.revive",
	--"emergency.shop",
    "player.tpto",
	"anticheese.bypass"
  },
  -- the group user is auto added to all logged players
  ["moderador"] = {
    "admin.menu",
	"admin.tickets",
    "admin.announce",
	"admin.deleteveh",
	"player.tpto",
    "player.tptome",
	"admin.tptowaypoint",
    "player.kick",
    "player.ban",
    "player.whitelist",
    "player.unwhitelist",
	"player.blips",
	"player.noclip",
  },
  ["moderador2"] = {
    "admin.menu",
    "admin.announce",
	"admin.deleteveh",
    "player.kick",
  },
  ["cleaners"] = {
    "admin.menu",
	"admin.deleteveh",
  },

  ["vip25"] = {
   "vip.identity",
   "vip.hospital",
   "vip.delayjob",
   "vip.10carros",
  },  
  ["vip50"] = {
   "vip.identity",
   "vip.hospital",
   "vip.delayjob",
   "vip.20carros",
   "vip.barcos",
  },
  ["vip100"] = {
   "vip.identity",
   "vip.hospital",
   "vip.delayjob",
   "vip.30carros",
   "vip.barcos",
   "vip.streamerscars",
   "vip.heli",
  },

  -- the group user is auto added to all logged players
  ["user"] = {
    "player.phone",
    "player.calladmin",
	"player.fix_haircut",
	"player.check",
	--"mugger.mug",
    "police.askid",
	"player.store_weapons",
    --"police.store_weapons", bug
	--"player.skip_coma",-- vrp_hotkeys
	"player.store_money",
	"player.store_armor",
	"player.loot",
	"player.player_menu",
    "police.seizable",	-- can be seized
	"user.paycheck",
	"player.cmd_mask",
	"player.userlist",
	"player.comportamento"
	--"toggle.service"
  },
  
  -- ################# POLICIA FEDERAL #################
  ["Policial Federal"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },

	"-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission

	-- Base
	"police.base",
	"police.oficial",
	"police.menu_interaction", -- vrp_barrier
	
	-- Salario
	"paycheck.policial.federal",

	
	-- Especificos
	"bank.police",
	"lojinha.police",
	"federal.cloakroom",
	"federal.weapons",
	"federal.armas",
	"federal.vehicle",
    
	
	-- ALL
	"police.base",
	"portas.policia",
  },
  -- ################# POLICIA MILITAR #################
  -- Recruta, Soldado, Cabo, 3ºSGT, 2ºSGT, 1ºSGT, SubTenente, 2ºTenente, 1ºTenente, Capitao, Major, Tenente-Coronel, Coronel [PM]
  -- Soldado, Cabo, 3ºSGT, 2ºSGT, 1ºSGT, SubTenente, 2ºTenente, 1ºTenente, Capitao, Major, Tenente-Coronel, Coronel [FT]
  -- Soldado, Cabo, 3ºSGT, 2ºSGT, 1ºSGT, SubTenente, 2ºTenente, 1ºTenente, Capitao, Major, Tenente-Coronel, Coronel [RT]
  
  --pm.cloakroom, rota.cloakroom, rocam.cloakroom, ft.cloakroom
  ["Coronel [RT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
	"police.base",
	"police.oficial", -- somente patente superior?
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar

	-- Salario
	"paycheck.policial.rt",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"rota.armas",
	"portas.policia",
  },
  ["Tenente-Coronel [RT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
	"police.base",
	"police.oficial", -- somente patente superior?
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar

	-- Salario
	"paycheck.policial.rt",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"rota.armas",
	"portas.policia",
  },
  ["Major [RT]"] = {
     _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
	"police.base",
	"police.oficial", -- somente patente superior?
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar

	-- Salario
	"paycheck.policial.rt",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"rota.armas",
	"portas.policia",
  },
  ["Capitao [RT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
	"police.base",
	"police.oficial", -- somente patente superior?
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar

	-- Salario
	"paycheck.policial.rt",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"rota.armas",
	"portas.policia",
  },
  ["Soldado [RT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
	"police.base",
	"police.oficial", -- somente patente superior?
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar

	-- Salario
	"paycheck.policial.rt",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"rota.armas",
	"portas.policia",
  },
  -- 3ºSGT, 2ºSGT, 1ºSGT, SubTenente, 2ºTenente, 1ºTenente [FT]
  ["1ºTenente [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  ["2ºTenente [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  ["SubTenente [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  -- Sargentos
  ["1ºSGT [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  ["2ºSGT [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  ["Soldado [FT]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"police.menu_interaction", -- vrp_barrier
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.ft",

	-- Especificos
	"bank.police",
	"lojinha.police",
	"ft.armas"
  },
  ["3ºSGT [PM]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.pm",
	
	-- Especificos
	"bank.police",
	"lojinha.police",
	"pm.armas"
  },
  
  -- Recruta, Soldado, Cabo [PM]
  ["Cabo [PM]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.pm",
	
	-- Especificos
	"bank.police",
	"lojinha.police",
	"pm.armas"
  },
  ["Soldado [PM]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.pm",
	
	-- Especificos
	"bank.police",
	"lojinha.police",
	"pm.armas"
  },
  ["Recruta [PM]"] = {
    _config = { gtype = "job", onjoin = police_onjoin, onspawn = police_onspawn, onleave = police_onleave },
	-- Base
    "police.oficial",
    "police.base",
    "-police.seizable",	-- negative permission, police can't seize itself, even if another group add the permission
	"mission.police.transfer", -- basic mission - a testar
	"mission.police.patrol", -- basic mission - a testar
	
	-- Salario
	"paycheck.policial.pm",
	
	-- Especificos
	--"bank.police",
	"lojinha.police",
	"pm.armas"
  },
  -- ################# Samu #################
  -- Paramedico, Enfermeiro, Medico, Diretor
	
  -- ################# Corpo de Bombeiros #################
  -- Soldado, Sargento, Tenente, Major, Coronel - Militar
  -- Ambulancias e Moto: Soldado, Sargento
  -- Hilux: Tenente
  -- Heli: Major, Coronel
  
  ["Diretor [SAMU]"] = {
    _config = { gtype = "job", onjoin = function(player) vRPclient.notify(player,{"Você é um Diretor [SAMU]."}) end },

	-- Base
    "emergency.revive",
    "emergency.shop",
    "emergency.service",
    "emergency.market",
	"emergency.mission", -- a testar
	
	-- Salario
	"paycheck.samu.superiores",
	
	-- Especificos
	"mission.emergency.transfer",
    "samu.cloakroom",
    "samu.vehicle",

	-- Menu
	"samu.menu",
	"samu.uti",
	"samu.treatment",
	"samu.drag",
    "samu.putinveh",
    "samu.getoutveh",
    "samu.bandagem"

  },
  ["Medico [SAMU]"] = {
    _config = { gtype = "job", onjoin = function(player) vRPclient.notify(player,{"Você é um Medico [SAMU]."}) end },

	-- Base
    "emergency.revive",
    "emergency.shop",
    "emergency.service",
    "emergency.market",
	"emergency.mission", -- a testar
	
	-- Salario
	"paycheck.samu.superiores",
	
	-- Especificos
	"mission.emergency.transfer",
    "samu.cloakroom",
    "samu.vehicle",

    -- Menu
	"samu.menu",
	"samu.uti",
	"samu.treatment",
	"samu.drag",
    "samu.putinveh",
    "samu.getoutveh",
    "samu.bandagem"

  },
  ["Enfermeiro [SAMU]"] = {
    _config = { gtype = "job", onjoin = function(player) vRPclient.notify(player,{"Você é um Enfermeiro [SAMU]."}) end },

	-- Base
    "emergency.revive",
    "emergency.shop",
    "emergency.service",
    "emergency.market",
	"emergency.mission", -- a testar
	
	-- Salario
	"paycheck.samu.graduados",
	
	-- Especificos
	"mission.emergency.transfer",
    "samu.cloakroom",
    "samu.vehicle",

    -- Menu
	"samu.menu",
	"samu.uti",
	"samu.treatment",
	"samu.drag",
    "samu.putinveh",
    "samu.getoutveh",
    "samu.bandagem"
  },
  ["Paramedico [SAMU]"] = {
    _config = { gtype = "job", onjoin = function(player) vRPclient.notify(player,{"Você é um Paramedico [SAMU]."}) end },

	-- Base
    "emergency.revive",
    "emergency.shop",
    "emergency.service",
    "emergency.market",
	"emergency.mission", -- a testar
	
	-- Salario
	"paycheck.samu.praca",
	
	-- Especificos
	"mission.emergency.transfer",
    "samu.cloakroom",
    "samu.vehicle",

    -- Menu
	"samu.menu",
	"samu.uti",
	"samu.treatment",
	"samu.drag",
    "samu.putinveh",
    "samu.getoutveh",
    "samu.bandagem"
  },

  -- ################# Trabalhos Ilegais #################
  -- Para Gangsters
  ["Aviaozinho da Maconha"] = {
    _config = { gtype = "job" },
	"vender.maconha",
	"mission.drugseller.weed",
    "drugseller.market",
	--"lab.weed",
    --"harvest.weed"
  },
  ["Traficante de Maconha"] = {
    _config = { gtype = "job" },
	"-vender.maconha",
	"-mission.drugseller.weed",
    "-drugseller.market",
	"lab.weed",
    "harvest.weed"
  },
  ["Vapor de Cocaina"] = {
    _config = { gtype = "job" },
	"vender.cocaina",
	"mission.drugseller.cocaine",
    "drugseller.market",
  },
  ["Traficante de Cocaina"] = {
    _config = { gtype = "job" },
	"-vender.cocaina",
	"-mission.drugseller.cocaine",
    "-drugseller.market",
	"lab.cocaine",
    "harvest.cocaine"
  },
  ["Traficante de Metanfetamina"] = {
    _config = { gtype = "job" },
    "vender.meta",
	"mission.drugseller.metanfetamine",
    "drugseller.market",
	"lab.anfetamina",
    "harvest.anfetamina"
  },
  ["Traficante de Armas"] = {
    _config = { gtype = "job" },
    "harvest.armas",
	"mission.gunrunner.shipment"
  },
  
  -- Para civis
  ["Hacker"] = {
    _config = { gtype = "job" },
    "hacker.hack",
	"hacker.credit_cards",
	"mission.hacker.information"
  },
  ["Traficante de Tartaruga"] = {
    _config = { gtype = "job" },
    "harvest.tart",
	"vender.tart"
  },
  
  -- "vender.cocaine"
  -- "lab.weed"
  

  --GROVE STREET FAMILIE
  --BALLAS
  --AZTECAS
  --THELOST
  --YAKUZA
  --SICILIANA
  -- mission.gunrunner.shipment
  
  ["MansaoYakuza"] = {
	"yakuza.lavagem.dinheiro",
	"yakuza.vehicle",
	"yakuza.cloakroom",
	"yakuza.membros",
	"yakuza.bau"
  },
  ["MansaoYakuzaMembro"] = {
	"yakuza.vehicle",
	"yakuza.cloakroom",
	"yakuza.membros",
	"yakuza.bau"
  },
  ["MansaoSiciliana"] = {
    "siciliana.craft.armas",
    "siciliana.vehicle",
    "siciliana.membros"
  },
  ["MansaoSicilianaMembros"] = {
  	"siciliana.bau",
    "siciliana.vehicle",
    "siciliana.membros"
  },
  ["MansaoLoveStory"] = {
    "lovestory.lavagem.dinheiro",
    "lovestory.vehicle",
	"lovestory.cloakroom",
	"lovestory.girls.cloakroom"
  },
  ["MansaoLoveStoryGirls"] = {
    "lovestory.girls.cloakroom",
  },
  ["VanillaGirls"] = {
    "vanilla.girls.cloakroom",
  },
  ["BankRobber"] = {
    "bank.bypass"
  },
  ["LostMC"] = {
  	_config = { onspawn = function(player) vRPclient.notify(player,{"Você é um Membro da Lost MC."}) TriggerClientEvent("b2k:LostMC", player) end },
    "lostmc.vehicle",
    "lostmc.quests"
  },
  ["Neymar"] = {
  	_config = { onspawn = function(player) vRPclient.notify(player,{"Você é um Neymar."}) TriggerClientEvent("b2k:Neymar", player) end },
  }, 
  
  -- ################# Empregos Legais #################
  ["Mecanico"] = {
    _config = { gtype = "job" },
	-- Base
    "vehicle.repair",
    "repair.market",
    "repair.service",
    "mission.repair.satellite_dishes",
    "mission.repair.wind_turbines",
    --"carjacker.lockpick",
	
	-- Salario
	"paycheck.mecanico",
	
	-- Especificos
	"mecanico.vehicle",
	"mecanico.tow",
	"mecanico.cloakroom"
  },
  
  -- ################# Advogados #################
  ["Estagiario [ADV]"] = {
    _config = { gtype = "job" },
	"paycheck.adv.estagiario",
    "adv.vehicle",
	"advogado.service",
	"mission.adv"
  },
  ["Advogado [ADV]"] = {
    _config = { gtype = "job" },
	"paycheck.adv.junior",
    "adv.vehicle",
	"advogado.service",
	"mission.adv"
  },
  ["Presidente [ADV]"] = {
    _config = { gtype = "job" },
	"paycheck.adv.presidente",
    "adv.vehicle",
	"advogado.service",
	"mission.adv"
  },
  -- ################# Taxi #################
  ["Taxi"] = {
    _config = { gtype = "job" },
    "taxi.service",
	"taxi.mission",
    "paycheck.taxi",
	"taxi.vehicle",
	"mission.taxi.passenger"
  },
  -- ################# Entregador #################
  ["Entregador"] = {
    _config = { gtype = "job" },
    "paycheck.entregador",
	"entregador.vehicle",
    "entregador.service",
    "mission.delivery.food",
	"mission.delivery.food2"
  },
  -- ################# Sedex #################
  ["Sedex"] = {
    _config = { gtype = "job" },
    "paycheck.sedex",
    "sedex.job",
	"sedex.cloakroom"
  },
  -- ################# Minerador #################
  ["Minerador"] = {
    _config = { gtype = "job" },
    "minerador.job",
    "minerador.garimpar",

    
    "vender.diamantes",
    "lapidar.diamantes",
    "paycheck.minerador"
  },
  -- ################# Reporter #################
  ["Reporter"] = {
    _config = { gtype = "job"},
    "reporter.vehicle",
	"reporter.cmds",
	"paycheck.reporter",
	"b2knews.cloakroom",
	"report.announce"
  },
  
  ["Desempregado"] = {
    _config = { gtype = "job", onspawn = function(player) vRPclient.notify(player,{"Você esta desempregado, vá procurar emprego."}) end }
  }
}

-- groups are added dynamically using the API or the menu, but you can add group when an user join here
cfg.users = {
  [1] = { -- give superadmin and admin group to the first created user on the database
    "superadmin",
    "admin"
  }
}

-- group selectors
-- _config
--- x,y,z, blipid, blipcolor, permissions (optional)

cfg.jobcooldown = false -- job change cooldown
cfg.jobcooldowntime = 40 -- cooldown time in minutes

cfg.selectors = {
  ["Agencia de Empregos"] = {
    _config = {x = -1081.9705810547, y = -247.76556396484, z = 37.763282775879, blipid = 269, blipcolor = 47},
	"Mecanico",
    "Minerador",
	"Taxi",
	"Sedex",
	"Entregador",
	"Desempregado"
  },
  ["Trabalhos Ilegais"] = {
    _config = {x = 707.28112792969, y = -966.33642578125, z = 30.412857055664, blipid = 400, blipcolor = 1},
	"Aviaozinho da Maconha",
    "Vapor de Cocaina",
    --"Traficante de Metanfetamina",
	"Traficante de Tartaruga",
	"Traficante de Armas",
	"Hacker"
  }
}

return cfg
