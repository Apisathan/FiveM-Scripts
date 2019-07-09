RMySQL = module("vrp_mysql", "MySQL")
RMySQL.createCommand("vRP/gcphone_getMessages","SELECT * FROM phone_messages WHERE receiver = @phone")
RMySQL.createCommand("vRP/gcphone_getUserIdByPhone","SELECT user_id FROM vrp_user_identities WHERE phone = @phone")
RMySQL.createCommand("vRP/gcphone_insertMessage","INSERT INTO phone_messages (transmitter, receiver, message, isRead,owner) VALUES(@transmitter, @receiver, @message, @isRead, @owner); SELECT * from phone_messages WHERE id = (SELECT LAST_INSERT_ID());")
RMySQL.createCommand("vRP/gcphone_setRead","UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter")
RMySQL.createCommand("vRP/gcphone_deleteMessage","DELETE FROM phone_messages WHERE `id` = @id")
RMySQL.createCommand("vRP/gcphone_deleteAllMessageFromPhoneNumber","DELETE FROM phone_messages WHERE receiver = @mePhoneNumber and transmitter = @phone")
RMySQL.createCommand("vRP/gcphone_deleteAllMessage","DELETE FROM phone_messages WHERE receiver = @mePhoneNumber")
RMySQL.createCommand("vRP/gcphone_getHistoriqueCall","SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 100")
RMySQL.createCommand("vRP/gcphone_insertCall","INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)")
RMySQL.createCommand("vRP/gcphone_deleteCallsFromNumber","DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num")
RMySQL.createCommand("vRP/gcphone_deleteAllCalls","DELETE FROM phone_calls WHERE `owner` = @owner")
RMySQL.createCommand("vRP/gcphone_getTweets","SELECT name,message,time FROM `phone_twitter` ORDER by id DESC LIMIT 100")
RMySQL.createCommand("vRP/gcphone_deleteOldMessages","DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 20)")
RMySQL.createCommand("vRP/gcphone_deleteOldCalls","DELETE FROM phone_calls WHERE (DATEDIFF(CURRENT_DATE,time) > 20)")
RMySQL.createCommand("vRP/gcphone_deleteOldTweets","DELETE FROM phone_calls WHERE (DATEDIFF(CURRENT_DATE,time) > 20)")
RMySQL.createCommand("vRP/gcphone_deleteServiceMessages","DELETE FROM phone_messages WHERE (`transmitter` like '%-Job' or `transmitter` = 'Taxi') AND (DATEDIFF(CURRENT_DATE,time) > 1)")

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")


vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","gcphone")

-- CACHE
local tweets = {}

--====================================================================================
--  Utils
--====================================================================================
RMySQL.execute("vRP/gcphone_deleteOldMessages") -- Wipe beskeder der er ældre end 31 dage
RMySQL.execute("vRP/gcphone_deleteOldCalls") -- Wipe beskeder der er ældre end 31 dage
RMySQL.execute("vRP/gcphone_deleteServiceMessages") -- Wipe beskeder der er ældre end 31 dage

RegisterServerEvent('gcphone:addtweet')
AddEventHandler('gcphone:addtweet', function(name,message,time)
    local tweet = {name=name,message=message,time=time }
    local ltweets = json.decode(tweets)
    table.remove(ltweets,1)
    table.insert(ltweets,tweet)
    tweets = json.encode(ltweets)
end)

RegisterServerEvent('gcphone_sendnotify')
AddEventHandler('gcphone_sendnotify', function(message, sound, volume)
    local user_id = vRP.getUserId({source})
    if vRP.hasInventoryItem({user_id, "samsung"}) or vRP.hasInventoryItem({user_id, "iphone"}) or vRP.hasInventoryItem({user_id, "oneplus"}) then
        if message == "" then
            TriggerClientEvent('InteractSound_CL:PlayOnOne', source, sound, volume)
        else
            TriggerClientEvent("pNotify:SendNotification", source,{
                text = ''..message,
                type = "twitter",
                timeout = 7000,
                layout = "bottomright",
                queue = "global",
                animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                sounds = {
                    sources = {sound},
                    volume = volume,
                    conditions = {"docVisible"}
                }
            })
        end
    end
end)

