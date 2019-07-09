--====================================================================================
-- #Author: Jonathan D @ Gannon
--====================================================================================

-- Configuration
local KeyToucheCloseEvent = {
    { code = 172, event = 'ArrowUp' },
    { code = 173, event = 'ArrowDown' },
    { code = 174, event = 'ArrowLeft' },
    { code = 175, event = 'ArrowRight' },
    { code = 176, event = 'Enter' },
    { code = 177, event = 'Backspace' }, -- Prøv med numpad
    { code = 96, event = '-' }, -- Prøv med numpad
    { code = 97, event = '+' }, -- Prøv med numpad
    { code = 157, event = '1' }, -- Prøv med numpad
    { code = 158, event = '2' }, -- Prøv med numpad
    { code = 160, event = '3' }, -- Prøv med numpad
    { code = 164, event = '4' }, -- Prøv med numpad
    { code = 165, event = '5' }, -- Prøv med numpad
    { code = 159, event = '6' }, -- Prøv med numpad
    { code = 161, event = '7' }, -- Prøv med numpad
    { code = 162, event = '8' }, -- Prøv med numpad
    { code = 163, event = '9' }, -- Prøv med numpad
    { code = 82, event = ',' }, -- Prøv med numpad
}
local KeyOpenClose = 170 -- F2
local KeyTakeCall = 38 -- E
local menuIsOpen = false
local contacts = {}
local messages = {}
local myPhoneNumber = ''
local isDead = false
local USE_RTC = false
local userid = 'Ukendt'

local PhoneInCall = {}
local currentPlaySound = false
local soundId = 1485

vRP = Proxy.getInterface("vRP")

--====================================================================================
--  Active ou Deactive une application (appName => config.json)
--====================================================================================
RegisterNetEvent('gcPhone:setEnableApp')
AddEventHandler('gcPhone:setEnableApp', function(appName, enable)
    SendNUIMessage({event = 'setEnableApp', appName = appName, enable = enable })
end)

--====================================================================================
--  Gestion des appels fixe
--====================================================================================
function startFixeCall (fixeNumber)
    local number = ''
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 10)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        number =  GetOnscreenKeyboardResult()
    end
    if number ~= '' then
        TriggerEvent('gcPhone:autoCall', number, {
            useNumber = fixeNumber
        })
        PhonePlayCall(true)
    end
end

function TakeAppel (infoCall)
    TriggerEvent('gcPhone:autoAcceptCall', infoCall)
end

RegisterNetEvent("gcPhone:notifyFixePhoneChange")
AddEventHandler("gcPhone:notifyFixePhoneChange", function(_PhoneInCall)
    PhoneInCall = _PhoneInCall
end)

--[[
  Affiche les imformations quant le joueurs est proche d'un fixe
--]]
function showFixePhoneHelper (coords)
    for number, data in pairs(FixePhone) do
        local dist = GetDistanceBetweenCoords(
            data.coords.x, data.coords.y, data.coords.z,
            coords.x, coords.y, coords.z, 1)
        if dist <= 2.0 then
            SetTextComponentFormat("STRING")
            AddTextComponentString("~g~" .. data.name .. ' ~o~' .. number .. '~n~~INPUT_PICKUP~~w~ Utiliser')
            DisplayHelpTextFromStringLabel(0, 0, 0, -1)
            if IsControlJustPressed(1, KeyTakeCall) then
                startFixeCall(number)
            end
            break
        end
    end
end


