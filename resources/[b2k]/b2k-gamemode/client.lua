-- Spawn override + Shut down Loading Screen
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

-- Call this after playerSpawn, instantly goes into a NUI welcome page
-- From here you can setup your interface to select chars, create chars, etc.
RegisterNetEvent('b2k:clientPlayerSpawn')
AddEventHandler('b2k:clientPlayerSpawn', function(x, y, z, model)
    exports.spawnmanager:spawnPlayer({x = x, y = y, z = z, model = GetHashKey(model)})
end)