RegisterServerEvent('gcPhone:hasPhone')
AddEventHandler('gcPhone:hasPhone', function()
    local user_id = vRP.getUserId({source})
    local phone = "Ingen"
    if vRP.hasInventoryItem({user_id, "samsung"}) then
        phone = "samsung"
    elseif vRP.hasInventoryItem({user_id, "iphone"}) then
        phone = "iphone"
    elseif vRP.hasInventoryItem({user_id, "oneplus"}) then
        phone = "oneplus"
    end
    TriggerClientEvent("gcPhone:openPhone", source, phone)
end)

--====================================================================================
--  Contacts
--====================================================================================
function getContacts(user_id)
    local contacts = vRP.getPhoneDirectory({user_id})
    local rcontacts = {}
    local i = 0
    for k,v in pairs(contacts) do
        i = i+1
        rcontacts[i] = {id = i, display = k, number = v}
    end
    return rcontacts
end

function addContact(source, identifier, number, display)
    vRP.addContact({identifier,display,number})
    notifyContactChange(source, identifier)
end

function updateContact(source, identifier, display, number, olddisplay)
    vRP.changeContact({identifier,display,number,olddisplay})
    notifyContactChange(source, identifier)
end

function deleteContact(source, identifier, display)
    vRP.removeContact({identifier,display})
    notifyContactChange(source, identifier)
end
function deleteAllContact(identifier)
    vRP.deleteAllContact({identifier})
end

function notifyContactChange(source, identifier)
    if source ~= nil then
        local user_id = vRP.getUserId({source})
        local contacts = getContacts(user_id)
        TriggerClientEvent("gcPhone:contactList", source, contacts)
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local lsource = source
    local user_id = vRP.getUserId({source})
    addContact(lsource, user_id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber, olddisplay)
    local lsource = source
    local user_id = vRP.getUserId({source})
    updateContact(lsource, user_id, display, phoneNumber, olddisplay)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local lsource = source
    local user_id = vRP.getUserId({source})
    deleteContact(lsource, user_id, id)
end)


--====================================================================================
--  Messages
--====================================================================================

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    _internalAddMessage(transmitter, receiver, message, owner, function(tomess)
        cb(tomess)
    end)
end)

function _internalAddMessage(transmitter, receiver, message, owner, cbr)
    local task = Task(cbr)
    RMySQL.query("vRP/gcphone_insertMessage", {transmitter = transmitter,receiver = receiver, message = message, isRead = owner, owner = owner}, function(rows, affected)
        if #rows > 0 then
            task({rows[1]})
        end
    end)
end

function addMessage(source, identifier, phone_number, message)
    vRP.getUserByPhone({phone_number, function(otherIdentifier)
        vRP.getUserIdentity({identifier, function(identity)
            if identity then
                local myPhone = identity.phone
                if otherIdentifier ~= nil then
                    _internalAddMessage(myPhone, phone_number, message, 0, function(tomess)
                        local osou = vRP.getUserSource({otherIdentifier})
                        if osou ~= nil then
                            TriggerClientEvent("gcPhone:receiveMessage", osou, tomess)
                        end
                    end)
                end
                _internalAddMessage(phone_number, myPhone, message, 1, function(memess)
                    TriggerClientEvent("gcPhone:receiveMessage", source, memess)
                end)
            end
        end})
    end})
end

function setReadMessageNumber(identifier, num)
    vRP.getUserIdentity({identifier, function(identity)
        if identity then
            local mePhoneNumber = identity.phone
            if num ~= nil and mePhoneNumber ~= nil then
                RMySQL.execute("vRP/gcphone_setRead", {receiver = mePhoneNumber, transmitter = num})
            end
        end
    end})
end


function deleteMessage(msgId)
    RMySQL.execute("vRP/gcphone_deleteMessage", {id = msgId})
end