Citizen.CreateThread(function ()
    while true do
        local playerPed   = PlayerPedId()
        local coords      = GetEntityCoords(playerPed)
        local inRangeToActivePhone = false
        for i, _ in pairs(PhoneInCall) do
            local dist = GetDistanceBetweenCoords(
                PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
                coords.x, coords.y, coords.z, 1)
            if (dist <= 5.0) then
                DrawMarker(1, PhoneInCall[i].coords.x, PhoneInCall[i].coords.y, PhoneInCall[i].coords.z,
                    0,0,0, 0,0,0, 0.1,0.1,0.1, 0,255,0,255, 0,0,0,0,0,0,0)
                inRangeToActivePhone = true
                if (dist <= 1.5) then
                    SetTextComponentFormat("STRING")
                    AddTextComponentString("~INPUT_PICKUP~ Décrocher")
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(1, KeyTakeCall) then
                        PhonePlayCall(true)
                        TakeAppel(PhoneInCall[i])
                        PhoneInCall = {}
                        StopSound(soundId)
                    end
                end
                break
            end
        end
        if inRangeToActivePhone == false then
            showFixePhoneHelper(coords)
        end
        if inRangeToActivePhone == true and currentPlaySound == true then
            PlaySound(soundId, "Remote_Ring", "Phone_SoundSet_Michael", 0, 0, 1)
            currentPlaySound = false
        elseif inRangeToActivePhone == false and currentPlaySound == true then
            currentPlaySound = true
            StopSound(soundId)
        end
        Citizen.Wait(0)
    end
end)

--====================================================================================
--  
--====================================================================================
Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, KeyOpenClose) then
            TooglePhone()
        end
        if menuIsOpen == true then
            for _, value in ipairs(KeyToucheCloseEvent) do
                if IsControlJustPressed(1, value.code) then
                    SendNUIMessage({keyUp = value.event})
                end
            end
        end
    end
end)

RegisterNetEvent("gcPhone:forceOpenPhone")
AddEventHandler("gcPhone:forceOpenPhone", function(_myPhoneNumber)
    if menuIsOpen == false then
        TooglePhone()
    end
end)

--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent("gcPhone:userid")
AddEventHandler("gcPhone:userid", function(_userid)
    userid = _userid
    SendNUIMessage({event = 'updateUserID', userid = userid})
end)

RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber", function(_myPhoneNumber)
    myPhoneNumber = _myPhoneNumber
    SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})
end)

RegisterNetEvent("gcPhone:contactList")
AddEventHandler("gcPhone:contactList", function(_contacts)
    SendNUIMessage({event = 'updateContacts', contacts = _contacts})
    contacts = _contacts
end)

RegisterNetEvent("gcPhone:allMessage")
AddEventHandler("gcPhone:allMessage", function(allmessages)
    for k,v in pairs(allmessages) do
        Wait(5)
        if v.message ~= nil then
            v.message = Emojit(v.message)
        end
    end
    SendNUIMessage({event = 'updateMessages', messages = allmessages})
    messages = allmessages
end)

RegisterNetEvent("gcPhone:getBourse")
AddEventHandler("gcPhone:getBourse", function(bourse)
    SendNUIMessage({event = 'updateBourse', bourse = bourse})
end)

local contactnotify = false
RegisterNetEvent("gcPhone:receiveMessage")
AddEventHandler("gcPhone:receiveMessage", function(message)
    message.message = Emojit(message.message)
    SendNUIMessage({event = 'newMessage', message = message})
    if message.owner == 0 then
        if ShowNumberNotification == true then
            for _,contact in pairs(contacts) do
                if contact.number == message.transmitter then
                    TriggerEvent("pNotify:SendNotification",{text = "<h3>💬 Besked</h3> <br> <p>Du har modtaget en ny besked fra "..contact.display.. "</p>",type = "besked",timeout = (8000),layout = "bottomright",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})                    contactnotify = true
                    break;
                end
            end
            if contactnotify == false then
                TriggerEvent("pNotify:SendNotification",{text = "<h3>💬 Besked</h3> <br> <p>Du har modtaget en ny besked fra "..message.transmitter.."</p>",type = "besked",timeout = (8000),layout = "bottomright",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer = true})            
            end
        end
        contactnotify = false
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    end
end)

--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num)
    TriggerServerEvent('gcPhone:addContact', display, num)
end

