description "vRP barbershop"

dependency "vrp"

client_scripts { 
  "lib/Tunnel.lua",
  "lib/Proxy.lua",
  "client.lua"
}

server_scripts { 
  "@vrp/lib/utils.lua",
  "server.lua"
}