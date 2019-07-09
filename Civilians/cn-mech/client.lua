--[[------------------------------------------------------------------------

	ActionMenu - v1.0.1
	Created by WolfKnight
	Additional help from lowheartrate, TheStonedTurtle, and Briglair. 

------------------------------------------------------------------------]]--
vRP = Proxy.getInterface("vRP")
vRPex = Proxy.getInterface("vrp_extended")

vRPmech = {}
Tunnel.bindInterface("cn-mech",vRPmech)

-- Define the variable used to open/close the menu
local vehicles = {}
local menuEnabled = false

--[[------------------------------------------------------------------------
	ActionMenu Toggle
	Calling this function will open or close the ActionMenu. 
------------------------------------------------------------------------]]--
function vRPmech.setVehMod(mod,lvl)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	SetVehicleMod(veh,mod,lvl)
end
function vRPmech.toggleVehMod(mod)
	local veh = GetVehiclePedIsUsing(PlayerPedId())
	if IsToggleModOn(veh,mod) then
		ToggleVehicleMod(veh, mod, false)
	else
		ToggleVehicleMod(veh, mod, true)
	end
end

function ToggleActionMenu(mod, lvl)
	mod = mod or false
	lvl = lvl or -1
	-- Make the menuEnabled variable not itself
	-- e.g. not true = false, not false = true
	if(mod) then
		if(menuEnabled) then
			SendNUIMessage({
				mod = mod,
				lvl = lvl
			})
		end
		return
	end
	menuEnabled = not menuEnabled

	if ( menuEnabled ) then
		-- Focuses on the NUI, the second parameter toggles the 
		-- onscreen mouse cursor. 
		SetNuiFocus( true, true )

		-- Sends a message to the JavaScript side, telling it to 
		-- open the menu. 
		SendNUIMessage({
			showmenu = true
		})
	else
		-- Bring the focus back to the game
		SetNuiFocus( false )

		-- Sends a message to the JavaScript side, telling it to
		-- close the menu.
		SendNUIMessage({
			hidemenu = true
		})
	end
end

