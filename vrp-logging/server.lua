--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 06-11-2018
-- Time: 18:33
-- Github: https://github.com/Apisathan/FiveM-Scripts
--
MySQL = module("vrp_mysql", "MySQL")

MySQL.createCommand("vRP/get_depositOnLogin","SELECT depositOnLogin FROM vrp_user_moneys WHERE user_id = @user_id")
MySQL.createCommand("vRP/set_depositOnLogin","UPDATE vrp_user_moneys SET depositOnLogin = @deposit WHERE user_id = @user_id")

MySQL.createCommand("vRP/get_logging","SELECT * FROM logging WHERE user_id = @user_id")
MySQL.createCommand("vRP/create_logging","INSERT INTO logging(user_id, wallet, bank, weapons, inventory) VALUES (@user_id,@wallet,@bank,@weapons,@inventory)")
MySQL.createCommand("vRP/update_logging","UPDATE logging SET wallet=@wallet,bank=@bank,weapons=@weapons,inventory=@inventory,time=CURRENT_TIMESTAMP() WHERE user_id = @user_id")

MySQL.createCommand("vRP/create_rollback","INSERT INTO rollback(user_id, before_wallet, after_wallet, before_bank, after_bank, before_weapons, after_weapons, before_inventory, after_inventory) VALUES (@user_id,@before_wallet,@after_wallet,@before_bank,@after_bank,@before_weapons,@after_weapons,@before_inventory,@after_inventory)")

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Tunnel = module("vrp", "lib/Tunnel")
vRPclient = Tunnel.getInterface("vRP","cn-logging")

local cfg = module("cn-logging", "config")

local logusers = {}

