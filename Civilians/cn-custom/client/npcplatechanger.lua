--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 10-03-2019
-- Time: 20:02
-- Made for CiviliansNetwork
--

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(200)
        for vehicle in EnumerateVehicles() do
            if vehicle ~= 0 then
                local plate = GetVehicleNumberPlateText(vehicle)
                if plate ~= nil then
                    if string.sub(plate, 0, 2) ~= "P " and plate ~= "CIVILIAN" then
                        Citizen.Wait(20)
                        SetVehicleNumberPlateText(vehicle,"P "..randomPlate("DLDLDL"))
                    end
                end
            end
        end
    end
end)

function randomPlate(format) -- (ex: DDDLLL, D => digit, L => letter)
    local abyte = string.byte("A")
    local zbyte = string.byte("0")

    local number = ""
    for i=1,#format do
        local char = string.sub(format, i,i)
        if char == "D" then number = number..string.char(zbyte+math.random(0,9))
        elseif char == "L" then number = number..string.char(abyte+math.random(0,25))
        else number = number..char end
    end

    return number
end