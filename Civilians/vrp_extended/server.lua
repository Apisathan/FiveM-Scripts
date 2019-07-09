--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 11-01-2019
-- Time: 20:20
-- Made for CiviliansNetwork
--

local Tunnel = module("vrp", "lib/Tunnel")
vRPclient = Tunnel.getInterface("vRP","vrp_extended")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPex = {}
Proxy.addInterface("vrp_extended",vRPex)

function vRPex.updateInventory(user_id,inventory,weight)
    TriggerClientEvent("vrp_extended:inventory",-1,user_id,inventory,weight)
end

local offonduty = {
    [1] = {coords={439.92529296875,-990.74243164063,29.689588546753},type=false,onDuty="Politi-Job",offDuty='Arbejdsløs',perm="politi.duty",removeWeapons=true},
    [2] = {coords={339.52249145508,-582.00817871094,27.791469573975},type=false,onDuty="EMS-Job",offDuty='Arbejdsløs',perm="ems.duty"},
    [3] = {coords={908.49450683594,-3207.2915039063,-98.187980651855},type=true,onDuty="Våbendealer-Job",offDuty='Kriminel',perm="weapons.dealer"},
    [4] = {coords={460.26507568359,-573.79248046875,27.499803543091},type=true,onDuty="Mekaniker-Job",offDuty='Arbejdsløs',perm="civiliansmekaniker.duty"},
    [5] = {coords={-347.42962646484,-133.3056640625,38.009654998779},type=true,onDuty="Mekaniker-Job",offDuty='Arbejdsløs',perm="domingomekaniker.duty"},
    --[5] = {coords={-227.83038330078,-1327.626953125,28.890386581421},type=true,onDuty="Mekaniker-Job",offDuty='Arbejdsløs',perm="domingomekaniker.duty"},--Bromingo
    [6] = {coords={1160.2624511719,-3192.1567382813,-40.007999420166},type=true,onDuty="Journalist-Job",offDuty='Arbejdsløs',perm="journalist.duty"},
    [7] = {coords={125.44895935059,-767.18377685547,241.15216064453},type=true,onDuty="Advokat-Job",offDuty='Arbejdsløs',perm="advokat.duty"},
    [8] = {coords={-138.51321411133,-634.11614990234,167.82048034668},type=true,onDuty="Ejendomsmægler-Job",offDuty='Arbejdsløs',perm="realestate.duty"},
    [9] = {coords={-31.250434875488,-1106.6016845703,25.422332763672},type=true,onDuty="Bilforhandler-Job",offDuty='Arbejdsløs',perm="bilforhandler.duty"},
    [10] = {coords={-1912.1140136719,-570.46264648438,18.12238540649},type=true,onDuty="Psykolog-Job",offDuty='Arbejdsløs',perm="psykolog.duty"},
    [11] = {coords={-1055.5174560547,-242.83055114746,43.021137237549},type=true,onDuty="Sikkerhedsvagt-Job",offDuty='Arbejdsløs',perm="sikkerhedsvagt.duty"},
}

local users = {}
local vehicles = {}

AddEventHandler("vRP:playerLeave",function(user_id, source)
    TriggerClientEvent("vrp_extended:removeuser",-1,user_id)
    users[user_id] = nil
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        vRP.getUserIdentity({user_id, function(identity)
            local job = vRP.getUserGroupByType({user_id,"job"})
            local checksub = vRP.getUserGroupByType({user_id,job})
            if checksub ~= nil and checksub ~= "" then
                job = checksub
            end
            vRP.isVip({user_id, function(vip)
                vRP.getDriverLicense({user_id, function(license)
                    local inventory = vRP.getInventory({user_id})
                    vRP.getUData({user_id, "vRP:police_warned", function(rdata)
                        local warned = {}
                        if rdata ~= nil and rdata ~= "" then
                            warned = rdata
                        else
                            warned = false
                        end

                        local split = {}
                        for i in string.gmatch(identity.cpr, "[^-]+") do
                            table.insert(split, i)
                        end

                        local lage = math.abs(tonumber(split[3]) - tonumber(os.date("%Y")))
                        local cd =  tonumber(os.date("%d"))
                        local cm = tonumber(os.date("%m"))

                        if cm <= tonumber(split[2]) then
                            if cm == tonumber(split[2]) then
                                if cd < tonumber(split[1]) then
                                    lage = lage-1
                                end
                            elseif cm < tonumber(split[2]) then
                                lage = lage-1
                            end
                        end

                        local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..identity.lastdigits

                        local data = {
                            userid=tonumber(user_id),
                            source=tonumber(source),
                            name=tostring(identity.firstname.." "..identity.name),
                            job=tostring(job),
                            vip=vip,
                            inventory=inventory,
                            reg=identity.registration,
                            warned=warned,
                            cpr=cpr,
                            age=lage,
                            birth=identity.cpr,
                            license=license
                        }

                        users[user_id] = data
                        TriggerClientEvent('vrp_extended:updateusers',-1,users)
                    end})
                end})
            end})
            local server = GetConvar("servernumber", "0")
            TriggerClientEvent("vrp_extended:server", source, server)
        end})
        TriggerClientEvent('vrp_extended:offonduty', source, offonduty)
        TriggerClientEvent('vrp_extended:user', source, user_id)
    else
        local inventory = vRP.getInventory({user_id})
        users[user_id].inventory = inventory
        TriggerClientEvent('vrp_extended:updateusers',-1,users)
    end
end)

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
    if gtype == "job" then
        local job = vRP.getUserGroupByType({user_id,"job"})
        local checksub = vRP.getUserGroupByType({user_id,job})
        if checksub ~= nil and checksub ~= "" then
            job = checksub
        end
        users[user_id].job = tostring(job)
        TriggerClientEvent('vrp_extended:updateusers',-1,users)
    end
