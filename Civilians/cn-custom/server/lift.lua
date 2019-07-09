--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 07-03-2019
-- Time: 15:19
-- Made for CiviliansNetwork
--
local lifts = {}

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    TriggerClientEvent('cn-lift:load', source, lifts)
end)

RegisterServerEvent('cn-lift:sendstatus')
AddEventHandler('cn-lift:sendstatus', function(id, status)
    lifts[id] = status
    TriggerClientEvent('cn-lift:status', -1, id,status)
end)