-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'FiveM b2k_snippets'

dependency "vrp"

-- General
client_scripts {

  -- snippets
  'loadfreeze-client.lua',
  'pausemenutitle-client.lua',
  'watermark-client.lua',
  'world-weapons-disables-client.lua',
  'weathersync-client.lua',
  'noshuffle-client.lua',
  'nodriveby-client.lua',
  'vehicledoorlocked-client.lua',
  'recoil-client.lua',
  'anticheater-client.lua',
  --'cardamage-client.lua',
  'outlawalert-client.lua',
  'announcer-client.lua',
  'afkkick-client.lua',
}

server_scripts {
  '@vrp/lib/utils.lua',
  -- snippets
  'loadfreeze-server.lua',
  'weathersync-server.lua',
  'anticheater-server.lua',
  'outlawalert-server.lua',
  'announcer-client.lua',
  'afkkick-server.lua',
}