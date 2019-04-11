local m = {} -- <<< Don't touch this!
-----------[ SETTINGS ]---------------------------------------------------

-- Delay in minutes between messages
m.delay = 10

-- Prefix appears in front of each message. 
-- Suffix appears on the end of each message.
-- Leave a prefix/suffix empty ( '' ) to disable them.
m.prefix = '^1ANÚNCIOS:'
m.suffix = '^6.'

-- You can make as many messages as you want.
-- You can use ^0-^9 in your messages to change text color.
m.messages = {   
    '^7Acesse nosso discord e fique por dentro de todas novidades http://bitou2k.com/discord',
    '^7Extremamente proibido VDM e RDM.',
	'^7Está extremamente proibido cometer crimes Uniformizados (usando skins dos trabalhos).',
    '^7Este servidor de Roleplay está em Desenvolvimento. Qualquer bug reporte a Staff.',
    '^7Interprete seu personagem e tenha respeito ao próximo.',
    '^7Denuncias somente com video.',
}

-- Player identifiers on this list will not receive any messages.
-- Simply remove all identifiers if you don't want an ignore list.
m.ignorelist = { 
    'ip:127.0.1.5',
    'steam:123456789123456',
    'license:1654687313215747944131321',
}
--------------------------------------------------------------------------


-----[ CODE, DON'T TOUCH THIS ]-------------------------------------------
local playerIdentifiers
local enableMessages = true
local timeout = m.delay * 1000 * 60 -- from ms, to sec, to min
local playerOnIgnoreList = false
RegisterNetEvent('va:setPlayerIdentifiers')
AddEventHandler('va:setPlayerIdentifiers', function(identifiers)
    playerIdentifiers = identifiers
end)
Citizen.CreateThread(function()
    if not playerOnIgnoreList then
        while true do
            for i in pairs(m.messages) do
                if enableMessages then
                    chat(i)
                end
                Citizen.Wait(timeout)
            end
            
            Citizen.Wait(10)
        end
    end
end)
function chat(i)
    TriggerEvent('chatMessage', '', {255,255,255}, m.prefix .. m.messages[i] .. m.suffix)
end
--------------------------------------------------------------------------
