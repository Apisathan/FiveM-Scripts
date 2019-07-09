--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 02-02-2019
-- Time: 19:17
-- Made for CiviliansNetwork
--
local LockHotkey = {0,38}
local doors = {}

RegisterNetEvent('vrp_doors:load')
AddEventHandler('vrp_doors:load', function(list)
    doors = list
end)

RegisterNetEvent('vrp_doors:statusSend')
AddEventHandler('vrp_doors:statusSend', function(id,status)
    doors[id].locked = status
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())

    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 0, 0, 0, 80)
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId(),true)
        for k,v in pairs(doors) do
            local lradius = (v.range ~= nil and v.range or 2.0)
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords[1], v.coords[2], v.coords[3], true) <= lradius then
                local closeDoor = GetClosestObjectOfType(v.coords[1], v.coords[2], v.coords[3], lradius, v.hash, false, false, false)
                if closeDoor ~= 0 then
                    if v.locked then
                        DrawText3Ds(v.coords[1], v.coords[2], v.coords[3], "Tryk ~g~E~w~ for at låse op")
                        local locked, heading = GetStateOfClosestDoorOfType(v.hash, v.coords[1], v.coords[2], v.coords[3], v.locked, 0)
                        if heading > -0.01 and heading < 0.01 then
                            FreezeEntityPosition(closeDoor, v.locked)
                        end
                    else
                        DrawText3Ds(v.coords[1], v.coords[2], v.coords[3], "Tryk ~r~E~w~ for at låse")
                        FreezeEntityPosition(closeDoor, v.locked)
                    end
                    if IsControlJustReleased(table.unpack(LockHotkey)) then
                        toggleClosestDoor()
                    end
                end
            end
        end
    end
end)

function toggleClosestDoor()
    local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    for k,v in pairs(doors) do
        if v.close ~= nil then
            local door1 = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords[1], v.coords[2], v.coords[3], true )
            local lradius = (v.range ~= nil and v.range or 2.0)
            if door1 < lradius then
                if door1 < GetDistanceBetweenCoords(x,y,z,doors[v.close].coords[1], doors[v.close].coords[2], doors[v.close].coords[3],true) then
                    TriggerServerEvent("vrp_doors:status", k, not v.locked)
                else
                    TriggerServerEvent("vrp_doors:status", v.close, not doors[v.close].locked)
                end
                break
            end
        else
            local lradius = (v.range ~= nil and v.range or 2.0)
            if GetDistanceBetweenCoords(x,y,z,v.coords[1], v.coords[2], v.coords[3],true) <= lradius then
                TriggerServerEvent("vrp_doors:status", k, not v.locked)
            end
        end
    end
end

--[[Citizen.CreateThread(function()
    TriggerServerEvent("qwheqwihqeoiq")
end)]]

local blockeddoors = {
    --Michael house
    {hash = -1686014385, coords = {-816.29418945313,178.31407165527,72.222496032715}},
    {hash = 159994461, coords = {-816.29418945313,178.31407165527,72.222496032715}},
    {hash = -607040053, coords = {-1150.2520751953,-1521.5427246094,10.632718086243}},
    {hash = -1278729253, coords = {119.36336517334,563.58813476563,183.96928405762}},
    {hash = -1516927114, coords = {345.88305664063,440.28274536133,148.0906829834}},
    --Hudilihud
    {hash = 736699661, coords = {1397.1640625,1164.0338134766,114.33365631104}},
}

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(2000)
        for k,v in pairs(blockeddoors) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), v.coords[1],v.coords[2],v.coords[3], true) < 5 then
                local closeDoor = GetClosestObjectOfType(v.coords[1],v.coords[2],v.coords[3], 1.0, v.hash, false, false, false)
                FreezeEntityPosition(closeDoor, true)
            end
        end
    end
end)
