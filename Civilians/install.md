## Install af funktioner

### Debt system 
**vrp/modules/money.lua:**  
Kør i databasen: `ALTER TABLE vrp_user_moneys ADD debt int(11) DEFAULT 0 NOT NULL; `
- Skal tilføjes:  
```
function vRP.tryBankPaymentOrDebt(user_id,amount)
    local money = vRP.getBankMoney(user_id)
    if amount > 0 and money >= amount then
        vRP.setBankMoney(user_id,money-amount)
        return "paid"
    else
        local tmp = vRP.getUserTmpTable(user_id)
        local diff = amount-money
        tmp.debt = tmp.debt+diff+500
        vRP.setBankMoney(user_id,500)
        return tmp.debt
    end
    return false
end

function vRP.payDebt(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        if tmp.debt > 0 then
            local paid = 0
            if tmp.debt > tmp.bank then
                local diff = tmp.debt-tmp.bank
                paid = tmp.bank
                tmp.bank = 0
                tmp.debt = diff
            else
                local diff = tmp.bank-tmp.debt
                paid = tmp.debt
                tmp.debt = 0
                tmp.bank = diff
            end
            local source = vRP.getUserSource(user_id)
            vRP.getUserIdentity(user_id, function(identity)
                local name = identity.firstname.." "..identity.name
                TriggerClientEvent("banking:updateBalance", source, tmp.bank, tmp.debt, name)
            end)

            if paid > 0 then
                if tmp.debt == 0 then
                    TriggerClientEvent("pNotify:SendNotification", source, {
                        text = "Du har indbetalt <b style='color: #4E9350'>"..format_thousand(math.floor(paid)).." DKK</b> til din gæld<br>Tillykke du har ikke mere gæld!",
                        type = "success",
                        timeout = (4000),
                        layout = "bottomCenter",
                        queue = "global",
                        animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                        killer = false
                    })
                else
                    TriggerClientEvent("pNotify:SendNotification", source, {
                        text = "Du har indbetalt <b style='color: #4E9350'>"..format_thousand(math.floor(paid)).." DKK</b> til din gæld",
                        type = "success",
                        timeout = (4000),
                        layout = "bottomCenter",
                        queue = "global",
                        animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                        killer = false
                    })
                end
            else
                TriggerClientEvent("pNotify:SendNotification", source, {
                    text = "Kunne ikke indbetale gæld!",
                    type = "error",
                    timeout = (4000),
                    layout = "bottomCenter",
                    queue = "global",
                    animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},
                    killer = false
                })
            end
        end
    end
end
```
- Skal replaces:
```
AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login) 
    MySQL.execute("vRP/money_init_user", {user_id = user_id, wallet = cfg.open_wallet, bank = cfg.open_bank}, function(affected)
        -- load money (wallet,bank)
        local tmp = vRP.getUserTmpTable(user_id)
        if tmp then
            MySQL.query("vRP/get_money", {user_id = user_id}, function(rows, affected)
                if #rows > 0 then
                    tmp.debt = rows[1].debt
                    tmp.bank = rows[1].bank
                    tmp.wallet = rows[1].wallet
                end
            end)
        end
    end)
end)

function vRP.setBankMoney(user_id,value)
    local tmp = vRP.getUserTmpTable(user_id)
    local source = vRP.getUserSource(user_id)
    if tmp then
        if tmp.debt > 0 and tmp.bank < value then
            local diff = value - tmp.bank
            local hdiff = diff/2
            local payed = 0
            if diff > 1 and hdiff > tmp.debt then
                payed = tmp.debt
                tmp.bank = tmp.bank+hdiff+(hdiff-tmp.debt)
                tmp.debt = 0
            elseif hdiff < tmp.debt then
                tmp.debt = tmp.debt-hdiff
                payed = hdiff
                tmp.bank = tmp.bank+hdiff
            end
            if tmp.debt > 0 then
                TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har betalt <b style='color: #4E9350'>"..format_thousands(payed).." DKK</b> til din gæld<br>Restgæld: <b style='color: #DB4646'>"..format_thousands(tmp.debt).." DKK</b>", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            else
                TriggerClientEvent("pNotify:SendNotification", source,{text = "Du har betalt <b style='color: #4E9350'>"..format_thousands(payed).." DKK</b> til din gæld<br>Tillykke du har ikke mere gæld!", type = "success", queue = "global", timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
            end
        else
            tmp.bank = value
        end
    end
    if source ~= nil then
        TriggerClientEvent("gcPhone:setBankMoney",source,tmp.bank)
    end
end
```
### Pis funktion
**vrp/modules/survival.lua:**  
- Skal tilføjes:  
```
function vRP.getPiss(user_id)
    local data = vRP.getUserDataTable(user_id)
    if data then
        return data.piss
    end

    return 0
end

function vRP.setPiss(user_id,value)
    local data = vRP.getUserDataTable(user_id)
    if data then
        data.piss = value
        if data.piss < 0 then data.piss = 0
        elseif data.piss > 100 then data.piss = 100
        end

        -- update bar
        local source = vRP.getUserSource(user_id)
        vRPui.setUIBar(source,{"piss",data.piss})
    end
end

function vRP.varyPiss(user_id, variation)
    local data = vRP.getUserDataTable(user_id)
    if data then
        data.piss = data.piss + variation

        -- apply overflow as damage
        local overflow = data.piss-100
        if overflow > 0 then
            vRPclient.varyPiss(vRP.getUserSource(user_id),{})
        end

        if data.piss < 0 then data.piss = 0
        elseif data.piss > 100 then data.piss = 100
        end

        -- set progress bar data
        local source = vRP.getUserSource(user_id)
        vRPui.setUIBar(source,{"piss",data.piss})
    end
end
function tvRP.varyPiss(variation)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        vRP.varyPiss(user_id,variation)
    end
end
```
- Skal replaces:
```
function task_update()
    for k,v in pairs(vRP.users) do
        vRP.varyHunger(v,cfg.hunger_per_minute)
        vRP.varyThirst(v,cfg.thirst_per_minute)
        vRP.varyPiss(v,cfg.piss_per_minute)
        vRP.varyPromille(v,cfg.promille_per_minute)
    end
    SetTimeout(60000,task_update)
end
task_update()

AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
    local data = vRP.getUserDataTable(user_id)
    if data.hunger == nil then
        data.piss = 0
        data.hunger = 0
        data.thirst = 0
        data.health = 200
    elseif data.piss == nil then
        data.piss = 0
    end
end)

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    local data = vRP.getUserDataTable(user_id)

    -- disable police
    vRPclient.setPolice(source,{cfg.police})
    -- set friendly fire
    vRPclient.setFriendlyFire(source,{cfg.pvp})

    vRP.setPiss(user_id, data.piss)
    vRP.setHunger(user_id, data.hunger)
    vRP.setThirst(user_id, data.thirst)
    vRP.setHealth(user_id, data.health)
end)
```
### Manglende funktioner til extended
**vrp/modules/identity.lua:**  
Kør i database:
- `UPDATE vrp_users SET DmvTest='1' WHERE DmvTest = 'Passed'`
- `UPDATE vrp_users SET DmvTest='0' WHERE DmvTest = 'Required'`
- `ALTER TABLE vrp_users CHANGE DmvTest DmvTest TINYINT NOT NULL DEFAULT '0';`  

