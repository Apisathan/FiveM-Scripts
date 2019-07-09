--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 11-01-2019
-- Time: 20:22
-- Made for CiviliansNetwork
--
vRPsb = {}
vRP = Proxy.getInterface("vRP")
Proxy.addInterface("vrp_extended",vRPsb)
local userid = 0
local users = {}
local server = 0
local playerBlips = {}
local hasDrugs = false

RegisterNetEvent("vrp_extended:user")
AddEventHandler("vrp_extended:user", function(id)
    userid = id
end)

RegisterNetEvent("vrp_extended:server")
AddEventHandler("vrp_extended:server", function(s)
    server = s
end)

RegisterNetEvent("vrp_extended:inventory")
AddEventHandler("vrp_extended:inventory", function(user_id,inventory,weight)
    if user_id ~= nil then
        if inventory ~= nil and weight ~= nil then
            users[user_id].inventory = inventory
            users[user_id].weight = weight
        end
        if user_id == userid then
            for k,v in pairs(users[userid].inventory) do
                for k2,v2 in pairs(excfg.drugs) do
                    if k == k2 then
                        if v.amount ~= nil then hasDrugs = {item = k,amount = v.amount} end
                        break
                    end
                end
            end
            if weight > 30 then
                SetPedComponentVariation(GetPlayerPed(-1), 5, 41, 0, 0)
            else
                SetPedComponentVariation(GetPlayerPed(-1), 5, 0, 0, 0)
            end
        end
    end
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

local pedtypes = {0,1,2,20,4,5,26}
function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    if GetVehiclePedIsUsing(ped) ~= 0 then
        return false
    end
    for a = 0, 256 do
        if GetPlayerPed(a) == ped then
            return false
        end
    end
    local coords = GetEntityCoords(ped)
    for k,v in pairs(excfg.blacklist) do
        if tostring(coords["x"]) == tostring(v[1]) and tostring(coords["y"]) == tostring(v[2]) then
            return false
        end
    end
    for k,v in pairs(pedtypes) do
        if GetPedType(ped) == v then
            return true
        end
    end
end

function hasDrugInInventory()
    if users[userid] ~= nil then
        for k,v in pairs(users[userid].inventory) do
            for k2,v2 in pairs(excfg.drugs) do
                if k == k2 then
                    if v.amount ~= nil then hasDrugs = {item = k,amount = v.amount} end
                    break
                end
            end
        end
    end
end

local selling = false
local soldProps = {}
local soldToNPC = {}
local chance = 0
local closestPed = 0
local sellingPed = 0
local isStopped = false
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        if GetVehiclePedIsUsing(PlayerPedId()) == 0 and GetEntityHealth(PlayerPedId()) > 100 then
            if users[userid] ~= nil then
                if hasDrugs and users[userid].job == "Kriminel" then
                    if closestPed ~= 0 and selling == false then
                        local pos = GetEntityCoords(closestPed)
                        if IsControlJustPressed(0,184) and soldToNPC[closestPed] == nil then
                            soldToNPC[closestPed] = true
                            SetEntityAsMissionEntity(closestPed)
                            ClearPedTasks(closestPed)
                            chance = math.random(1, 10)
                            selling = true
                            sellingPed = closestPed
                            if chance == 5 then
                                -- Ring til politiet
                                TaskStartScenarioInPlace(closestPed, "WORLD_HUMAN_STAND_IMPATIENT")
                                Wait(7500)
                                ClearPedTasks(closestPed)
                                TaskStartScenarioInPlace(closestPed, "WORLD_HUMAN_STAND_MOBILE")
                                TriggerServerEvent('dispatchpolice',pos["x"],pos["y"],pos["z"],"Der en der prøver og sælge stoffer til mig på "..GetStreetName(pos).."!")
                                selling = false
                            elseif chance >= 8 then
                                -- Vil ikke købe
                                TaskStartScenarioInPlace(closestPed, "WORLD_HUMAN_STAND_IMPATIENT")
                                selling = false
                            else
                                -- Køber
                                local lpos = GetEntityCoords(PlayerPedId())
                                FreezeEntityPosition(closestPed,true)
                                loadAnimDict("mp_common")
                                Wait(500)
                                local money = ""
                                if isStopped == false then
                                    if hasDrugs.item == "amfetamin" then
                                        money = CreateObject(GetHashKey(excfg.cashprophigh), lpos["x"],lpos["y"],lpos["z"], 0, 1, 1)
                                    else
                                        money = CreateObject(GetHashKey(excfg.cashprop), lpos["x"],lpos["y"],lpos["z"], 0, 1, 1)
                                    end
                                    AttachEntityToEntity(money, closestPed, GetPedBoneIndex(closestPed, 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
                                end
                                Wait(1000)
                                if isStopped == false then TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0) end
                                Wait(400)
                                if isStopped == false then TaskPlayAnim(closestPed,"mp_common","givetake1_b",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0) end
                                Wait(800)
                                if isStopped == false then
                                    DetachEntity(money)
                                    AttachEntityToEntity(money, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
                                end
                                Wait(800)
                                if money ~= "" then
                                    DeleteEntity(money)
                                end
                                Wait(200)
                                local propspawned = ""
                                if isStopped == false then
                                    propspawned = CreateObject(GetHashKey(excfg.drugs[hasDrugs.item].prop), lpos["x"],lpos["y"],lpos["z"], 0, 1, 1)
                                    AttachEntityToEntity(propspawned, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
                                    soldProps[propspawned] = 1200
                                end
                                Wait(1000)
                                if isStopped == false then TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0) end
                                Wait(200)
                                if isStopped == false then TaskPlayAnim(closestPed,"mp_common","givetake1_b",100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0) end
                                Wait(800)
                                if isStopped == false then
                                    DetachEntity(propspawned)
                                    AttachEntityToEntity(propspawned, closestPed, GetPedBoneIndex(closestPed, 28422), 0.0, -0.05, -0.05, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0)
                                    TriggerServerEvent("vrp_extended:selltonpc",hasDrugs)
                                    isStopped = true
                                elseif propspawned ~= "" then
                                    DeleteObject(propspawned)
                                    soldProps[propspawned] = nil
                                end
                                Wait(5000)
                                isStopped = false
                                selling = false
                            end
                        elseif soldToNPC[closestPed] == nil then
                            DrawText3Ds(pos["x"],pos["y"],pos["z"], "Tryk ~g~E~w~ for at sælge "..hasDrugs.item)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(200)
        local sdistance = 3
        local tempped = 0
        if selling == false then
            for ped in EnumeratePeds() do
                if GetEntityHealth(ped) ~= 0 then
                    local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
                    if distanceCheck <= 2.0 then
                        if sdistance > distanceCheck then
                            if canPedBeUsed(ped) then
                                tempped = ped
                                closestPed = ped
                                sdistance = distanceCheck
                            end
                        end
                    end
                end
            end
            if tempped == 0 and closestPed ~= 0 then closestPed = 0 end
        else
            local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(closestPed), true)
            if distanceCheck > 5.0 and isStopped == false then
                isStopped = true
                TriggerEvent("pNotify:SendNotification",{text = "Handling afbrudt du gik forlangt væk!",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
    end
end)

local array = {}
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(soldProps) do
            soldProps[k] = soldProps[k]-1
            if soldProps[k] == 0 then
                soldProps[k] = nil
                DeleteEntity(k)
            end
        end
    end
end)

function putInNearestVehicleAsPassenger(veh,ped)
    if IsEntityAVehicle(veh) then
        max = (GetVehicleMaxNumberOfPassengers(veh) > 2) and 2 or GetVehicleMaxNumberOfPassengers(veh)
        while max > -1 do
            if IsVehicleSeatFree(veh,max) then
                SetPedIntoVehicle(ped,veh,max)
                return true
            end
            max = max-1
        end
    end
    return false
end

local timer = 0
Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        if sellingPed ~= 0 then
            timer = timer+1
            local pos = GetEntityCoords(sellingPed)
            if chance == 5 then
                -- Ring til politiet
                DrawText3Ds(pos["x"],pos["y"],pos["z"], "Vil ikke købe")
            elseif chance >= 8 then
                -- Vil ikke købe
                DrawText3Ds(pos["x"],pos["y"],pos["z"], "Vil ikke købe")
            else
                -- Køber
                DrawText3Ds(pos["x"],pos["y"],pos["z"], "Sælger")
            end
            if timer > 500 then
                soldToNPC[sellingPed] = false
                SetEntityAsMissionEntity(sellingPed)
                SetPedAsNoLongerNeeded(sellingPed)
                sellingPed = 0
                timer = 0
            end
        end
    end
end)
local isEmergency = false
RegisterNetEvent("vrp_extended:updateusers")
AddEventHandler("vrp_extended:updateusers", function(tusers)
    if tusers ~= nil then
        users = tusers
        for k,v in pairs(users) do
            if k == userid then
                if checkEmergency(v.job) then isEmergency = true else isEmergency = false end
                hasDrugInInventory()
            end
        end
    end
end)

RegisterNetEvent("vrp_extended:removeuser")
AddEventHandler("vrp_extended:removeuser", function(user_id)
    if user_id ~= nil then
        users[user_id] = nil
    end
end)

local emergencyjobs = {
    "Rigspolitichef",
    "Vice Rigspolitichef",
    "Politidirektør",
    "Vice Politidirektør",
    "Politiinspektør",
    "Vice Politiinspektør",
    "Politikommisær",
    "Politiassistent Første Grad",
    "Politiassistent",
    "Politibetjent",
    "Politielev",
    "Regionschef",
    "Læge",
    "Paramediciner",
    "Ambulanceredder",
    "Ambulanceelev",
}

local policejobs = {
    "Rigspolitichef",
    "Vice Rigspolitichef",
    "Politidirektør",
    "Vice Politidirektør",
    "Politiinspektør",
    "Vice Politiinspektør",
    "Politikommisær",
    "Politiassistent Første Grad",
    "Politiassistent",
    "Politibetjent",
    "Politielev"
}

function checkEmergency(job)
    for k,v in pairs(emergencyjobs) do
        if v == job then
            return true
        end
    end
    return false
end

function checkPolice(job)
    for k,v in pairs(policejobs) do
        if v == job then
            return true
        end
    end
    return false
end


function vRPsb.getServerNumber()
    return server
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
    return checkEmergency(job)
end
function vRPsb.checkPolice(job)
    return checkPolice(job)
end

function vRPsb.isEmergency()
    return isEmergency
end

function vRPsb.isPolice()
    return checkPolice(users[tonumber(userid)].job)
end

function vRPsb.getUserFromSource(source)
    return getUserFromSource(source)
end

function getUserFromSource(source)
    for k, v in pairs(users) do
        if source == GetPlayerFromServerId(v.source) then
            return users[k]
        end
    end
    return false
end

function vRPsb.getAmountOnline(group)
    local ems = 0
    local mechanic = 0
    local taxa = 0
    local advokat = 0
    local politi = 0
    local bilforhandler = 0
    local realestate = 0
    local journalist = 0
    local psykolog = 0
    local online = 0
    for k, v in pairs(users) do
        if k ~= nil and v.source ~= nil and v.name ~= nil and NetworkIsPlayerActive(GetPlayerFromServerId(v.source)) then
            online = online+1
            if v.job == "Ambulanceelev" or v.job == "Ambulanceredder" or v.job == "Paramediciner" or v.job == "Læge" or v.job == "Regionschef" then
                ems = ems+1
            elseif v.job == "Mekaniker Domingo" or v.job == "Mekaniker Civilians" or v.job == "Mekaniker Chef" then
                mechanic = mechanic+1
            elseif v.job == "Politielev" or v.job == "Politibetjent" or v.job == "Politiassistent" or v.job == "Politiassitent Første Grad" or v.job == "Politikommisær" or v.job == "Vice Politiinspektør" or v.job == "Politiinspektør" or v.job == "Vice Politidirektør" or v.job == "Politidirektør" or v.job == "Vice Rigspolitichef" or v.job == "Rigspolitichef" then
                politi = politi+1
            elseif v.job == "Bilforhandler" or v.job == "Bilforhandler Chef" then
                bilforhandler = bilforhandler+1
            elseif v.job == "Journalist" or v.job == "Journalist Chef" then
                journalist = journalist+1
            elseif v.job == "Ejendomsmægler" or v.job == "Ejendomsmægler Chef" then
                realestate = realestate+1
            elseif v.job == "Taxi" then
                taxa = taxa+1
            elseif v.job == "Advokat" or v.job == "Advokat Chef" or v.job == "Politiadvokat" or v.job == "Politiadvokat Chef" then
                advokat = advokat+1
            elseif v.job == "Psykolog" or v.job == "Psykolog Chef" then
                psykolog = psykolog+1
            end
        end
    end
    if group == "ems" then return ems end
    if group == "realestate" then return realestate end
    if group == "journalist" then return journalist end
    if group == "bilforhandler" then return bilforhandler end
    if group == "mechanic" then return mechanic end
    if group == "taxa" then return taxa end
    if group == "advokat" then return advokat end
    if group == "politi" then return politi end
    if group == "psykolog" then return psykolog end
    if group == "all" then return {ems=ems,realestate=realestate,journalist=journalist,bilforhandler=bilforhandler,mechanic=mechanic,taxa=taxa,advokat=advokat,politi=politi,psykolog=psykolog,online=online} end
end

function updatePlayerBlip(id,ped,idtype,idcolor,text)
    if not DoesBlipExist(playerBlips[id]) then
        playerBlips[id] = AddBlipForEntity(ped)
        SetBlipSprite(playerBlips[id], idtype)
        SetBlipAsShortRange(playerBlips[id], true)
        SetBlipColour(playerBlips[id],idcolor)
        SetBlipScale(playerBlips[id],0.8)
        if text ~= nil and text ~= '' then
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(text)
            EndTextCommandSetBlipName(playerBlips[id])
        end
    end
end

function DrawID(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Change this
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k, v in pairs(users) do
            if v.source ~= nil and NetworkIsPlayerActive(GetPlayerFromServerId(v.source)) then
                if IsControlPressed(0, 173) then
                    x1, y1, z1 = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
                    x2, y2, z2 = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(v.source)), true))
                    distance = math.floor(GetDistanceBetweenCoords(x1,y1,z1,x2,y2,z2, true))
                    if distance < 8 and GetPlayerPed(-1) ~= GetPlayerPed(GetPlayerFromServerId(v.source)) and IsEntityVisible(GetPlayerPed(GetPlayerFromServerId(v.source)))then
                        local player = getUserFromSource(GetPlayerFromServerId(v.source))
                        if player ~= false then
                            if player.job ~= "Våbendealer" then
                                DrawID(x2, y2, z2+1, k)
                            end
                        end
                    end
                end
                if isEmergency then
                    if GetPlayerPed(-1) ~= GetPlayerPed(GetPlayerFromServerId(v.source)) then
                        if v.job == "Rigspolitichef" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,63,"Rigspolitichef")
                        elseif v.job == "Vice Rigspolitichef" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,63,"Vice Rigspolitichef")
                        elseif v.job == "Politidirektør" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,63,"Politidirektør")
                        elseif v.job == "Vice Politidirektør" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,63,"Vice Politidirektør")
                        elseif v.job == "Politiinspektør" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,38,"Politiinspektør")
                        elseif v.job == "Vice Politiinspektør" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,38,"Vice Politiinspektør")
                        elseif v.job == "Politikommisær" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,38,"Politikommisær")
                        elseif v.job == "Politiassistent Første Grad" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,42,"Politiassistent Første Grad")
                        elseif v.job == "Politiassistent" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,42,"Politiassistent")
                        elseif v.job == "Politibetjent" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,42,"Politibetjent")
                        elseif v.job == "Politielev" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,26,"Politielev")
                            -- EMS
                        elseif v.job == "Regionschef" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,58,"Regionschef")
                        elseif v.job == "Læge" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,50,"Læge")
                        elseif v.job == "Paramediciner" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,27,"Paramediciner")
                        elseif v.job == "Ambulanceredder" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,61,"Ambulanceredder")
                        elseif v.job == "Ambulanceelev" then
                            updatePlayerBlip(k,GetPlayerPed(GetPlayerFromServerId(v.source)),1,48,"Ambulanceelev")
                        else
                            if DoesBlipExist(playerBlips[k]) then RemoveBlip(playerBlips[k]) end
                            playerBlips[k] = nil
                        end
                    end
                else
                    if DoesBlipExist(playerBlips[k]) then RemoveBlip(playerBlips[k]) end
                    playerBlips[k] = nil
                end
            else
                if DoesBlipExist(playerBlips[k]) then RemoveBlip(playerBlips[k]) end
                playerBlips[k] = nil
            end
        end
    end
