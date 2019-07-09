vRP = Proxy.getInterface("vRP")
vRPex = Proxy.getInterface("vrp_extended")

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

function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 20, 20, 20, 150)
end

local doctorped = ""
RegisterNetEvent("vrp_hospital:place")
AddEventHandler("vrp_hospital:place", function()
	RequestModel(GetHashKey("s_m_m_doctor_01"))
	while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
		Wait(1)
	end 
	doctorped =  CreatePed(4, 0xd47303ac, 338.5, -585.19, 27.86, 252.83, false, true)
	SetEntityHeading(doctorped, 252.83)
	FreezeEntityPosition(doctorped, true)
	SetEntityInvincible(doctorped, true)
	SetBlockingOfNonTemporaryEvents(doctorped, true)
end)

local usedbeds = {}

local beds = {
	1631638868,
	2117668672
}
local checkedin = 0 -- sæt til false

local inbed = false

local pause = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if pause ~= 0 then if pause > 0 then pause = pause-1 end end
		if checkedin == 0 then
			local coords = GetEntityCoords(PlayerPedId(),true)
			if (Vdist(coords["x"], coords["y"], coords["z"], 340.31530761719,-585.80682373047,27.791460037231) < 1.2) then
				if pause == 0 then
					DrawMarker(27, 340.31530761719,-585.80682373047,27.791460037231, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5001, 83, 255, 87, 200, 0, 0, 0, 50)
					DrawText3Ds(340.31530761719,-585.80682373047,28.791460037231,"Tryk ~g~E ~w~for tjekke ind")
					if IsControlJustReleased(1, Keys["E"]) then
						pause = 16000
						loadAnimDict("mp_common")
						TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
						TaskPlayAnim(doctorped, "mp_common", "givetake2_a", 8.0, 8.0, -1, 1, 0, false, false, false)
						Citizen.Wait(2500)
						TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjeksyge", 0.5)
						ClearPedTasks(PlayerPedId())
						TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_CLIPBOARD")
						Citizen.Wait(10000)
						ClearPedTasks(doctorped)
						if vRPex.getAmountOnline({"ems"}) > 0 then
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "ringertilkollega", 0.5)
							Citizen.Wait(3000)
							TaskStartScenarioInPlace(doctorped, "WORLD_HUMAN_STAND_MOBILE")
							Citizen.Wait(7500)
							ClearPedTasks(doctorped)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "kollegapaavej", 0.5)
							TriggerServerEvent('dispatchems', coords["x"], coords["y"], coords["z"], "Der står en og mangler hjælp ved sygehuset!")
						else
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "tjekketindsyge", 0.5)
							checkedin = 18000
						end
					end
				end
			end
		else
			if inbed == false then
				if checkedin > 0 then
					checkedin = checkedin-1
				end
			end
		end
	end
end)

local laybed = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(PlayerPedId(),true)
		for k,v in pairs(beds) do
			local bed = GetClosestObjectOfType(coords["x"], coords["y"], coords["z"], 2.0, v, false, false, false)
			if bed ~= 0 then
				local bcoords = GetEntityCoords(bed, true)
				if inbed == false then
					if usedbeds[math.floor(bcoords["x"])] == nil then
						DrawText3Ds(bcoords["x"],bcoords["y"],bcoords["z"]+0.75,"Tryk ~g~E ~w~for at lægge dig")
						if IsControlJustReleased(1, Keys["E"]) then
							FreezeEntityPosition(PlayerPedId(),true)
							TaskStartScenarioAtPosition(PlayerPedId(), "WORLD_HUMAN_SUNBATHE_BACK", bcoords["x"],bcoords["y"],bcoords["z"]+1.40, GetEntityHeading(bed), 0, true,true)
							TriggerServerEvent("cn-hospital:sendstatus",math.floor(bcoords["x"]),true)
							inbed = true
							laybed = bed
						end
					end
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(6000)
		if inbed and checkedin > 0 then
			local health = GetEntityHealth(PlayerPedId())
			if health <= 199 then
				SetEntityHealth(PlayerPedId(),health+1)
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inbed then
			ply_drawTxt("Tryk ~r~E~w~ for at gå ud af sengen",4,1,0.5,0.95,0.6,255,255,255,255)
			if IsControlJustReleased(1, Keys["E"]) then
				local bcoords = GetEntityCoords(laybed)
				SetEntityCoordsNoOffset(PlayerPedId(),bcoords["x"]-1.2,bcoords["y"],bcoords["z"],0,0,1)
				FreezeEntityPosition(PlayerPedId(),false)
				SetEntityHeading(PlayerPedId(),GetEntityHeading(laybed)-180)
				TriggerServerEvent("cn-hospital:sendstatus",math.floor(bcoords["x"]),false)
				inbed = false
				laybed = 0
			end
		end
	end
end)

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 5 )
	end
end

RegisterNetEvent('cn-hospital:load')
AddEventHandler('cn-hospital:load', function(list)
	usedbeds = list
end)

RegisterNetEvent('cn-hospital:status')
AddEventHandler('cn-hospital:status', function(key,bed)
	usedbeds[key] = bed
end)