function deleteContact(num)
    TriggerServerEvent('gcPhone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================
function sendMessage(num, message)
    TriggerServerEvent('gcPhone:sendMessage', num, message)
end

function deleteMessage(msgId)
    TriggerServerEvent('gcPhone:deleteMessage', msgId)
end

function deleteMessageContact(num)
    TriggerServerEvent('gcPhone:deleteMessageNumber', num)
end

function deleteAllMessage()
    TriggerServerEvent('gcPhone:deleteAllMessage')
end

function setReadMessageNumber(num)
    TriggerServerEvent('gcPhone:setReadMessageNumber', num)
    for k, v in ipairs(messages) do
        if v.transmitter == num then
            v.isRead = 1
        end
    end
end

function requestAllMessages()
    TriggerServerEvent('gcPhone:requestAllMessages')
end

function requestAllContact()
    TriggerServerEvent('gcPhone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local inCall = false
local aminCall = false

local IsInCall = false

RegisterNetEvent("gcPhone:waitingCall")
AddEventHandler("gcPhone:waitingCall", function(infoCall, initiator)
    SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator})
    if initiator == true then
        PhonePlayCall()
        if menuIsOpen == false then
            TooglePhone()
        end
    end
end)

RegisterNetEvent("gcPhone:acceptCall")
AddEventHandler("gcPhone:acceptCall", function(infoCall, initiator)
    if inCall == false and USE_RTC == false then
        inCall = true
        NetworkSetVoiceChannel(infoCall.id + 1)
        NetworkSetTalkerProximity(0.0)
    end
    if menuIsOpen == false then
        TooglePhone()
    end
    PhonePlayCall()
    SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("gcPhone:rejectCall")
AddEventHandler("gcPhone:rejectCall", function(infoCall)
    if inCall == true then
        inCall = false
        Citizen.InvokeNative(0xE036A705F989E049)
        NetworkSetTalkerProximity(2.5)
    end
    PhonePlayText()
    SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)

RegisterNetEvent("gcPhone:historiqueCall")
AddEventHandler("gcPhone:historiqueCall", function(historique)
    SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function rejectCall(infoCall)
    TriggerServerEvent('gcPhone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
    TriggerServerEvent('gcPhone:ignoreCall', infoCall)
end

function appelsDeleteHistorique (num)
    TriggerServerEvent('gcPhone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
    TriggerServerEvent('gcPhone:appelsDeleteAllHistorique')
end


--====================================================================================
--  Event NUI - Appels
--====================================================================================
function startCall (phone_number, rtcOffer, extraData)
    TriggerServerEvent('gcPhone:startCall', phone_number, rtcOffer, extraData)
end
RegisterNUICallback('startCall', function (data, cb)
    startCall(data.numero, data.rtcOffer, data.extraData)
    cb()
end)

function acceptCall (infoCall, rtcAnswer)
    TriggerServerEvent('gcPhone:acceptCall', infoCall, rtcAnswer)
end
RegisterNUICallback('acceptCall', function (data, cb)
    acceptCall(data.infoCall, data.rtcAnswer)
    cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
    rejectCall(data.infoCall)
    cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
    ignoreCall(data.infoCall)
    cb()
end)

RegisterNUICallback('notififyUseRTC', function (use, cb)
    USE_RTC = use
    if USE_RTC == true and inCall == true then
        inCall = false
        Citizen.InvokeNative(0xE036A705F989E049)
        NetworkSetTalkerProximity(2.5)
    end
    cb()
end)

RegisterNUICallback('gcphone_sendnotify', function (message, cb)
    TriggerServerEvent("gcphone_sendnotify" , message.message,message.sound,message.volume)
    cb()
end)


RegisterNUICallback('onCandidates', function (data, cb)
    TriggerServerEvent('gcPhone:candidates', data.id, data.candidates)
    cb()
end)

RegisterNetEvent("gcPhone:candidates")
AddEventHandler("gcPhone:candidates", function(candidates)
    SendNUIMessage({event = 'candidatesAvailable', candidates = candidates})
end)



RegisterNetEvent('gcPhone:autoCall')
AddEventHandler('gcPhone:autoCall', function(number, extraData)
    if number ~= nil then
        SendNUIMessage({ event = "autoStartCall", number = number, extraData = extraData})
    end
end)

RegisterNetEvent('gcPhone:autoCallNumber')
AddEventHandler('gcPhone:autoCallNumber', function(data)
    TriggerEvent('gcPhone:autoCall', data.number)
end)

RegisterNetEvent('gcPhone:autoAcceptCall')
AddEventHandler('gcPhone:autoAcceptCall', function(infoCall)
    SendNUIMessage({ event = "autoAcceptCall", infoCall = infoCall})
end)





























































--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
    cb()
end)
RegisterNUICallback('focus', function(data, cb)
    cb()
end)
RegisterNUICallback('blur', function(data, cb)
    cb()
end)
RegisterNUICallback('reponseText', function(data, cb)
    local limit = data.limit or 255
    local text = data.text or ''

    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", text, "", "", "", limit)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0);
        Wait(0);
    end
    if (GetOnscreenKeyboardResult()) then
        text = GetOnscreenKeyboardResult()
    end
    cb(json.encode({text = text}))
end)
--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
    cb(json.encode(messages))
end)
RegisterNUICallback('sendMessage', function(data, cb)
    if data.message == '%pos%' then
        local myPos = GetEntityCoords(PlayerPedId())
        data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
    end
    TriggerServerEvent('gcPhone:sendMessage', data.phoneNumber, data.message)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
    deleteMessage(data.id)
    cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
    deleteMessageContact(data.number)
    cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
    deleteAllMessage()
    cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
    setReadMessageNumber(data.number)
    cb()
end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb)
    TriggerServerEvent('gcPhone:addContact', data.display, data.phoneNumber)
end)
RegisterNUICallback('updateContact', function(data, cb)
    TriggerServerEvent('gcPhone:updateContact', data.id, data.display, data.phoneNumber, data.olddisplay)
end)
RegisterNUICallback('deleteContact', function(data, cb)
    TriggerServerEvent('gcPhone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
    cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
    SetNewWaypoint(tonumber(data.x), tonumber(data.y))
    cb()
end)
RegisterNUICallback('callEvent', function(data, cb)
    if data.data ~= nil then
        TriggerEvent(data.eventName, data.data)
    else
        TriggerEvent(data.eventName)
    end
    cb()
end)
RegisterNUICallback('deleteALL', function(data, cb)
    TriggerServerEvent('gcPhone:deleteALL')
    cb()
end)

RegisterNetEvent('gcPhone:openPhone')
AddEventHandler('gcPhone:openPhone', function(phone)
    SendNUIMessage({event = 'updatePhoneCover', phone = phone})
    if phone ~= "Ingen" then
        menuIsOpen = not menuIsOpen
        SendNUIMessage({show = menuIsOpen})
        PhonePlayIn()
    end
end)

function TooglePhone()
    if IsEntityVisible(PlayerPedId()) then
        if menuIsOpen == true then
            menuIsOpen = not menuIsOpen
            SendNUIMessage({show = menuIsOpen})
            PhonePlayOut()
        else
            local ped = GetPlayerPed(-1)
            local playerHealth = GetEntityHealth(ped) - 100
            if DoesEntityExist(ped) and playerHealth > 0 and vRP.isHandcuffed() == false and vRP.isInComa() == false then
                blokerknap = true
                TriggerServerEvent("gcPhone:hasPhone")
            end
        end
    end
end

RegisterNUICallback('takePhoto', function(data, cb)
    menuIsOpen = false
    SendNUIMessage({show = false})
    cb()
    TriggerEvent('camera:open')
end)
RegisterNUICallback('useBilbasen', function(data, cb)
    menuIsOpen = false
    SendNUIMessage({show = false})
    TriggerEvent("cardealer:openGui")
    cb()
end)
RegisterNUICallback('closePhone', function(data, cb)
    menuIsOpen = false
    SendNUIMessage({show = false})
    PhonePlayOut()
    cb()
end)




----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
    appelsDeleteHistorique(data.numero)
    cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
    appelsDeleteAllHistorique(data.infoCall)
    cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------

function Emojit(text)
    for i = 1, #emoji do
        for k = 1, #emoji[i][1] do
            text = string.gsub(text, emoji[i][1][k], emoji[i][2])
        end
    end
    return text
end