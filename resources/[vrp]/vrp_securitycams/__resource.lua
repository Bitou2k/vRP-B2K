--[[
   Scripted By: Xander1998 (X. Cross)
--]]

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "ui/index.html"

files {
    "ui/index.html",
    "ui/vue.min.js",
    "ui/script.js"
}

dependency "vrp"

client_scripts{ 
  "lib/Proxy.lua",
  "lib/Tunnel.lua",
  "config.lua",
  "client.lua"
}

server_scripts {
  '@vrp/lib/utils.lua',
  'server.lua'
}
