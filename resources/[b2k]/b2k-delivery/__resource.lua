resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'


dependency "vrp"

client_scripts{ 
  "@vrp/lib/utils.lua",
  "cl_delivery.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "sv_delivery.lua"
}



--client_script "cl_delivery.lua"
--server_script "sv_delivery.lua"
