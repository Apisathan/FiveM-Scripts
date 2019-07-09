MySQL = module("vrp_mysql", "MySQL")

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("cn-mech","cn-mech")
vRPct = Tunnel.getInterface("vRP","cn-mech")

MySQL.createCommand("vRP/cn-mech:upgradetrans","UPDATE vrp_user_vehicles SET vehicle_mods13 = @lvl WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("vRP/cn-mech:upgradebrakes","UPDATE vrp_user_vehicles SET vehicle_mods12 = @lvl WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("vRP/cn-mech:upgradeengine","UPDATE vrp_user_vehicles SET vehicle_mods11 = @lvl WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("vRP/cn-mech:upgradeturbo","UPDATE vrp_user_vehicles SET vehicle_turbo = @lvl WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("vRP/cn-mech:setimpound","UPDATE vrp_user_vehicles SET vehicle_impound = @impound,vehicle_impound_reason = @reason WHERE user_id = @user_id AND vehicle = @veh")

local prices = {
    [11] = {
        [0] = {price=0,title="installeret <b style='color: #4E9350'>Standard motor</b>"},
        [1] = {price=12500,title="installeret <b style='color: #4E9350'>Chiptuning</b>"},
        [2] = {price=25000,title="installeret <b style='color: #4E9350'>Sport Motor</b>"},
        [3] = {price=35000,title="installeret <b style='color: #4E9350'>Racer Motor</b>"},
    },
    [12] = {
        [0] = {price=0,title="installeret <b style='color: #4E9350'>Standard Bremser</b>"},
        [1] = {price=7500,title="installeret <b style='color: #4E9350'>Gade Bremser</b>"},
        [2] = {price=10000,title="installeret <b style='color: #4E9350'>Sport Bremser</b>"},
        [3] = {price=15000,title="installeret <b style='color: #4E9350'>Racer Bremser</b>"},
    },
    [13] = {
        [0] = {price=0,title="installeret <b style='color: #4E9350'>Standard Gearkasse</b>"},
        [1] = {price=10000,title="installeret <b style='color: #4E9350'>Gade Gearkasse</b>"},
        [2] = {price=15000,title="installeret <b style='color: #4E9350'>Sport Gearkasse</b>"},
        [3] = {price=20000,title="installeret <b style='color: #4E9350'>Racer Gearkasse</b>"},
    },
    ["turbo"] = {
        ["off"] = {price=0,title="fjernet <b style='color: #DB4646'>Turbo</b>"},
        ["on"] = {price=20000,title="installeret <b style='color: #4E9350'>Turbo</b>"},
    }
}

RegisterServerEvent('cn-mech:upgradeveh')
AddEventHandler('cn-mech:upgradeveh', function(user_id,veh,mod,lvl,toggle)
    local item = prices[mod][((toggle) and lvl or lvl+1)]
    if item ~= nil and item.price >= 0 then
        local nuser_id = vRP.getUserId({source})
        if vRP.tryFullPayment({nuser_id,tonumber(item.price)}) then
            if toggle then
                local lmod = ""
                if mod == "turbo" then
                    lmod = 18
                end
                if lmod ~= "" then
                    vRPclient.toggleVehMod(source,{lmod})
                end
            else
                vRPclient.setVehMod(source,{mod,lvl})
            end
            local command = ""
            if mod == 11 then
                command = "vRP/cn-mech:upgradeengine"
            elseif mod == 12 then
                command = "vRP/cn-mech:upgradebrakes"
            elseif mod == 13 then
                command = "vRP/cn-mech:upgradetrans"
            elseif mod == "turbo" then
                command = "vRP/cn-mech:upgradeturbo"
            end
            if command ~= "" then
                MySQL.execute(command, {user_id = user_id, veh = veh, lvl = lvl})
                TriggerClientEvent("pNotify:SendNotification", source,{text = "Køretøjet har fået "..item.title.."<br>"..((lvl ~= "off") and "Betalt: <b style='color: #DB4646'>"..item.price.."</b> DKK" or ""), type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        else
            TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke råd til og købe opgraderingen", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
        end
    end
end)

RegisterServerEvent('cn-mech:impoundveh')
AddEventHandler('cn-mech:impoundveh', function(user_id,plate,veh,bool,netveh)
    plate = "P "..plate
    if bool == 0 then
        MySQL.execute("vRP/cn-mech:setimpound", {user_id = user_id,veh=veh,impound=bool,reason=""})
        TriggerClientEvent("pNotify:SendNotification", source,{text = veh.." "..plate.." er blevet frigivet!", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
    elseif bool == 1 then
        local nuser_id = vRP.getUserId({source})
        vRP.prompt({source, firstToUpper(veh).." ("..plate..") beslaglagt årsag:", "", function(player,reason)
            if string.len(reason) >= 2 and string.len(reason) <= 200 then
                MySQL.execute("vRP/cn-mech:setimpound", {user_id = user_id,veh=veh,impound=bool,reason=reason})
                TriggerClientEvent("pNotify:SendNotification", player,{text = "<b style='color: #4E9350'>"..firstToUpper(veh).." ("..plate..")</b> er blevet beslaglagt!<br/>Årsag: <b style='color: #4E9350'>"..reason.."</b>", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
                exports["vrp_garages"]:updateGarage(user_id)
                sendToDiscord("Server "..GetConvar("servernumber", "0").." - Beslaglagt","**"..nuser_id.."** har lige beslaglagt **"..firstToUpper(veh).."** fra **"..user_id.."** med grunden: *"..reason.."* (**"..os.date("%H:%M:%S %d/%m/%Y").."**)")
                vRPct.despawnNetVehicle(player,{netveh})
            else
                TriggerClientEvent("pNotify:SendNotification", player,{text = "Du skal beskrive en grund", type = "success", queue = "global", timeout = 5000, layout = "centerLeft",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
            end
        end})
    end
end)

function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    PerformHttpRequest("https://discordapp.com/api/webhooks/559173897862250517/wvAM0_8T-dMNkWg7EyrPXwrj71cFf0asHhrJ0Crt91A9L_4HDm8AaY9vUikeLaQzbuH8", function(err, text, headers) end, 'POST', json.encode({avatar_url = "https://i.imgur.com/HUgauWf.png",username = name,content = message}), { ['Content-Type'] = 'application/json' })
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end