end)

--[[AddEventHandler('onResourceStart', function(name)
    if name:lower() == GetCurrentResourceName():lower() then
        local lusers = vRP.getUsers({})
        for k,v in pairs(lusers) do
            Citizen.Wait(50)
            if v ~= nil then
                vRP.getUserIdentity({k, function(identity)
                    local job = vRP.getUserGroupByType({k,"job"})
                    local checksub = vRP.getUserGroupByType({k,job})
                    if checksub ~= nil and checksub ~= "" then
                        job = checksub
                    end
                    vRP.isVip({k, function(vip)
                        vRP.getDriverLicense({k, function(license)
                            local inventory = vRP.getInventory({k})
                            vRP.getUData({k, "vRP:police_warned", function(rdata)
                                local warned = {}
                                if rdata ~= nil and rdata ~= "" then
                                    warned = rdata
                                else
                                    warned = false
                                end

                                local split = {}
                                for i in string.gmatch(identity.cpr, "[^-]+") do
                                    table.insert(split, i)
                                end

                                local lage = math.abs(tonumber(split[3]) - tonumber(os.date("%Y")))
                                local cd =  tonumber(os.date("%d"))
                                local cm = tonumber(os.date("%m"))

                                if cm <= tonumber(split[2]) then
                                    if cm == tonumber(split[2]) then
                                        if cd < tonumber(split[1]) then
                                            lage = lage-1
                                        end
                                    elseif cm < tonumber(split[2]) then
                                        lage = lage-1
                                    end
                                end

                                local cpr = split[1]..split[2]..string.sub(split[3],3).."-"..identity.lastdigits

                                local data = {
                                    userid=tonumber(k),
                                    source=tonumber(v),
                                    name=tostring(identity.firstname.." "..identity.name),
                                    job=tostring(job),
                                    vip=vip,
                                    inventory=inventory,
                                    reg=identity.registration,
                                    warned=warned,
                                    cpr=cpr,
                                    age=lage,
                                    birth=identity.cpr,
                                    license=license,
                                }
                                users[k] = data
                                TriggerClientEvent('vrp_extended:updateusers',-1,users)
                            end})
                        end})
                    end})
                    local server = GetConvar("servernumber", "0")
                    TriggerClientEvent("vrp_extended:server", v, server)
                end})
                TriggerClientEvent('vrp_extended:offonduty', v, offonduty)
                TriggerClientEvent('vrp_extended:user', v, k)
            end
        end
    end
end)]]

RegisterServerEvent("vrp_extended:updatelicense")
AddEventHandler("vrp_extended:updatelicense", function(user_id,license)
    if users[user_id] ~= nil then
        users[user_id].license = license
        TriggerClientEvent('vrp_extended:updateusers',-1,users)
    end
end)

RegisterServerEvent("vrp_extended:addwarned")
AddEventHandler("vrp_extended:addwarned", function(user_id,data)
    if users[user_id] ~= nil then
        users[user_id].warned = data
        TriggerClientEvent('vrp_extended:updateusers',-1,users)
    end
end)

RegisterServerEvent("vrp_extended:removewarned")
AddEventHandler("vrp_extended:removewarned", function(user_id)
    if users[user_id] ~= nil then
        users[user_id].warned = false
        TriggerClientEvent('vrp_extended:updateusers',-1,users)
    end
end)

RegisterServerEvent("vrp_extended:collectvehicles")
AddEventHandler("vrp_extended:collectvehicles", function(hash,vehicle)
    vehicles[hash] = vehicle
    TriggerClientEvent("vrp_extended:vehicles",-1,vehicles)
end)

