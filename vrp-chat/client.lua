--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 11-01-2019
-- Time: 20:22
-- Github: https://github.com/Apisathan/FiveM-Scripts
--

RegisterNetEvent('vrp-chat:notify')
AddEventHandler('vrp-chat:notify', function(message)
    PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    TriggerEvent('chatMessage', message)
end)