end)

local offonduty = {}
RegisterNetEvent('vrp_extended:offonduty')
AddEventHandler('vrp_extended:offonduty', function(list)
    offonduty = list
end)

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)

    text = string.gsub(text, "^.", string.upper)

    if onScreen then
        SetTextScale(0.40, 0.40)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0150, 0.035+ factor, 0.04, 0, 0, 0, 80)
    end
end

local delay = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if delay ~= 0 then delay = delay-1 end
        local ped = GetPlayerPed(-1)
        if GetEntityHealth(ped) > 100 then
            for _, duty in pairs(offonduty) do
                if GetDistanceBetweenCoords(GetEntityCoords(ped), duty.coords[1], duty.coords[2], duty.coords[3], true ) < 20 then
                    DrawMarker(27, duty.coords[1], duty.coords[2], duty.coords[3], 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 0, 155, 255, 200, 0, 0, 0, 50)
                    if GetDistanceBetweenCoords(GetEntityCoords(ped), duty.coords[1], duty.coords[2], duty.coords[3], true ) < 1.25 then
                        if IsControlJustReleased(1, 86) then
                            if delay == 0 then
                                TriggerServerEvent("vrp_extended:duty",_)
                                delay = tonumber(500)
                            else
                                TriggerEvent("pNotify:SendNotification",{
                                    text = "Du skal vente lidt med at skifte job!",
                                    type = "error",
                                    timeout = 3000,
                                    layout = "bottomCenter",
                                    queue = "global",
                                    animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                                })
                            end
                        end
                        if duty.type then
                            local job = users[tonumber(userid)].job
                            if job == "Mekaniker Civilians" or job == "Mekaniker Domingo" or job == "Mekaniker Chef" or job == "Våbendealer" or job == "Journalist" or job == "Journalist Chef" or job == "Bilforhandler" or job == "Bilforhandler Chef" or job == "Ejendomsmægler" or job == "Ejendomsmægler Chef" or job == "Advokat" or job == "Advokat Chef" or job == "Psykolog" or job == "Psykolog Chef" or job == "Sikkerhedsvagt" or job == "Sikkerhedsvagt Chef" then
                                DrawText3D(duty.coords[1], duty.coords[2], duty.coords[3]+1, "~r~E~w~ For at gå af job")
                            else
                                DrawText3D(duty.coords[1], duty.coords[2], duty.coords[3]+1, "~g~E~w~ For at gå på job")
                            end
                        else
                            if isEmergency then
                                DrawText3D(duty.coords[1], duty.coords[2], duty.coords[3]+1, "~r~E~w~ For at gå af job")
                            else
                                DrawText3D(duty.coords[1], duty.coords[2], duty.coords[3]+1, "~g~E~w~ For at gå på job")
                            end
                        end
                    end

                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