- Skal tilføjes:  
```
-- cbreturn driverlicense status
function vRP.getDriverLicense(user_id, cbr)
    local task = Task(cbr)
    if licenses[user_id] ~= nil then
        task({licenses[user_id]})
    else
        MySQL.query("vRP/status_driverlicense", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                task({licenses[user_id]})
            else
                task()
            end
        end)
    end
end

function vRP.isVip(user_id, cbr)
    local task = Task(cbr)
    if isVip[user_id] ~= nil then
        task({isVip[user_id]})
    else
        MySQL.query("vRP/get_userinfo", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                isVip[user_id] = rows[1].vip
                task({isVip[user_id]})
            else
                task()
            end
        end)
    end
end
```
- Skal replaces: 
```
function vRP.setLicense(user_id,dmvtest)
    MySQL.execute("vRP/set_license", {user_id = user_id, dmvtest = dmvtest})
    TriggerEvent("vrp_extended:updatelicense",user_id,dmvtest)
end
```
### Ændring til driver license
**vrp_dmvschool - server.lua**
- Husk og ændrer alle steder bruger license  
```
RegisterServerEvent("dmv:success")
AddEventHandler("dmv:success", function()
    local user_id = vRP.getUserId({source})
    vRP.setLicense({user_id,1})
end)
```
