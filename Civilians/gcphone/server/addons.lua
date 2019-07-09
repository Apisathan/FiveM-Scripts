--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 17-12-2018
-- Time: 00:39
-- Made for CiviliansNetwork
--
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local users               = {}
local PhoneNumbers        = {}

function notifyAlertSMS (number, alert, list)
    if PhoneNumbers[number] ~= nil then
        for k, _ in pairs(list) do
            vRP.getUserIdentity({users[tonumber(k)].userid, function(identity)
                local n = identity.phone
                if n ~= nil then
                    TriggerEvent('gcPhone:_internalAddMessage', number, n, 'SMS fra #' .. alert.numero  .. ' : ' .. alert.message, 0, function (smsMess)
                        TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
                    end)
                    if alert.coords ~= nil then
                        TriggerEvent('gcPhone:_internalAddMessage', number, n, 'GPS: ' .. alert.coords.x .. ', ' .. alert.coords.y, 0, function (smsMess)
                            TriggerClientEvent("gcPhone:receiveMessage", tonumber(k), smsMess)
                        end)
                    end
                end
            end})
        end
    end
end

--[[
AddEventHandler('onResourceStart', function(name)
    if name:lower() == GetCurrentResourceName():lower() then
        local nusers = vRP.getUsers({})
        for k,v in pairs(nusers) do
            Citizen.Wait(50)
            if v ~= nil then
                local group = vRP.getUserGroupByType({k,"job"})
                addToPhoneNumbers(group,v)
                users[v] = {userid = k, job = group}
            end
        end
    end
end)
]]

AddEventHandler("vRP:playerLeave",function(user_id, source)
    if users[source] ~= nil then
        PhoneNumbers[users[source].job].sources[tostring(source)] = nil
        users[source] = nil
    end
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if users[source] ~= nil then
        PhoneNumbers[users[source].job].sources[tostring(source)] = nil
        users[source] = nil
    end
    local group = vRP.getUserGroupByType({user_id,"job"})
    addToPhoneNumbers(group,source)
    users[source] = {userid = user_id, job = group}
end)

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
    if gtype == "job" then
        local source = vRP.getUserSource({user_id})
        if users[source] ~= nil then
            PhoneNumbers[users[source].job].sources[tostring(source)] = nil
            users[source] = nil
        end
        addToPhoneNumbers(group,source)
        users[source] = {userid = user_id, job = group}
    end
end)

RegisterServerEvent('service:startCall')
AddEventHandler('service:startCall', function (number, message, coords)
    local source = source
    local user_id = vRP.getUserId({source})
    if number == "Politi-Job" or number == "EMS-Job" then
        vRP.getUserIdentity({user_id, function(identity)
            local discord = "https://discordapp.com/api/webhooks/539934609995988992/EIuqjZEk4yZZKyNLiF7HZNDPtFd5o0aMbsoMrco5JCVvW3rF8Mb4vDZMYFEDiiNvnr_M"
            if number == "EMS-Job" then
                discord = "https://discordapp.com/api/webhooks/539934662387302415/WkoqvnUXmiplhK8eDwFhWjNHqY4sT_Yxgnu4YGILCUkEsBc_JwgF-_V-V437FKqQ3mWx"
            end
            webhookDiscord(identity.phone.." - "..identity.firstname.." "..identity.name,message,discord)
        end})
    end
    if PhoneNumbers[number] ~= nil then
        vRP.getUserIdentity({user_id, function(identity)
            local phone = identity.phone
            notifyAlertSMS(number, {
                message = message,
                coords = (number == "Politi-Job" or number == "EMS-Job" or number == "Mekaniker-Job" or number == "Taxi") == true and coords or nil,
                numero = phone,
                userid = user_id,
            }, PhoneNumbers[number].sources)
        end})
    end
end)

function addToPhoneNumbers(number, source)
    if PhoneNumbers[number] == nil then
        PhoneNumbers[number] = {
            type          = number,
            sources       = {},
            alerts        = {}
        }
    end
    PhoneNumbers[number].sources[tostring(source)] = true
end
function webhookDiscord(name,message,discord)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    PerformHttpRequest(discord, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
end
