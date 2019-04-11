-----[ CODE, DON'T TOUCH THIS ]-------------------------------------------
RegisterServerEvent('va:getPlayerIdentifiers')
AddEventHandler('va:getPlayerIdentifiers', function()
    if GetPlayerIdentifiers(source) ~= nil then
        TriggerClientEvent('va:setPlayerIdentifiers', source, GetPlayerIdentifiers(source))
    end
end)
--------------------------------------------------------------------------