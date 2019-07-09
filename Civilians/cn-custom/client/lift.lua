--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 07-03-2019
-- Time: 14:20
-- Made for CiviliansNetwork
--

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local usedlift = {}

local lifts = {
    -1555905221,
    120509734,

}

RegisterNetEvent('cn-lift:load')
AddEventHandler('cn-lift:load', function(list)
    usedlift = list
end)

RegisterNetEvent('cn-lift:status')
AddEventHandler('cn-lift:status', function(key,veh)
    usedlift[key] = veh
end)

function Draw3DText(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
	local px, py, pz = table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 370
	DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 20,20,20,150)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local coords = GetEntityCoords(PlayerPedId(),true)
        for k,v in pairs(lifts) do
            local lift = GetClosestObjectOfType(coords["x"], coords["y"], coords["z"], 5.0, v, false, false, false)
            if lift ~= 0 then
                local lcoords = GetEntityCoords(lift, true)
                if usedlift[math.floor(lcoords["x"])] == nil then
                    DrawMarker(27, lcoords["x"]-2.5, lcoords["y"], lcoords["z"]+0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 83, 255, 87, 200, 0, 0, 0, 50)
                else
                    DrawMarker(27, lcoords["x"]-2.5, lcoords["y"], lcoords["z"]+0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 255, 25, 0, 200, 0, 0, 0, 50)
                end
                if (Vdist(coords["x"], coords["y"], coords["z"], lcoords["x"]-2.5, lcoords["y"], lcoords["z"]) < 1.2) then
                    if usedlift[math.floor(lcoords["x"])] == nil then
                        Draw3DText(lcoords["x"]-2.5, lcoords["y"], lcoords["z"]+1, "Tryk ~g~E~w~ For at hæve bilen")
                    else
                        Draw3DText(lcoords["x"]-2.5, lcoords["y"], lcoords["z"]+1, "Tryk ~r~E~w~ For at sænke bilen")
                    end
                    if IsControlJustPressed(1, Keys["E"]) then

                        if usedlift[math.floor(lcoords["x"])] == nil then
                            local veh = GetClosestVehicle(lcoords["x"]+0.0001,lcoords["y"]+0.0001,lcoords["z"]+0.0001, 1+0.0001, 0, 4+2+1)
                            if veh ~= 0 then
                                TriggerServerEvent('cn-lift:sendstatus',math.floor(lcoords["x"]),veh)
                                FreezeEntityPosition(veh,true)
                                local offset = 0.5
                                while offset < 2.65 do
                                    Citizen.Wait(25)
                                    offset=offset+0.0125
                                    SetEntityCoordsNoOffset(usedlift[math.floor(lcoords["x"])],lcoords["x"], lcoords["y"], lcoords["z"]+offset,true,true,true)
                                end
                                SetEntityCollision(veh,false,false)
                            else
                                TriggerEvent("pNotify:SendNotification",{text = "Der skal være et køretøj!",type = "error", timeout = (3000),layout = "centerLeft"})
                            end
                        else
                            FreezeEntityPosition(usedlift[math.floor(lcoords["x"])],false)
                            local offset = 2.65
                            while offset > 0.5 do
                                Citizen.Wait(25)
                                offset=offset-0.0125
                                SetEntityCoordsNoOffset(usedlift[math.floor(lcoords["x"])],lcoords["x"], lcoords["y"], lcoords["z"]+offset,true,true,true)
                            end
                            SetEntityCollision(usedlift[math.floor(lcoords["x"])],true,true)
                            TriggerServerEvent('cn-lift:sendstatus',math.floor(lcoords["x"]),nil)
                        end
                    end
                end
            end
        end
    end
end)
