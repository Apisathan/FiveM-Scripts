--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-03-2019
-- Time: 20:27
-- Made for CiviliansNetwork
--

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local defaultcars = {
    {coords={-453.00729370117,-144.88781738281,37.048791503906,27.267488479614},data={coords={-447.58268432617,-167.10437304688,37.951671600342},turned=true,limit=1,radius=11}},
    {coords={343.28149414063,-741.33166503906,28.22426376343,341.26953125},data={coords={331.45116577149,-757.36636962891,29.007123947144},turned=true,limit=1,radius=9}},
    {coords={583.68109130859,-1038.8240966797,35.892339324951,276.79147338867},data={coords={554.07803955077,-1036.7507324219,36.787731170654},turned=true,limit=1,radius=11}},
    {coords={1159.4560546875, 603.40740966797, 97.600476074219, 143.62663269043},data={coords={1177.5625,620.3178100586,98.553421020508},turned=true,limit=2,radius=5.6}},
    {coords={2419.0642089844, 3944.5319824219, 35.251952362061, 315.15115356445},data={coords={2400.0688476563,3930.5173339844,36.051647186279},turned=true,limit=2,radius=5.6}},
    {coords={-196.72119140625, 6163.0190429688, 30.325545883179, 314.62280273438},data={coords={-218.1734375,6149.668359375,31.141002655029},turned=true,limit=2,radius=5.4}},
    {coords={1667.8442382813, 1360.7210693359, 86.216006469727, 169.68803405762},data={coords={1678.24375,1386.5290039063,87.018951416016},turned=true,limit=3,radius=14}},
    {coords={2234.185546875, 2738.4643554688, 44.230134735107, 297.9485168457},data={coords={2206.203125,2731.8860839844,45.053623199463},turned=true,limit=3,radius=20}},
}
local fotovogne = {

}

local basiccost = 5000

RegisterServerEvent('cn-fotovogn:betal')
AddEventHandler('cn-fotovogn:betal', function(speed,limit,veh)
	local source = source
	local user_id = vRP.getUserId({source})
	local percent = speed/limit
	local tax = basiccost * percent
    if percent > 1.3 then
        tax = tax*1.5
    end
    tax = math.floor(tax)
    local payment = vRP.tryBankPaymentOrDebt({user_id,tax})
	if payment ~= false then
		if payment == "paid" then
			TriggerClientEvent("pNotify:SendNotification", source,{text = "<b style='color:#ED2939'>Fotovogn</b><br /><br />Du kørte " .. speed .. "km/t hvor du må køre "..limit.." km/t <br /><b style='color:#26ff26'>Bøde</b>: " .. tax .." DKK", type = "error", queue = "fart", timeout = 8000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
		else
			TriggerClientEvent("pNotify:SendNotification", source,{text = "<b style='color:#ED2939'>Fotovogn</b><br /><br />Du kørte " .. speed .. "km/t hvor du må køre "..limit.." km/t <br /><b style='color:#26ff26'>Bøde</b>: " .. tax .." DKK".."<br>Nuværende gæld: <b style='color: #DB4646'>"..format_thousands(payment).." DKK</b>", type = "error", queue = "fart", timeout = 8000, layout = "centerRight",animation = {open = "gta_effects_open", close = "gta_effects_close"}})
		end
    end
    if veh ~= false then
        TriggerClientEvent("cn-fotovogn:sendalert",-1,veh,tax,speed)
    end
end)

RegisterServerEvent('cn-fotovogn:sendvogn')
AddEventHandler('cn-fotovogn:sendvogn', function(veh,list)
	fotovogne[veh] = list
	TriggerClientEvent("cn-fotovogn:sendvogn",-1,fotovogne)
end)

RegisterServerEvent('cn-fotovogn:removevogn')
AddEventHandler('cn-fotovogn:removevogn', function(veh)
    fotovogne[veh] = nil
    TriggerClientEvent("cn-fotovogn:sendvogn",-1,fotovogne)
end)

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
        TriggerClientEvent('cn-fotovogn:createdefault', source, defaultcars,fotovogne)
	end
end)

function format_thousands(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

