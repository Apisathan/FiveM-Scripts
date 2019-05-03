--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 11-01-2019
-- Time: 20:20
-- Github: https://github.com/Apisathan/FiveM-Scripts
--

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vrp_extended","vrp_extended")
vRPex = {}
Proxy.addInterface("vrp_extended",vRPex)

local users = {}
function vRPex.updateInventory(user_id,inventory,weight)
    vRPclient.setInventory(-1,{user_id,inventory,weight})
end
function vRPex.updateMoney(user_id,bank,wallet)
    users[user_id].bank=bank
    users[user_id].wallet=wallet
    vRPclient.setUsers(-1,{users})
end

AddEventHandler("vRP:playerLeave",function(user_id, source)
    vRPclient.removeUser(-1,{user_id})
    users[user_id] = nil
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        vRP.getUserIdentity({user_id, function(identity)
            local job = vRP.getUserGroupByType({user_id,"job"})
            local money = vRP.getUserTmpTable({user_id})
            local data = {
                userid=tonumber(user_id),
                source=tonumber(source),
                name=tostring(identity.firstname.." "..identity.name),
                job=tostring(job),
                inventory=vRP.getInventory({user_id}),
                reg=identity.registration,
                age=identity.age,
                bank=money.bank,
                wallet=money.wallet,
            }
            users[user_id] = data
            vRPclient.setUsers(-1,{users})
        end})
        vRPclient.setUserId(source,{user_id})
    else
        local inventory = vRP.getInventory({user_id})
        users[user_id].inventory = inventory
        users[user_id].weight = vRP.getInventoryWeight({user_id})
        vRPclient.setUsers(-1,{users})
    end
end)

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
    if gtype == "job" then
        local job = vRP.getUserGroupByType({user_id,"job"})
        users[user_id].job = tostring(job)
        vRPclient.setUsers(-1,{users})
    end
end)

AddEventHandler('onResourceStart', function(name)
    if name:lower() == GetCurrentResourceName():lower() then
        local lusers = vRP.getUsers({})
        for k,v in pairs(lusers) do
            Citizen.Wait(50)
            if v ~= nil then
                vRP.getUserIdentity({k, function(identity)
                    local job = vRP.getUserGroupByType({k,"job"})
                    local money = vRP.getUserTmpTable({k})
                    local data = {
                        userid=tonumber(k),
                        source=tonumber(v),
                        name=tostring(identity.firstname.." "..identity.name),
                        job=tostring(job),
                        inventory=vRP.getInventory({k}),
                        reg=identity.registration,
                        age=identity.age,
                        bank=money.bank,
                        wallet=money.wallet,
                    }
                    users[k] = data
                    vRPclient.setUsers(-1,{users})
                end})
                vRPclient.setUserId(v,{k})
            end
        end
    end
end)