-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'vrp'

-- General
client_script 'cl_tow.lua'

server_scripts {
	'@vrp/lib/utils.lua',
	'sv_tow.lua'
}