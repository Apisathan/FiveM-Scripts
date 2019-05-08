--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 11-01-2019
-- Time: 20:22
-- Github: https://github.com/Apisathan/FiveM-Scripts
--

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
local cfg = module("vrp-chat", "cfg/config")

AddEventHandler('chatMessage', function(source, author, msg)
    local args = stringsplit(msg, ' ')
    if string.lower(args[1]) == "/r" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,cfg.notifyStaffPerm}) then
            args[2] = parseInt(args[2])
            local checkid = vRP.getUserSource({tonumber(args[2])})
            if checkid ~= nil then
                if args[3] ~= nil then
                    local smessage = ""
                    for k,v in pairs(args) do
                        if k > 2 then
                            smessage = smessage .. v .." "
                        end
                    end
                    sendToDiscord("STAFF REPLY CHAT", "**SVAR TIL "..args[2].." FRA "..tostring(user_id) .. "** - " ..author..": ^1" .. smessage)
                    TriggerClientEvent('vrp-chat:notify',checkid, "OOC ^7| ^1STAFF ^7| ^3SVAR TIL DIG ^7| " ..author..": ^1" ..  smessage)
                    local users = vRP.getUsers({})
                    for k,v in pairs(users) do
                        if v ~= nil then
                            if vRP.hasPermission({k,cfg.notifyStaffPerm}) then
                                TriggerClientEvent('chatMessage',v, "^1STAFFCHAT ^7| ^3SVAR TIL "..args[2].." ^7| " ..author..": ^1" ..  smessage)
                            end
                        end
                    end
                else
                    TriggerClientEvent("pNotify:SendNotification",source,{text = "Du skal skrive noget efter ID!", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            else
                TriggerClientEvent("pNotify:SendNotification",source,{text = "ID "..args[2].." er ugyldigt eller ikke online.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/ooc" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,cfg.notifyStaffPerm}) then
            local message = string.sub(msg, 6)
            if message ~= "" then
                sendToDiscord("OOC CHAT", "**"..tostring(user_id) .. "** - " ..author..": ^1" .. message)
                TriggerClientEvent('chatMessage',-1, "OOC ^7| ^1STAFF ^7| " ..author..": ^1" ..  message)
            end
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/pk" and cfg.pkCommand or  string.lower(args[1]) == "/ck" and cfg.ckCommand then
        local message = string.sub(msg, 5)
        local type = string.upper(string.sub(msg,2,3))
        if message ~= "" then
            local user_id = vRP.getUserId({source})
            sendToDiscord(type.." CHAT", "**"..tostring(user_id) .. "** - " ..author..": ^1" .. message)
            TriggerClientEvent('chatMessage',-1, "^5"..type.." ^7| ^3SPILLER: ^1" .. message)
        end
        CancelEvent()
    end
end)

RegisterServerEvent('vrp-chat:chat_message')
AddEventHandler('vrp-chat:chat_message', function(source,author,message)
    local user_id = vRP.getUserId({source})
    local staff = false
    if vRP.hasPermission({user_id,cfg.notifyStaffPerm}) then
        staff = true
    else
        TriggerClientEvent('chatMessage', source, "OOC ^7| ^5SPILLER ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
    end
    local users = vRP.getUsers({})
    for k,v in pairs(users) do
        if v ~= nil then
            if vRP.hasPermission({k,cfg.notifyStaffPerm}) then
                if staff then
                    TriggerClientEvent('chatMessage', v, "^1STAFFCHAT ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
                else
                    TriggerClientEvent('chatMessage', v, "^3HJÆLP ^7| ^5SPILLER ^7| "..user_id.." ^7| " ..author..": ^1" ..  message)
                end
            end
        end
    end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function sendToDiscord(name, message,discord)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    if cfg.discordWebhook ~= "WEBHOOK" then
        PerformHttpRequest(cfg.discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    end
end