local showmarker = true
RegisterCommand("cirkel", function(source, args, rawCommand)
    showmarker = not showmarker
    local text = "Voice cirkler er slået <b style='color: #4E9350'>til</b>"
    if showmarker == false then
        text = "Voice cirkler er slået <b style='color: #DB4646'>fra</b>"
    end
    TriggerEvent("pNotify:SendNotification",{
        text = text,
        type = "success",
        timeout = (3000),
        layout = "centerLeft",
        queue = "global",
        animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
        killer = true
    })
end)

local playerNamesDist = 10
Citizen.CreateThread(function()
    while true do
        for id = 0, 255 do
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
                ped = GetPlayerPed( id )
                x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
                local takeaway = 0.95
                if ((distance < playerNamesDist) and IsEntityVisible(GetPlayerPed(id))) ~= GetPlayerPed( -1 ) then
                    if NetworkIsPlayerTalking(id) then
                        local player = getUserFromSource(id)
                        if player ~= false then
                            if showmarker then
                                if player.vip then
                                    DrawMarker(27,x2,y2,z2 - takeaway, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 200, 0, 105, 0, 0, 0, 50)
                                else
                                    DrawMarker(27,x2,y2,z2 - takeaway, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 91, 202, 242, 105, 0, 0, 0, 50)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
end)

function GetStreetName(playerPos)
    local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, playerPos.x, playerPos.y, playerPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)

    if s2 == 0 then
        return street1
    elseif s2 ~= 0 then
        return street1 .. " - " .. street2
    end
end
