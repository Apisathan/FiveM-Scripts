--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-03-2019
-- Time: 20:27
-- Made for CiviliansNetwork
--

vRPex = Proxy.getInterface("vrp_extended")

local vhash = GetHashKey("burrito3")
local fotovogne = {}
local defaults = {}
local zones = {
    [1] = 50,
    [2] = 80,
    [3] = 130
}

RegisterNetEvent("cn-fotovogn:sendvogn")
AddEventHandler("cn-fotovogn:sendvogn", function(list)
    fotovogne=list
end)

RegisterNetEvent("cn-fotovogn:createdefault")
AddEventHandler("cn-fotovogn:createdefault", function(list,current)
    for _, item in pairs(list) do
        RequestModel(vhash);
        while not HasModelLoaded(vhash) do
            RequestModel(vhash);
            Wait(1)
        end
        local vehicle = CreateVehicle(vhash, item.coords[1], item.coords[2], item.coords[3], item.coords[4], false, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        FreezeEntityPosition(vehicle,true)
        PlaceObjectOnGroundProperly(vehicle)
        SetVehicleDoorsLocked(vehicle,2)
        table.insert(defaults,{vehcoords = item.coords, coords=item.data.coords,turned=item.data.turned,limit=item.data.limit,radius=item.data.radius})
    end
    fotovogne = current
end)

RegisterNetEvent("cn-fotovogn:sendalert")
AddEventHandler("cn-fotovogn:sendalert", function(veh,tax,speed)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if VehToNet(vehicle) == veh then
        TriggerEvent("pNotify:SendNotification",{text = "<b style='color: #4E9350'>"..GetVehicleNumberPlateText(vveh).."</b> fik en bøde på <b style='color: #4E9350'>"..tax.."</b> DKK for at kører <b style='color: #4E9350'>"..speed.."</b>",type = "error",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
        if GetEntityModel(veh) == vhash then
            if vRPex.isPolice() then
                if NetworkGetEntityIsNetworked(veh) ~= false then
                    SetVehicleDoorsLocked(veh,1)
                end
            else
                SetVehicleDoorsLocked(veh,2)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(fotovogne) do
            if Vdist(v.coords[1], v.coords[2], v.coords[3], coords["x"], coords["y"], coords["z"]) < v.radius then
                checkSpeed(zones[v.limit],true)
                break
            end
        end
        for k,v in pairs(defaults) do
            if Vdist(v.coords[1], v.coords[2], v.coords[3], coords["x"], coords["y"], coords["z"]) < v.radius then
                checkSpeed(zones[v.limit],false)
                break
            end
        end
    end
end)

function checkSpeed(limit,net)
    local pP = GetPlayerPed(-1)
    local speed = GetEntitySpeed(pP)
    local vehicle = GetVehiclePedIsIn(pP, false)
    if GetVehicleClass(vehicle) == 18 or IsEntityVisible(PlayerPedId()) == false then
        return false
    end
    local coords = GetEntityCoords(PlayerPedId())
    local check = GetClosestVehicle(coords["x"]+0.0001,coords["y"]+0.0001,coords["z"]+0.0001, 30+0.0001, vhash, 4+2+1)
    if check ~= 0 then
        local driver = GetPedInVehicleSeat(vehicle, -1)
        local kmhspeed = math.ceil(speed*3.6)
        if kmhspeed > limit+4 and driver == pP then
            StartScreenEffect("DeathFailMPDark", 100, 0)
            TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "fartfaelde", 0.8)
            exports.pNotify:SetQueueMax("fart", 1)
            TriggerServerEvent('cn-fotovogn:betal',kmhspeed,limit,((net) and VehToNet(vehicle) or false))
        end
        Wait(3000)
    end
end

local xoffset,yoffset = 0,0
local radius = 11
local fart = 1
local isEditing = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local inVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        if inVeh ~= 0 and GetEntityModel(inVeh) == vhash then
            if fotovogne[VehToNet(inVeh)] ~= nil then
                if GetEntitySpeed(inVeh) > 1 then
                    TriggerServerEvent("cn-fotovogn:removevogn",VehToNet(inVeh))
                end
            end
            if GetEntitySpeed(inVeh) < 1 then
                if isEditing then
                    if xoffset == coords["x"] and yoffset == coords["y"] then
                        DisplayHelpText("Brug piltasterne til og ændrer kameraet")
                    else
                        if fotovogne[VehToNet(inVeh)] == nil then
                            DisplayHelpText("Tryk ~INPUT_CELLPHONE_SELECT~ for at tænde kameraet")
                        else
                            DisplayHelpText("Tryk ~INPUT_CELLPHONE_SELECT~ for at slukke kameraet")
                        end
                    end
                    if fotovogne[VehToNet(inVeh)] == nil then
                        if xoffset == 0 or yoffset == 0 then
                            xoffset = coords["x"]
                            yoffset = coords["y"]
                        end
                        if IsControlPressed(0,20) then
                            xoffset = coords["x"]
                            yoffset = coords["y"]
                        end
                        if IsControlPressed(0,172) then
                            xoffset = xoffset+0.2
                        end
                        if IsControlPressed(0,173) then
                            xoffset = xoffset-0.2
                        end
                        if IsControlPressed(0,174) then
                            yoffset = yoffset+0.2
                        end
                        if IsControlPressed(0,175) then
                            yoffset = yoffset-0.2
                        end
                        if IsControlPressed(0,314) then
                            if radius < 20 then
                                radius = radius+0.1
                            end
                        end
                        if IsControlPressed(0,315) then
                            if radius > 5 then
                                radius = radius-0.1
                            end
                        end
                        if IsControlJustPressed(0,29) then
                            if fart < 3 then
                                fart = fart+1
                            else
                                fart = 1
                            end
                        end
                        ply_drawTxt("Tryk ~g~Z~w~ nulstille kamera retning",4,1,0.5,0.89,0.5,255,255,255,255)
                        ply_drawTxt("Tryk ~g~B~w~ for at skift grænse",4,1,0.5,0.925,0.5,255,255,255,255)
                        ply_drawTxt("Tryk ~g~+/-~w~ for at ændre radius",4,1,0.65,0.925,0.5,255,255,255,255)
                        ply_drawTxt("Grænse sat til: ~g~"..zones[fart],4,1,0.5,0.96,0.5,255,255,255,255)
                        if Vdist(coords["x"],coords["y"],coords["z"], xoffset,yoffset,coords["z"]) < 30.0 then
                            DrawMarker(1, xoffset,yoffset,coords["z"]-1,0,0,0,0,0,0,radius+0.0001,radius+0.0001,4.0001, 0, 232, 255,200,0,0,0,50)
                        else
                            DrawMarker(1, xoffset,yoffset,coords["z"]-1,0,0,0,0,0,0,radius+0.0001,radius+0.0001,4.0001, 255,0,0,200,0,0,0,50)
                        end
                    else
                        xoffset = fotovogne[VehToNet(inVeh)].coords[1]
                        yoffset = fotovogne[VehToNet(inVeh)].coords[2]
                        radius = fotovogne[VehToNet(inVeh)].radius
                        fart = fotovogne[VehToNet(inVeh)].limit
                    end
                    if IsControlJustPressed(0,176) then
                        if fotovogne[VehToNet(inVeh)] == nil then
                            if Vdist(coords["x"],coords["y"],coords["z"], xoffset,yoffset,coords["z"]) < 30.0 then
                                TriggerEvent("pNotify:SendNotification",{text = "Kamera tænd, hastighedsgrænse sat til "..zones[fart],type = "error",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
                                TriggerServerEvent("cn-fotovogn:sendvogn",VehToNet(inVeh),{coords={xoffset,yoffset,coords["z"]},turned=true,limit=fart,radius=radius})
                            else
                                TriggerEvent("pNotify:SendNotification",{text = "Pilen er for langt væk fra køretøjet",type = "error",timeout = (5000),layout = "bottomCenter",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
                            end
                        else
                            TriggerServerEvent("cn-fotovogn:removevogn",VehToNet(inVeh))
                        end
                    end
                else
                    ply_drawTxt("Tryk ~g~B~w~ slå kamera indstillinger til",4,1,0.5,0.925,0.6,255,255,255,255)
                    if IsControlPressed(0,29) then
                        isEditing = true
                    end
                end
            else
                isEditing = false
                xoffset = coords["x"]
                yoffset = coords["y"]
            end
        else
            if xoffset ~= 0 and yoffset ~= 0 then
                xoffset = 0
                yoffset = 0
            end
        end
    end
end)

Citizen.CreateThread(function()
    TriggerServerEvent("qweqweqewqwqeqweeqwqewqewqeweqwqewqweqeqewewq")
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end
