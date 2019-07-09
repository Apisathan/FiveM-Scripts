--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 19:17
-- Made for CiviliansNetwork
--
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
local cfg = module("vrp_doors", "config")

local doors = cfg.doors
local owned = {}

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        TriggerClientEvent('vrp_doors:load', source, doors)
    end
end)

RegisterServerEvent('vrp_doors:status')
AddEventHandler('vrp_doors:status', function(id, status)
    local user_id = vRP.getUserId({source})
    if (doors[id].key ~= nil and vRP.hasPermission({user_id, "#"..doors[id].key..".>0"})) or (doors[id].permission ~= nil and vRP.hasPermission({user_id,doors[id].permission})) or (doors[id].name ~= nil and doors[id].number ~= nil and owned[doors[id].name] ~= nil and owned[doors[id].name][doors[id].number] ~= nil and owned[doors[id].name][doors[id].number][user_id] ~= nil and owned[doors[id].name][doors[id].number][user_id] == true) then
        if doors[id].pairs ~= nil then
            doors[doors[id].pairs].locked=status
            TriggerClientEvent('vrp_doors:statusSend', -1, doors[id].pairs, status)
        end
        doors[id].locked=status
        TriggerClientEvent('vrp_doors:statusSend', -1, id, status)
    end
end)

RegisterServerEvent('vrp_doors:owneddoor')
AddEventHandler('vrp_doors:owneddoor', function(user_id,home,number,added)
    if owned[home] ~= nil and owned[home][number] ~= nil then
        if added then
            owned[home][number][user_id] = true
        else
            owned[home][number][user_id] = nil
        end
    end
end)

--[[RegisterServerEvent('qwheqwihqeoiq')
AddEventHandler('qwheqwihqeoiq', function()
    TriggerClientEvent('vrp_doors:load', -1, doors)
end)]]

AddEventHandler('onResourceStart', function(name)
    if name:lower() == GetCurrentResourceName():lower() then
        local vrpdoors = vRP.getKeyHomes()
        for k,v in pairs(vrpdoors) do
            for k2,v2 in pairs(v) do
                if k2 ~= "stype" and k2 ~= "weight" and k2 ~= "doorhash" then
                    if owned[k] == nil then
                        owned[k] = {}
                    end
                    owned[k][k2]={}
                    if v2.multipledoors ~= nil and v2.multipledoors == true then
                        for k3,v3 in pairs(v2.door) do
                            if v3.range ~= nil then
                                table.insert(doors,{locked=true,permission="realestate.key",name=k,number=k2,hash=v3.hash,coords=v3.coords,range=v3.range})
                            else
                                table.insert(doors,{locked=true,permission="realestate.key",name=k,number=k2,hash=v3.hash,coords=v3.coords})
                            end
                        end
                    else
                        table.insert(doors,{locked=true,permission="realestate.key",name=k,number=k2,hash=v.doorhash,coords=v2.door})
                    end
                end
            end
        end
    end
end)