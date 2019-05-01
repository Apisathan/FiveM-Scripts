--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 11-01-2019
-- Time: 20:22
-- Github: https://github.com/Apisathan/FiveM-Scripts
--
vRPsb = {}
vRP = Proxy.getInterface("vRP")
Proxy.addInterface("vrp_extended",vRPsb)
Tunnel.bindInterface("vrp_extended",vRPsb)
local userid = 0
local users = {}

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function vRPsb.setUserId(user_id)
    userid = user_id
end

function vRPsb.setInventory(user_id,inventory,weight)
    if user_id ~= nil then
        if inventory ~= nil and weight ~= nil then
            if users[user_id] == nil then
                users[user_id] = {}
            end
            users[user_id].inventory = inventory
            users[user_id].weight = weight
        end
    end
end

local isEmergency = false
function vRPsb.setUsers(tusers)
    if tusers ~= nil then
        users = tusers
        for k,v in pairs(users) do
            if k == userid then
                if vRPsb.checkEmergency(v.job) then isEmergency = true else isEmergency = false end
            end
        end
    end
end

function vRPsb.removeUser(user_id)
    if user_id ~= nil then
        users[user_id] = nil
    end
end

function vRPsb.getUser()
    if userid ~= 0 then
        return users[tonumber(userid)]
    else
        return false
    end
end

function vRPsb.getUsers()
    return users
end

function vRPsb.checkEmergency(job)
    for k,v in pairs(excfg.groups) do
        if v.isEmergency ~= nil then
            for k2,v2 in pairs(v) do
                if k2 ~= "isEmergency" then
                    if v2 == job then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function vRPsb.hasJob(job)
    if excfg.groups[job] ~= nil then
        for k,v in pairs(excfg.groups[job]) do
            if v == job then
                return true
            end
        end
    else
        if users[tonumber(userid)].job == job then
            return true
        end
    end
    return false
end

function vRPsb.isEmergency()
    return isEmergency
end

-- Get a source's user_id
function vRPsb.getUserFromSource(source)
    for k, v in pairs(users) do
        if source == GetPlayerFromServerId(v.source) then
            return users[k]
        end
    end
    return false
end

-- Returns table
function vRPsb.getAmountOnline(group)
    local onlinelist = {}
    local online = 0
    for k, v in pairs(users) do
        if k ~= nil and v.source ~= nil and v.name ~= nil and NetworkIsPlayerActive(GetPlayerFromServerId(v.source)) then
            if group == "all" then
                online = online+1
                for k2,v2 in pairs(excfg.groups) do
                    for k3,v3 in pairs(v2) do
                        if v.job == v3 then
                            onlinelist[k2] = onlinelist[k2] ~= nil and onlinelist[k2]+1 or 1
                        end
                    end
                end
                onlinelist["all"] = online
            else
                if excfg.groups[group] ~= nil then
                    for k2,v2 in pairs(excfg.groups[group]) do
                        if v.job == v2 then
                            online=online+1
                        end
                    end
                else
                    if v.job == group then
                        online = online+1
                    end
                end

            end
        end
    end
    if group == "all" then
        return onlinelist
    else
        return {online=online}
    end
end