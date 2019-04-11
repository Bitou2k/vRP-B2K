resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "RP module/framework"

dependency "vrp_mysql"

ui_page "gui/index.html"

-- server scripts
server_scripts{ 
  "lib/utils.lua",
  "queue.lua",
  "base.lua",
  "modules/gui.lua",
  "modules/group.lua",
  "modules/admin.lua",
  "modules/survival.lua",
  "modules/player_state.lua",
  "modules/map.lua",
  "modules/money.lua",
  "modules/inventory.lua",
  "modules/identity.lua",
  "modules/business.lua",
  "modules/item_transformer.lua",
  "modules/emotes.lua",
  "modules/police.lua",
  "modules/home.lua",
  "modules/home_components.lua",
  "modules/mission.lua",
  "modules/aptitude.lua",

  -- basic implementations
  "modules/basic_phone.lua",
  "modules/basic_atm.lua",
  "modules/basic_market.lua",
  "modules/basic_gunshop.lua",
  "modules/basic_garage.lua",
  "modules/basic_items.lua",
  "modules/basic_skinshop.lua",
  "modules/cloakroom.lua",
  "modules/paycheck.lua",
  "modules/hotkeys.lua"
}

-- client scripts
client_scripts{
  "lib/utils.lua",
  "client/Tunnel.lua",
  "client/Proxy.lua",
  "client/base.lua",
  "client/iplloader.lua",
  "client/gui.lua",
  "client/player_state.lua",
  "client/survival.lua",
  "client/map.lua",
  "client/identity.lua",
  "client/basic_garage.lua",
  "client/police.lua",
  "client/paycheck.lua",
  "client/admin.lua",
  "client/debug.lua",
  "hotkeys/hotkeys.lua"
}

-- client files
files{
  "cfg/client.lua",
  "gui/index.html",
  "gui/reset.css",
  "gui/design.css",
  "gui/redesign.css",
  "gui/main.js",
  "gui/Menu.js",
  "gui/ProgressBar.js",
  "gui/WPrompt.js",
  "gui/RequestManager.js",
  "gui/AnnounceManager.js",
  "gui/Div.js",
  "gui/dynamic_classes.js",
  "gui/fonts/Pdown.woff",
  "gui/fonts/bankgothic.ttf",
  "gui/fonts/carme.woff",
  "gui/fonts/Pricedown.woff",
  "gui/fonts/House.woff",
  "gui/fonts/london.woff",
	
  --icons
  "gui/imgs/wallet.png",
  "gui/imgs/id.png",
  "gui/imgs/backpack.png",
  "gui/imgs/books.png",
  "gui/imgs/car.png",
  "gui/imgs/gun.png",
  "gui/imgs/man-dancing.png",
  "gui/imgs/money.png",
  "gui/imgs/apm_siren.png",
  "gui/imgs/apm_siren2.png",
  "gui/imgs/smartphone.png",
  "gui/imgs/trunk-open.png",
  "gui/imgs/businessman.png",
  "gui/imgs/cancel.png",
  "gui/imgs/emservico.png",
  "gui/imgs/add.png",
  "gui/imgs/headset.png",
  "gui/imgs/thief.png",
  "gui/imgs/afirst-aid-kit.png",
  "gui/imgs/zhelp.png",
  
  -- cars
  "gui/cars/camaross2010.png",
  "gui/cars/fusca63.png",
  "gui/cars/ftoro.png",
  "gui/cars/veloster.png",
  "gui/cars/passat.png",
}
