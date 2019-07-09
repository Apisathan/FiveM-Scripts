--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 12-04-2019
-- Time: 13:04
-- Made for CiviliansNetwork
--

local frontwindowup = true
local backwindowup = true

RegisterNetEvent("rollcarwindows")
AddEventHandler('rollcarwindows', function(veh,bool,front)
    veh = NetToVeh(veh)
    print(veh)
    local firstwindow = 2
    local secondwindow = 3
    if front then
        firstwindow = 0
        secondwindow = 1
    end
    if (bool) then
        RollDownWindow(veh,firstwindow)
        RollDownWindow(veh,secondwindow)
    else
        print("weq")
        RollUpWindow(veh, firstwindow)
        RollUpWindow(veh, secondwindow)
    end
end)


RegisterCommand("rul", function()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
        if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
            TriggerServerEvent("rollcarwindows",VehToNet(playerCar),frontwindowup,true)
            frontwindowup = not frontwindowup
        end
    else
        TriggerEvent('chatMessage', "Fejl", {255, 0, 0}, "Du skal sidde i et køretøj!")
    end
end)
RegisterCommand("rulbag", function()
    if IsPedInAnyVehicle(PlayerPedId(),false) then
        local playerCar = GetVehiclePedIsIn(PlayerPedId(),false)
        if (GetPedInVehicleSeat( playerCar,-1) == PlayerPedId()) then
            TriggerServerEvent("rollcarwindows",VehToNet(playerCar),backwindowup,false)
            backwindowup = not backwindowup
        end
    else
        TriggerEvent('chatMessage', "Fejl", {255, 0, 0}, "Du skal sidde i et køretøj!")
    end
end)