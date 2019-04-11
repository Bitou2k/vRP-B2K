resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vrp_id_display"

dependency "vrp"

client_scripts {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"cfg/display.lua",
	"client.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
	"server.lua"
}
