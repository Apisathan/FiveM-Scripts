vRP = Proxy.getInterface("vRP")

vRPsb = {}
Tunnel.bindInterface("vrp_ui",vRPsb)
Proxy.addInterface("vrp_ui",vRPsb)

local key = 212 -- https://wiki.fivem.net/wiki/Controls
local voice = 0

local cfg = {
	{
		distance = 45.0001,
		text = "Råber"
	},
	{
		distance = 2.0001,
		text = "Hvisker"
	},
	{
		distance = 12.0001,
		text = "Normal"
	},
}
local health = -1
local piss = -1
local hunger = -1
local thirst = -1
local showUI = true

function vRPsb.setUIBar(type,amount)
	if type == "health" then health = amount
	elseif type == "piss" then piss = 100-math.floor(math.abs(amount))
	elseif type == "hunger" then hunger = 100-math.floor(math.abs(amount))
	elseif type == "thirst" then thirst = 100-math.floor(math.abs(amount))
	end
end

function vRPsb.showUI(bool)
	showUI = bool
end


function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(2, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end


function drawRct(x,y,width,height,r,g,b,a)
   DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end


Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(0)
 		if IsControlJustPressed(1, key) then
 			voice = voice + 1
			if voice > 3 then voice = 1 end
			NetworkSetTalkerProximity(cfg[voice].distance)
			TriggerEvent("pNotify:SendNotification",{text = "Talerækkevide: <b style='color: #4E9350'>"..cfg[voice].text.."</b>",
				type = "info",timeout = 4000, layout = "centerRight",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
		end
 	end
end)

local height = 0.011
local bar1 = 0.970
local bar2 = 0.9835
local talebaroffset = 0.0862
Citizen.CreateThread(function()
 	while true do
 		Citizen.Wait(0)
		if showUI then
			drawRct(0.0135, 0.96695, 0.1440,0.030,32,32,34,255)
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				drawRct(0.11,bar1-0.001, 0.046,height+0.001,100,100,100,255)
				if NetworkIsPlayerTalking(PlayerId()) then
					if voice == 1 then
						drawRct(0.11,bar1-0.001, 0.046,height+0.001,255, 93, 69,255)
					elseif voice == 2 then
						drawRct(0.11,bar1-0.001, 0.015333,height+0.001,255, 93, 69,255)
					else
						drawRct(0.11,bar1-0.001, 0.030333,height+0.001,255, 93, 69,255)
					end
				else
					if voice == 1 then
						drawRct(0.11,bar1-0.001, 0.046,height+0.001,234, 234, 234,255)
					elseif voice == 2 then
						drawRct(0.11,bar1-0.001, 0.015333,height+0.001,234, 234, 234,255)
					else
						drawRct(0.11,bar1-0.001, 0.030333,height+0.001,234, 234, 234,255)
					end
				end

				local vdamage = GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(),false))
				drawRct(0.0625,bar1-0.001, 0.046,height+0.001,98, 161, 117, 255)
				drawRct(0.0625,bar1-0.001, (0.000046 * tonumber(vdamage)),height+0.001,98, 255, 117, 255)
				drawTxt(0.0980,bar1-0.00420, 0.0350,0.01,0.24, math.floor(vdamage) , 255, 255, 255, 255)
				health = GetEntityHealth(GetPlayerPed(-1)) - 100
				if health ~= -1 then
					drawRct(0.015,bar1-0.001, 0.046,height+0.001,0, 120, 0,255)
					if health == 0 then
						drawTxt(0.0510,bar1-0.00420, 0.046,0.01,0.24, "Død" , 255, 255, 255, 255)
					end
					drawRct(0.015,bar1-0.001, (0.00046 * health),height+0.001,0, 195, 0,255)
					drawTxt(0.0510,bar1-0.00420, 0.0350,0.01,0.24, math.floor(health) , 255, 255, 255, 255)
				end
			else
				local armor = GetPedArmour(PlayerPedId())
				local talebarwidth = 0.07
				local healthtxt = 0.0650
				if armor > 0 then
					drawRct(0.0625,bar1-0.001, 0.046,height+0.001,63, 159, 104,255)
					drawRct(0.0625,bar1-0.001, (0.00046 * armor),height+0.001,63, 240, 104,255)
					drawTxt(0.1,bar1-0.00420, 0.0350,0.01,0.24, math.floor(armor) , 255, 255, 255, 255)
					talebaroffset = 0.11
					talebarwidth = 0.046
					healthtxt = healthtxt/1.40
				else
					talebaroffset = 0.0862
				end
				drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,100,100,100,255)
				if NetworkIsPlayerTalking(PlayerId()) then
					if voice == 1 then
						drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,255, 93, 69,255)
					elseif voice == 2 then
						drawRct(talebaroffset,bar1-0.001, talebarwidth/3,height+0.001,255, 93, 69,255)
					else
						drawRct(talebaroffset,bar1-0.001, talebarwidth/1.5,height+0.001,255, 93, 69,255)
					end
				else
					if voice == 1 then
						drawRct(talebaroffset,bar1-0.001, talebarwidth,height+0.001,234, 234, 234,255)
					elseif voice == 2 then
						drawRct(talebaroffset,bar1-0.001, talebarwidth/3,height+0.001,234, 234, 234,255)
					else
						drawRct(talebaroffset,bar1-0.001, talebarwidth/1.5,height+0.001,234, 234, 234,255)
					end
				end
				health = GetEntityHealth(GetPlayerPed(-1)) - 100
				if health ~= -1 then
					drawRct(0.015,bar1-0.001, talebarwidth,height+0.001,0, 120, 0,255)
					if health == 0 then
						drawTxt(healthtxt,bar1-0.00420, talebarwidth/2,0.01,0.24, "Død" , 255, 255, 255, 255)
					end
					drawRct(0.015,bar1-0.001, ((talebarwidth/100) * health),height+0.001,0, 195, 0,255)
					drawTxt(healthtxt,bar1-0.00420, talebarwidth/2,0.01,0.24, math.floor(health) , 255, 255, 255, 255)
				end
			end
			drawRct(0.015,bar2, 0.046,height,255, 104, 0,255)
			if hunger ~= -1 then
				drawRct(0.015,bar2, (0.00046 * hunger),height,255, 152, 0,255)
				if hunger < 25 then
					drawTxt(0.0545,bar2-0.00420, 0.046,0.01,0.24, "Sulter" , 255, 255, 255, 255)
				end
			end
			drawRct(0.0625,bar2, 0.046,height,0, 103, 251,255)
			if thirst ~= -1 then
				drawRct(0.0625,bar2, (0.00046 * thirst),height,0, 160, 251,255)
				if thirst < 25 then
					drawTxt(0.1000,bar2-0.00420, 0.046,0.01,0.24, "Tørster" , 255, 255, 255, 255)
				end
			end
			drawRct(0.11,bar2, 0.046,height,255, 159, 0,255)
			if piss ~= -1 then
				drawRct(0.11,bar2, (0.00046 * piss),height,255, 229, 0,255)
			end
		end
 	end
end)