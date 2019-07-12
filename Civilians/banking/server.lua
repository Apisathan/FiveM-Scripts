local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","banking")
isTransfer = false

-- HELPER FUNCTIONS
function bankBalance(player)
    return vRP.getBankMoney({vRP.getUserId({player})})
end

function walletBalance(player)
    return vRP.getWalletAmount({vRP.getUserId({player})})
end

function deposit(player, amount)
    local user_id = vRP.getUserId({player})
    vRP.tryDeposit({user_id,math.floor(math.abs(amount))})
    local bankbalance = bankBalance(player)
    local debt = vRP.getDebt({user_id})
    vRP.getUserIdentity({user_id, function(identity)
        local name = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", player, bankbalance, debt, name)
    end})
end

function withdraw(player, amount)
    local bankbalance = bankBalance(player)
    local new_balance = bankbalance - math.abs(amount)

    local user_id = vRP.getUserId({player})
    vRP.tryWithdraw({user_id,math.floor(math.abs(amount))})

    local debt = vRP.getDebt({user_id})
    vRP.getUserIdentity({user_id, function(identity)
        local name = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", player, new_balance, debt, name)
    end})
end

function transfer(fPlayer, tPlayer, amount)
    local bankbalance = bankBalance(fPlayer)
    local bankbalance2 = bankBalance(tPlayer)

    local new_balance = bankbalance - math.abs(amount)
    local new_balance2 = bankbalance2 + math.abs(amount)


    local user_id = vRP.getUserId({fPlayer})
    local user_id2 = vRP.getUserId({tPlayer})

    local debt = vRP.getDebt({user_id})
    local debt2 = vRP.getDebt({user_id2})
    vRP.setBankMoney({user_id, new_balance})
    vRP.setBankMoney({user_id2, new_balance2})

    local source = vRP.getUserSource({user_id})
    local source2 = vRP.getUserSource({user_id2})

    vRP.getUserIdentity({user_id, function(identity)
        local name = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", source, new_balance, debt, name)
    end})


    TriggerClientEvent("pNotify:SendNotification", source,{text = "Du overførte <b style='color: #4E9350'>"..math.floor(amount).." DKK</b>", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    TriggerClientEvent("pNotify:SendNotification", source,{text = "Nyt indestående beløb: <b style='color: #4E9350'>"..math.floor((new_balance)).." DKK</b>", type = "info", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

    vRP.getUserIdentity({user_id, function(identity)
        local name2 = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", source2, new_balance2, debt2, name2)
    end})



    TriggerClientEvent("pNotify:SendNotification", source2,{text = "Du modtog <b style='color: #4E9350'>"..math.floor((amount))" DKK</b>", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    TriggerClientEvent("pNotify:SendNotification", source2,{text = "Nyt indestående beløb: <b style='color: #4E9350'>"..math.floor((new_balance2))" DKK</b>", type = "success", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})

end

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function round(num, numDecimalPlaces)
    local mult = 5^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function splitString(str, sep)
    if sep == nil then sep = "%s" end

    local t={}
    local i=1

    for str in string.gmatch(str, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end

    return t
end

RegisterServerEvent('bank:open')
AddEventHandler('bank:open', function()
    local lsource = source
    local user_id = vRP.getUserId({source})
    local bankbalance = vRP.getBankMoney({user_id})
    local debt = vRP.getDebt({user_id})
    vRP.getUserIdentity({user_id, function(identity)
        local name = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", lsource, bankbalance, debt, name)
        TriggerClientEvent("bank:open",lsource)
    end})
end)

RegisterServerEvent('bank:update')
AddEventHandler('bank:update', function()
    local lsource = source
    local user_id = vRP.getUserId({source})
    local bankbalance = vRP.getBankMoney({user_id})
    local debt = vRP.getDebt({user_id})
    vRP.getUserIdentity({user_id, function(identity)
        local name = identity.firstname.." "..identity.name
        TriggerClientEvent("banking:updateBalance", lsource, bankbalance, debt, name)
    end})
end)

RegisterServerEvent('bank:depositAll')
AddEventHandler('bank:depositAll', function()
    local user_id = vRP.getUserId({source})
    local wallet = vRP.getMoney({user_id})
    local rounded = math.ceil(tonumber(wallet))
    if(wallet > 0) then
        deposit(source, wallet)
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Du indsatte <b style='color: #4E9350'>"..format_thousand(math.floor(rounded)).." DKK</b>.",
            type = "success",
            timeout = (4000),
            layout = "bottomCenter",
            queue = "global",
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
            killer = false
        })
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ingen kontanter på dig!", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)


-- Bank Deposit
RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    if not amount then return end
    local user_id = vRP.getUserId({source})
    local wallet = vRP.getMoney({user_id})
    local rounded = math.ceil(tonumber(amount))
    if(rounded <= wallet) then
        deposit(source, rounded)
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Du indsatte <b style='color: #4E9350'>"..format_thousand(math.floor(rounded)).." DKK</b>.",
            type = "success",
            timeout = (4000),
            layout = "bottomCenter",
            queue = "global",
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
            killer = false
        })
    else
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har ikke nok kontanter", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

RegisterServerEvent('bank:debt')
AddEventHandler('bank:debt', function()
    local user_id = vRP.getUserId({source})
    vRP.payDebt({user_id})
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    if not amount then return end
    local user_id = vRP.getUserId({source})
    local rounded = round(tonumber(amount), 0)
    local bankbalance = vRP.getBankMoney({user_id})
    if(tonumber(rounded) <= tonumber(bankbalance)) then
        withdraw(source, rounded)
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Du hævede <b style='color: #4E9350'>"..format_thousand(math.floor(rounded)).." DKK</b>.",
            type = "success",
            timeout = (4000),
            layout = "bottomCenter",
            queue = "global",
            animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
            killer = false
        })
    else
        TriggerClientEvent("pNotify:SendNotification", user_id,{text = "Du har ikke nok penge på kontoen", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
    end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(toPlayer, amount)
    local user_id = vRP.getUserId({source})
    if tonumber(user_id) == tonumber(toPlayer) then
        TriggerClientEvent("pNotify:SendNotification", source,{text = "Du kan ikke overføre til dig selv", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
        CancelEvent()
    else
        local fPlayer = vRP.getUserSource({user_id})
        local receiverOnline = vRP.getUserSource({toPlayer})
        if receiverOnline ~= nil then
            local rounded = round(tonumber(amount), 0)
            if(string.len(rounded) >= 9) then
                TriggerClientEvent("pNotify:SendNotification", fPlayer,{text = "Ugyldig værdi", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                CancelEvent()
            else
                local bankbalance = vRP.getBankMoney({user_id})
                if(tonumber(rounded) <= tonumber(bankbalance)) then
                    transfer(fPlayer, receiverOnline, rounded)
                    CancelEvent()
                else
                    TriggerClientEvent("pNotify:SendNotification", fPlayer,{text = "Du har ikke nok penge på kontoen", type = "error", queue = "global", timeout = 5000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
                end
            end
        else
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = "Denne person er ikke tilgængelig",
                type = "error",
                timeout = (4000),
                layout = "bottomCenter",
                queue = "global",
                animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                killer = false
            })
        end
    end
end)