RegisterServerEvent("vrp_extended:duty")
AddEventHandler("vrp_extended:duty", function(number)
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id,offonduty[number].perm}) then
        if vRP.hasGroup({user_id,offonduty[number].onDuty}) then
            TriggerClientEvent("pNotify:SendNotification", source,{text = "Du er gået af arbejde!", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
            vRP.addUserGroup({user_id,offonduty[number].offDuty})
            if offonduty[number].removeWeapons ~= nil then
                vRPclient.removeWeapons(source,{{WEAPON_NIGHTSTICK = {ammo = 1}, WEAPON_STUNGUN = {ammo = 1}, WEAPON_PUMPSHOTGUN = {ammo = 0}, WEAPON_COMBATPISTOL = {ammo = 250}, WEAPON_VINTAGEPISTOL = {ammo = 250}, WEAPON_SMG = {ammo = 250}, WEAPON_CARBINERIFLE = {ammo = 250}, WEAPON_SNIPERRIFLE = {ammo = 250}, WEAPON_SMOKEGRENADE = {ammo = 250}}})
            end
        else
            vRP.addUserGroup({user_id,offonduty[number].onDuty})
            TriggerClientEvent("pNotify:SendNotification", source,{text = "Du er gået på arbejde som <b style='color:#64A664'>"..vRP.getUserGroupByType({user_id,offonduty[number].onDuty}).."</b>!", type = "success", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
        end
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Ingen adgang", type = "error", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
    end
end)

AddEventHandler('chatMessage', function(source, author, msg)
    local args = stringsplit(msg, ' ')
    if string.lower(args[1]) == "/blacksms" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,"weapons.dealer"}) then
            local smessage = ""
            for k,v in pairs(args) do
                if k > 1 then
                    smessage = smessage .. v .." "
                end
            end
            if smessage ~= "" then
                local isSend = false
                local users = vRP.getUsers({})
                for k,v in pairs(users) do
                    if vRP.hasInventoryItem({k, "blackmarketmobil"}) then
                        vRPclient.notifyPicture(v,{"CHAR_DETONATEPHONE", 9, "Nokia 3310", false, smessage})
                        isSend = true
                    end
                end
                if isSend then
                    TriggerClientEvent("pNotify:SendNotification", source,{text = "SMS sendt", type = "success", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
                else
                    TriggerClientEvent("pNotify:SendNotification", source,{text = "SMS'en blev ikke sendt", type = "success", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
                end
            else
                TriggerClientEvent("pNotify:SendNotification", source,{text = "SMS blev ikke sendt", type = "success", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
            end
        end
        CancelEvent()
    elseif string.lower(args[1]) == "/blackgps" then
        local user_id = vRP.getUserId({source})
        if vRP.hasPermission({user_id,"weapons.dealer"}) then
            args[2] = parseInt(args[2])
            local checkid = vRP.getUserSource({tonumber(args[2])})
            if checkid ~= nil then
                vRPclient.getPosition(source,{},function(x,y,z)
                    vRPclient.notifyPicture(checkid,{"CHAR_DETONATEPHONE", 9, "GPS", false, "Din GPS er blevet sat!"})
                    vRPclient.setGPS(checkid,{x,y})
                    TriggerClientEvent("pNotify:SendNotification", source,{text = "GPS for "..args[2].." blev sat!", type = "success", queue = "global", timeout = 3000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}, killer=true})
                end)
            else
                TriggerClientEvent("pNotify:SendNotification",source,{text = "ID "..args[2].." er ugyldigt eller ikke online.", type = "error", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        end
        CancelEvent()
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

RegisterServerEvent("vrp_extended:selltonpc")
AddEventHandler("vrp_extended:selltonpc", function(drug)
    local highamount = (drug.amount >= excfg.drugs[drug.item].highsell) and excfg.drugs[drug.item].highsell or drug.amount
    local sellamount = 0
    if drug.amount <= excfg.drugs[drug.item].lowsell then
        sellamount = drug.amount
    else
        sellamount = math.random(excfg.drugs[drug.item].lowsell,highamount)
    end
    local sellprice = math.random(excfg.drugs[drug.item].low,excfg.drugs[drug.item].high) * sellamount
    local user_id = vRP.getUserId({source})
    if vRP.tryGetInventoryItem({user_id,drug.item,sellamount,false}) then
        vRP.giveMoney({user_id,sellprice})
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Solgte <b style='color: #4E9350'>"..sellamount.." "..drug.item.."</b> for <b style='color: #4E9350'>"..sellprice.." DKK</b>", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)