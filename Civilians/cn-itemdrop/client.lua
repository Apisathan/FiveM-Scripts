--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 12-03-2019
-- Time: 16:43
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


local props = {
    ["wbody|WEAPON_PISTOL"]={prop='w_pi_pistol', rot=90.0},
    ["wbody|WEAPON_SNSPISTOL"]={prop='w_pi_sns_pistol', rot=90.0},
    ["wbody|WEAPON_HEAVYPISTOL"]={prop='w_pi_heavypistol', rot=90.0},
    ["wbody|WEAPON_PISTOL50"]={prop='w_pi_pistol50', rot=90.0},

    ["wbody|WEAPON_BAT"]={prop='w_me_bat', rot=90.0},
    ["wbody|WEAPON_KNIFE"]={prop='w_me_knife_01', rot=90.0},
    ["wbody|WEAPON_SWITCHBLADE"]={prop='w_me_knife_01', rot=90.0},
    ["wbody|WEAPON_CROWBAR"]={prop='w_me_crowbar', rot=90.0},
    ["wbody|WEAPON_GOLFCLUB"]={prop='w_me_gclub', rot=90.0},
    ["wbody|WEAPON_HAMMER"]={prop='w_me_hammer', rot=90.0},
    ["wbody|WEAPON_WRENCH"]={prop='prop_tool_wrench', rot=90.0},
    ["wbody|WEAPON_FLASHLIGHT"]={prop='w_at_ar_supp_02', rot=90.0},
    ["wbody|WEAPON_POOLCUE"]={prop='prop_pool_cue', rot=90.0},
    ["wbody|WEAPON_PETROLCAN"]={prop='w_am_jerrycan', rot=90.0},
    ["wbody|WEAPON_BALL"]={prop='prop_tennis_ball', rot=90.0},
    ["wbody|WEAPON_BATTLEAXE"]={prop='prop_ld_fireaxe', rot=90.0},

    ["blackmarketmobil"]={prop='prop_v_m_phone_01', rot=-90.0},

    ["hampblade"]={prop='hei_prop_heist_weed_block_01b', rot=0.0},
    ["skunk"]={prop='prop_weed_block_01', rot=0.0},

    ["amfetamin"]={prop='prop_mp_drug_package', rot=0.0},

    ["kokainblade"]={prop='prop_coke_block_half_b', rot=90.0},
    ["kokain"]={prop='prop_coke_block_01', rot=90.0},

    ["syre"]={prop='prop_drug_bottle', rot=90.0},
    ["lsd"]={prop='prop_mp_drug_package', rot=90.0},

    ["dirty_money"]={prop='prop_cash_case_01', rot=0.0,size={[1]='prop_anim_cash_note_b',[10000]='prop_anim_cash_pile_01',[50000]="prop_anim_cash_pile_02",[100000]='prop_cash_case_01'}},
    ["default"]={prop='prop_med_bag_01b', rot=0.0}
}

local bags = {}

RegisterNetEvent('cn-itemdrop:load')
AddEventHandler('cn-itemdrop:load', function(list)
    bags = list
    for k,v in pairs(list) do
        TriggerEvent('cn-itemdrop:create',v,k)
    end
end)

RegisterNetEvent('cn-itemdrop:create')
AddEventHandler('cn-itemdrop:create', function(bag,count)
    bags[count] = bag
    local prop = getProp(bag.item)
    local hash = GetHashKey(prop.prop)
    if prop.size ~= nil then
        hash = getHighestProp(prop.size,bag.amount)
    else
        hash = GetHashKey(prop.prop)
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(10)
    end
    local propspawned = CreateObject(hash, bag.coords.x, bag.coords.y, bag.coords.z, false, true, true)
    PlaceObjectOnGroundProperly(propspawned)
    SetEntityRotation(propspawned, prop.rot)
    Wait(100)
    FreezeEntityPosition(propspawned, true)
    SetEntityCollision(propspawned,false,false)
    bags[count].propspawned = propspawned
end)

RegisterNetEvent('cn-itemdrop:update')
AddEventHandler('cn-itemdrop:update', function(count,bag)
    bags[count] = bag
end)

RegisterNetEvent('cn-itemdrop:remove')
AddEventHandler('cn-itemdrop:remove', function(count)
    if bags[count].propspawned ~= nil then
        DeleteObject(bags[count].propspawned)
    end
    bags[count] = nil
end)

function getHighestProp(size, amount)
    local prop = size[1]
    local last = 0
    for k,v in pairs(size) do
        if tonumber(k) <= amount and tonumber(k) > last then
            last = tonumber(k)
            prop=v
        end
    end
    return GetHashKey(prop)
end

function getProp(item)
    for k,v in pairs(props) do
        if k == item then
            return props[k]
        end
    end
    return props["default"]
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if next(bags) == nil then
            Citizen.Wait(1000)
        end
        local lcoords = GetEntityCoords(PlayerPedId())
        local closeby = false
        for k,v in pairs(bags) do
            local distance = GetDistanceBetweenCoords(lcoords["x"],lcoords["y"],lcoords["z"], v.coords.x, v.coords.y, v.coords.z, true)
            if distance <= 2.0 then
                closeby = true
                DrawText3Ds(v.coords.x, v.coords.y, v.coords.z-0.65, "Tryk ~g~E~w~ for at samle ~b~"..v.amount.." "..v.display.."~w~ op")
                if IsControlJustPressed(0, Keys["E"]) then

                    TriggerServerEvent("cn-itemdrop:pickup",k)
                end
            end
        end
        if closeby == false then
            Citizen.Wait(1000)
        end
    end
end)