local vehname = ""
local plate = ""
local luser_id = 0
RegisterCommand("mech", function()
	if not vRP.isInComa() and not vRP.isHandcuffed() then
		local job = vRPex.getUser().job
		if job == "Mekaniker" or job == "Mekaniker Chef" or job == "Mekaniker Civilians" or job == "Mekaniker Domingo" then
			local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if veh ~= 0 then
				vehname = vehicles[GetEntityModel(veh)]
				if vehname ~= nil then
					plate = GetVehicleNumberPlateText(veh):gsub("P ","")
					local users = vRPex.getUsers()
					luser_id = checkReg(users,plate)
					if luser_id then
						ToggleActionMenu()
					else
						TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke finde ejeren af køretøjet!",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
					end
				else
					TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke finde ejeren af køretøjet!",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				end
			else
				TriggerEvent("pNotify:SendNotification",{text = "Du skal sidde i en bil",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
			end
		end
	end
	CancelEvent()
end)

function checkReg(users,reg)
	for k,v in pairs(users) do
		if v.reg:upper() == reg then
			return k
		end
	end
	return false
end

--[[------------------------------------------------------------------------
	ActionMenu HTML Callbacks
	This will be called every single time the JavaScript side uses the
	sendData function. The name of the data-action is passed as the parameter
	variable data. 
------------------------------------------------------------------------]]--
RegisterNUICallback( "ButtonClick", function( data, cb )
	if ( data == "engine1" ) then
		setMod(luser_id,vehname,11,-1,false)
	elseif ( data == "engine2" ) then
		setMod(luser_id,vehname,11,0,false)
	elseif ( data == "engine3" ) then
		setMod(luser_id,vehname,11,1,false)
	elseif ( data == "engine4" ) then
		setMod(luser_id,vehname,11,2,false)
	elseif ( data == "brakes1" ) then
		setMod(luser_id,vehname,12,-1,false)
	elseif ( data == "brakes2" ) then
		setMod(luser_id,vehname,12,0,false)
	elseif ( data == "brakes3" ) then
		setMod(luser_id,vehname,12,1,false)
	elseif ( data == "brakes4" ) then
		setMod(luser_id,vehname,12,2,false)
	elseif ( data == "transmission1" ) then
		setMod(luser_id,vehname,13,-1,false)
	elseif ( data == "transmission2" ) then
		setMod(luser_id,vehname,13,0,false)
	elseif ( data == "transmission3" ) then
		setMod(luser_id,vehname,13,1,false)
	elseif ( data == "transmission4" ) then
		setMod(luser_id,vehname,13,2,false)
	elseif ( data == "turbo1" ) then
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsUsing(ped)
		if DoesEntityExist(veh) then
			if vehname ~= "" then
				if IsToggleModOn(veh,18) then
					TriggerServerEvent("cn-mech:upgradeveh",luser_id,vehname,"turbo","off",true)
				else
					TriggerEvent("pNotify:SendNotification",{text = "Bilen er allerede uden turbo.",type = "info",timeout = (3000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
				end
			end
		end
	elseif ( data == "turbo2" ) then
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsUsing(ped)
		if DoesEntityExist(veh) then
			if vehname ~= "" then
				if IsToggleModOn(veh,18) then
					TriggerEvent("pNotify:SendNotification",{text = "Bilen er allerede med turbo.",type = "info",timeout = (3000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
				else
					TriggerServerEvent("cn-mech:upgradeveh",luser_id,vehname,"turbo","on",true)
				end
			end
		end
	elseif ( data == "exit" ) then
		-- We toggle the ActionMenu and return here, otherwise the function 
		-- call below would be executed too, which would just open the menu again
		vehname = ""
		plate = ""
		luser_id = 0
		ToggleActionMenu()
		return
	end

	-- This will only be called if any button other than the exit button is pressed
	if( data == "engine") or (data == "brakes") or (data == "transmission") or (data == "turbo") then
		local ped = GetPlayerPed(-1)
		local veh = GetVehiclePedIsUsing(ped)
		local mod = -1
		if( data == "engine") then
			mod = GetVehicleMod(veh, 11)
		elseif ( data == "brakes") then
			mod = GetVehicleMod(veh, 12)
		elseif ( data == "transmission") then
			mod = GetVehicleMod(veh, 13)
		elseif ( data == "turbo") then
			if IsToggleModOn(veh,18) then
				mod = 0
			else
				mod = -1
			end
		end
		ToggleActionMenu(data, mod)
	else
		ToggleActionMenu()
	end
end )

function setMod(userid,vehname,mod,lvl,toggle)
	local ped = GetPlayerPed(-1)
	local veh = GetVehiclePedIsUsing(ped)
	if DoesEntityExist(veh) then
		if vehname ~= "" then
			if GetVehicleMod(veh, mod) == lvl then
				TriggerEvent("pNotify:SendNotification",{text = "Bilen har allerede det udstyr",type = "info",timeout = (3000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			else
				if toggle then
					TriggerServerEvent("cn-mech:upgradeveh",userid,vehname,mod,lvl,toggle)
				else
					TriggerServerEvent("cn-mech:upgradeveh",userid,vehname,mod,lvl,toggle)
				end
			end
		end
	end
end
--[[------------------------------------------------------------------------
	ActionMenu Control and Input Blocking 
	This is the main while loop that opens the ActionMenu on keypress. It 
	uses the input blocking found in the ES Banking resource, credits to 
	the authors.
------------------------------------------------------------------------]]--

Citizen.CreateThread( function()
	-- This is just in case the resources restarted whilst the NUI is focused. 
	SetNuiFocus( false )
	while true do
		-- Control ID 20 is the 'Z' key by default 
		-- Use https://wiki.fivem.net/wiki/Controls to find a different key
		if ( menuEnabled ) then
			local ped = GetPlayerPed( -1 )
			DisableControlAction( 0, 1, true ) -- LookLeftRight
			DisableControlAction( 0, 2, true ) -- LookUpDown
			DisableControlAction( 0, 24, true ) -- Attack
			DisablePlayerFiring( ped, true ) -- Disable weapon firing
			DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
			DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride
		end
		Citizen.Wait( 0 )
	end
end )
function chatPrint( msg )
	TriggerEvent( 'chatMessage', "Mekaniker", { 255, 255, 255 }, msg )
end

RegisterNetEvent('vrp_extended:vehicles')
AddEventHandler('vrp_extended:vehicles', function(list)
	vehicles = list
end)

RegisterCommand("impound", function()
	if not vRP.isInComa() and not vRP.isHandcuffed() then
		local job = vRPex.getUser().job
		local checkJob = vRPex.checkPolice({job})
		if job == "Mekaniker" or job == "Mekaniker Chef" or job =="Mekaniker Domingo" or job == "Mekaniker Civilians" or checkJob then
			local veh = vRP.getNearestVehicle({5})
			if veh ~= 0 then
				vehname = vehicles[GetEntityModel(veh)]
				if vehname ~= nil then
					plate = GetVehicleNumberPlateText(veh):gsub("P ","")
					local users = vRPex.getUsers()
					luser_id = checkReg(users,plate)
					if luser_id then
						if checkJob and vRPex.getAmountOnline({"mechanic"}) > 1 then
							TriggerEvent("pNotify:SendNotification",{text = "Ring til en mekaniker!",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
							return;
						end
						TriggerServerEvent("cn-mech:impoundveh",luser_id,plate,vehname,1,VehToNet(veh))
					else
						vRP.despawnNetVehicle({VehToNet(veh)})
						TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke finde ejeren af køretøjet</br>Køretøj fjernet.",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
					end
				else
					vRP.despawnNetVehicle({VehToNet(veh)})
					TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke finde ejeren af køretøjet</br>Køretøj fjernet.",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
				end
			else
				TriggerEvent("pNotify:SendNotification",{text = "Kunne ikke finde køretøj",type = "error",timeout = (5000),layout = "centerLeft",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
			end
		end
	end
	CancelEvent()
end)
