resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

client_scripts {
  "menu.lua",
  "lscustoms.lua",
  "lsconfig.lua"
}

server_scripts {
  "@vrp/lib/utils.lua",
  "lscustoms_server.lua"
}