function deleteAllMessageFromPhoneNumber(identifier, phone)
    vRP.getUserIdentity({identifier, function(identity)
        if identity then
            local mePhoneNumber = identity.phone
            RMySQL.execute("vRP/gcphone_deleteAllMessageFromPhoneNumber", {mePhoneNumber = mePhoneNumber, phone = phone})
        end
    end})
end


function deleteAllMessage(identifier)
    vRP.getUserIdentity({identifier, function(identity)
        if identity then
            local mePhoneNumber = identity.phone
            RMySQL.execute("vRP/gcphone_deleteAllMessage", {mePhoneNumber = mePhoneNumber})
        end
    end})
end
RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local lsource = source
    local user_id = vRP.getUserId({source})
    addMessage(lsource, user_id, phoneNumber, message)
end)
RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)


RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local lsource = source
    local user_id = vRP.getUserId({source})
    deleteAllMessageFromPhoneNumber(user_id, number)
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local lsource = source
    local user_id = vRP.getUserId({source})
    deleteAllMessage(user_id)
end)


RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local user_id = vRP.getUserId({source})
    setReadMessageNumber(user_id, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local source = source
    local user_id = vRP.getUserId({source})
    deleteAllMessage(user_id)
    deleteAllContact(user_id)
    appelsDeleteAllHistorique(user_id)
    TriggerClientEvent("gcPhone:contactList", source, {})
    TriggerClientEvent("gcPhone:allMessage", source, {})
    TriggerClientEvent("appelsDeleteAllHistorique", source, {})

end)
--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num, cbr)
    local task = Task(cbr)
    RMySQL.query("vRP/gcphone_getHistoriqueCall", {num = num}, function(rows, affected)
        if #rows > 0 then
            task({rows})
        end
    end)
end

function sendHistoriqueCall (src, num)
    getHistoriqueCall(num, function(histo)
        TriggerClientEvent('gcPhone:historiqueCall', src, histo)
    end)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        RMySQL.execute("vRP/gcphone_insertCall", {owner = appelInfo.transmitter_num, num = appelInfo.receiver_num, incoming = 1, accepts = appelInfo.is_accepts}, function(affected)
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "########"
        end
        RMySQL.execute("vRP/gcphone_insertCall", {owner = appelInfo.receiver_num, num = num, incoming = 0, accepts = appelInfo.is_accepts}, function(affected)
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num)
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end

    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local user_id = vRP.getUserId({source})
    vRP.getUserIdentity({user_id, function(identity)
        if identity then
            local srcPhone = identity.phone
            if extraData ~= nil and extraData.useNumber ~= nil then
                srcPhone = extraData.useNumber
            end
            vRP.getUserByPhone({phone_number, function(destPlayer)
                local is_valid = destPlayer ~= nil and destPlayer ~= user_id
                if is_valid == true then
                    AppelsEnCours[indexCall] = {
                        id = indexCall,
                        transmitter_src = source,
                        transmitter_num = srcPhone,
                        receiver_src = nil,
                        receiver_num = phone_number,
                        is_valid = destPlayer ~= nil,
                        is_accepts = false,
                        hidden = hidden,
                        rtcOffer = rtcOffer,
                        extraData = extraData
                    }

                    local srcTo = vRP.getUserSource({destPlayer})
                    if srcTo ~= nil then
                        AppelsEnCours[indexCall].receiver_src = srcTo
                        if checkIfInCall(srcTo) then
                            TriggerClientEvent("pNotify:SendNotification", source, {text = "<h3>📱 Telefonsvarer</h3> <br> <p>Nummeret er optaget</P>", type = "fejl", timeout = 9000, layout = "bottomright"})
                        else
                            if vRP.hasInventoryItem({destPlayer, "samsung"}) or vRP.hasInventoryItem({destPlayer, "iphone"}) or vRP.hasInventoryItem({destPlayer, "oneplus"}) then
                                TriggerClientEvent('gcPhone:waitingCall', source, AppelsEnCours[indexCall], true)
                                TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
                            else
                                TriggerClientEvent("pNotify:SendNotification", source, {text = "<h3>📱 Telefonsvarer</h3> <br> <p>Nummeret er optaget</P>", type = "fejl", timeout = 9000, layout = "bottomright"})
                            end
                        end
                    else
                        TriggerClientEvent('gcPhone:waitingCall', source, AppelsEnCours[indexCall], true)
                    end
                end
            end})
        end
    end})
end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then
            to = AppelsEnCours[callId].receiver_src
        end
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)


RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

function checkIfInCall(src)
    for k,v in pairs(AppelsEnCours) do
        if v.transmitter_src ~= nil and v.transmitter_src == src then
            if v.is_accepts == true then
                return true
            end
        elseif v.receiver_src ~= nil and v.receiver_src == src then
            if v.is_accepts == true then
                return true
            end
        end
    end
    return false
end

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local lsource = source
    local user_id = vRP.getUserId({source})

    vRP.getUserIdentity({user_id, function(identity)
        if identity then
            local mePhoneNumber = identity.phone
            RMySQL.execute("vRP/gcphone_deleteCallsFromNumber", {owner = mePhoneNumber, num = numero})
        end
    end})

end)

function appelsDeleteAllHistorique(srcIdentifier)
    vRP.getUserIdentity({srcIdentifier, function(identity)
        if identity then
            local mePhoneNumber = identity.phone
            RMySQL.execute("vRP/gcphone_deleteAllCalls", {owner = mePhoneNumber})
        end
    end})
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local lsource = source
    local user_id = vRP.getUserId({source})
    appelsDeleteAllHistorique(user_id)
end)

RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function(user_id, source)
    local lsource = source
    vRP.getUserIdentity({user_id, function(identity)
        if identity then
            local phone = identity.phone
            TriggerClientEvent("gcPhone:myPhoneNumber", lsource, phone)
            TriggerClientEvent("gcPhone:userid", lsource, user_id)
            local contacts = getContacts(user_id)
            TriggerClientEvent("gcPhone:contactList", lsource, contacts)
            RMySQL.query("vRP/gcphone_getMessages", {phone = phone}, function(rows, affected)
                if #rows > 0 then
                    TriggerClientEvent("gcPhone:allMessage", lsource, rows)
                end
            end)
            TriggerClientEvent("gcPhone:RefreshTwitter",lsource,tweets)
            --TriggerClientEvent('gcPhone:getBourse', lsource, getBourse())
            sendHistoriqueCall(lsource, phone)
            TriggerClientEvent("gcPhone:setBankMoney",source,vRP.getBankMoney({user_id}))
        end
    end})
end)

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    TriggerEvent("gcPhone:allUpdate", user_id,source)
end)

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    --  Format
    --  Array 
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution 
    -- 
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = vRP.getUserId({source})

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
        AppelsEnCours[indexCall] = {
            id = indexCall,
            transmitter_src = sourcePlayer,
            transmitter_num = srcPhone,
            receiver_src = nil,
            receiver_num = phone_number,
            is_valid = false,
            is_accepts = false,
            hidden = hidden,
            rtcOffer = rtcOffer,
            extraData = extraData,
            coords = FixePhone[phone_number].coords
        }

        PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    else
        vRP.getUserIdentity({srcIdentifier, function(identity)
            if identity then
                local srcPhone = identity.phone
                AppelsEnCours[indexCall] = {
                    id = indexCall,
                    transmitter_src = sourcePlayer,
                    transmitter_num = srcPhone,
                    receiver_src = nil,
                    receiver_num = phone_number,
                    is_valid = false,
                    is_accepts = false,
                    hidden = hidden,
                    rtcOffer = rtcOffer,
                    extraData = extraData,
                    coords = FixePhone[phone_number].coords
                }

                PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

                TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
                TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end})
    end
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id

    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil

end

AddEventHandler('onResourceStart', function(name)
    if name:lower() == GetCurrentResourceName():lower() then
        Wait(5000)
        RMySQL.query("vRP/gcphone_getTweets", {}, function(rows, affected)
            if #rows > 0 then
                tweets = json.encode(rows)
            end
        end)
    end
end)
