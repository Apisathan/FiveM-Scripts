--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 09-03-2019
-- Time: 01:46
-- Made for CiviliansNetwork
--
local beds = {}

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("vrp_hospital:place", source)
    end
    TriggerClientEvent('cn-hospital:load', source, beds)
end)

AddEventHandler("vRP:playerLeave",function(user_id,source)
    for k,v in pairs(beds) do
        if v == source then
            beds[k] = nil
            TriggerClientEvent('cn-hospital:status', -1,k,nil)
        end
    end
end)

RegisterServerEvent('cn-hospital:sendstatus')
AddEventHandler('cn-hospital:sendstatus', function(id,used)
    beds[id] = (used) and source or nil
    TriggerClientEvent('cn-hospital:status', -1, id,beds[id])
end)