-- Giver depositOnLogin penge
AddEventHandler("vRP:playerSpawn",function(user_id,source,last_login)
    if user_id ~= nil then
        MySQL.query("vRP/get_logging", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                MySQL.query("vRP/get_money", {user_id = user_id}, function(money, affected)
                    local rolled = false
                    local wallet = 0
                    local bank = 0
                    if #money > 0 then
                        wallet = money[1].wallet
                        bank = money[1].bank
                    end
                    if bank ~= rows[1].bank or wallet ~= rows[1].wallet then
                       rolled = true
                    end
                    local fields = {}
                    if wallet ~= rows[1].wallet then
                        table.insert(fields, { name = "Wallet før:", value = rows[1].wallet, inline = true })
                        table.insert(fields, { name = "Wallet after:", value = wallet, inline = true })
                        table.insert(fields, { name = "Wallet forskel:", value = math.abs(rows[1].wallet-wallet), inline = true })
                    end
                    if bank ~= rows[1].bank then
                        table.insert(fields, { name = "Bank før:", value = rows[1].bank, inline = true })
                        table.insert(fields, { name = "Bank efter:", value = bank, inline = true })
                        table.insert(fields, { name = "Bank forskel:", value = math.abs(rows[1].bank-bank), inline = true })
                    end

                    -- INVENTORY CHECK

                    local data = vRP.getUserDataTable({user_id})
                    local inventory = data.inventory
                    local weapons = data.weapons

                    local beforeinv = json.decode(rows[1].inventory)

                    local oitems = ""
                    local nitems = ""

                    local beforeitems = ""
                    for k,v in pairs(beforeinv) do
                        beforeitems = beforeitems.."\n"..k.." ("..v.amount..")"
                        if not hasIndex(inventory, k) then
                            oitems = oitems.."\n"..k.." ("..v.amount..")"
                        elseif v.amount > inventory[k].amount then
                            oitems = oitems.."\n"..k.." ("..math.abs(v.amount - inventory[k].amount)..")"
                        elseif v.amount < inventory[k].amount then
                            nitems = nitems.."\n"..k.." ("..math.abs(v.amount - inventory[k].amount)..")"
                        end
                    end

                    local afteritems = ""
                    for k,v in pairs(inventory) do
                        afteritems = afteritems.."\n"..k.." ("..v.amount..")"
                        if not hasIndex(beforeinv, k) then
                            nitems = nitems.."\n"..k.." ("..v.amount..")"
                        end
                    end

                    if oitems ~= "" or nitems ~= "" then
                        if beforeitems == "" then
                            beforeitems = "Ingen"
                        end
                        if afteritems == "" then
                            afteritems = "Ingen"
                        end
                        table.insert(fields, { name = "Inventory før:", value = beforeitems })
                        table.insert(fields, { name = "Inventory efter:", value = afteritems })
                        if oitems ~= "" then table.insert(fields, { name = "Items mistet:", value = oitems }) end
                        if nitems ~= "" then table.insert(fields, { name = "Items fået:", value = nitems }) end
                        rolled = true
                    end

                    -- WEAPON CHECK

                    local beforeweapon = json.decode(rows[1].weapons)

                    local oweapons = ""
                    local nweapons = ""

                    local beforeweapons = ""
                    for k,v in pairs(beforeweapon) do
                        beforeweapons = beforeweapons.."\n"..k.." ("..v.ammo..")"
                        if not hasIndex(weapons, k) then
                            oweapons = oweapons.."\n"..k.." ("..v.ammo..")"
                        elseif v.ammo > weapons[k].ammo then
                            oweapons = oweapons.."\n"..k.." ("..math.abs(v.ammo - weapons[k].ammo)..")"
                        elseif v.ammo < weapons[k].ammo then
                            nweapons = nweapons.."\n"..k.." ("..math.abs(v.ammo - weapons[k].ammo)..")"
                        end
                    end

                    local afterweapons = ""
                    for k,v in pairs(weapons) do
                        afterweapons = afterweapons.."\n"..k.." ("..v.ammo..")"
                        if not hasIndex(beforeweapon, k) then
                            nweapons = nweapons.."\n"..k.." ("..v.ammo..")"
                        end
                    end

                    if oweapons ~= "" or nweapons ~= "" then
                        if beforeweapons == "" then
                            beforeweapons = "Ingen"
                        end
                        if afterweapons == "" then
                            afterweapons = "Ingen"
                        end
                        table.insert(fields, { name = "Våben før:", value = beforeweapons })
                        table.insert(fields, { name = "Våben efter:", value = afterweapons })
                        if oweapons ~= "" then table.insert(fields, { name = "Våben mistet:", value = oweapons }) end
                        if nweapons ~= "" then table.insert(fields, { name = "Våben fået:", value = nweapons }) end
                        rolled = true
                    end
                    if rolled then
                        local ibweapons = rows[1].weapons
                        if ibweapons == "[]" then
                            ibweapons = "{}"
                        end

                        local iaweapons = json.encode(weapons)
                        if iaweapons == "[]" then
                            iaweapons = "{}"
                        end

                        local ibinventory = rows[1].inventory
                        if ibinventory == "[]" then
                            ibinventory = "{}"
                        end

                        local iainventory = json.encode(inventory)
                        if iainventory == "[]" then
                            iainventory = "{}"
                        end

                        MySQL.query("vRP/create_rollback", {user_id = user_id, before_wallet = rows[1].wallet, after_wallet = wallet, before_bank = rows[1].bank, after_bank = bank, before_weapons = ibweapons, after_weapons = iaweapons, before_inventory = ibinventory, after_inventory = iainventory})

                        PerformHttpRequest(cfg.webhook, function(err, text, headers) end, 'POST', json.encode(
                            {
                                username = "Server "..GetConvar("servernumber", "0"),
                                content = "Spiller: "..user_id.." har muligvis fået rollback",
                                embeds = {
                                    {
                                        color = 16769280,
                                        fields = fields
                                    }
                                }
                            }), { ['Content-Type'] = 'application/json' })
                    end
                    logusers[user_id] = true
                end)
            end
        end)
    end
end)

function hasIndex(tab,key)
    return tab[key] ~= nil
end

AddEventHandler("vRP:playerLeave",function(user_id, source)
    saveUser(user_id)
    logusers[user_id] = nil
end)
AddEventHandler("logging:saveUser",function(user_id)
    if logusers[user_id] ~= nil then
        saveUser(user_id)
    end
end)

function saveUser(user_id)
    if user_id ~= nil then
        local data = vRP.getUserDataTable({user_id});
        local inventory = json.encode(data.inventory)
        local weapons =  json.encode(data.weapons)
        if inventory == "[]" then
            inventory = "{}"
        end
        if weapons == "[]" then
            weapons = "{}"
        end
        local tmp = vRP.getUserTmpTable({user_id})
        MySQL.query("vRP/get_logging", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                MySQL.query("vRP/update_logging", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, weapons = weapons, inventory = inventory})
            else
                MySQL.query("vRP/create_logging", {user_id = user_id, wallet = tmp.wallet, bank = tmp.bank, weapons = weapons, inventory = inventory})
            end
        end)
    end
end