--[[------------------------------------------------------------------------

    Wraith Radar System - v1.01
    Created by WolfKnight

------------------------------------------------------------------------]]--

--[[------------------------------------------------------------------------
    Resource Rename Fix 
------------------------------------------------------------------------]]--
vRPex = Proxy.getInterface("vrp_extended")

Citizen.CreateThread( function()
    Citizen.Wait( 1000 )
    local resourceName = GetCurrentResourceName()
    SendNUIMessage( { resourcename = resourceName } )
end )

SetNuiFocus(false)


--[[------------------------------------------------------------------------
    Utils 
------------------------------------------------------------------------]]--
function round( num )
    return tonumber( string.format( "%.0f", num ) )
end

function oppang( ang )
    return ( ang + 180 ) % 360
end

function FormatSpeed( speed )
    return string.format( "%03d", speed )
end

function GetVehicleInDirectionSphere( entFrom, coordFrom, coordTo )
    local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 2.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    return vehicle
end

function IsEntityInMyHeading( myAng, tarAng, range )
    local rangeStartFront = myAng - ( range / 2 )
    local rangeEndFront = myAng + ( range / 2 )

    local opp = oppang( myAng )

    local rangeStartBack = opp - ( range / 2 )
    local rangeEndBack = opp + ( range / 2 )

    if ( ( tarAng > rangeStartFront ) and ( tarAng < rangeEndFront ) ) then
        return true
    elseif ( ( tarAng > rangeStartBack ) and ( tarAng < rangeEndBack ) ) then
        return false
    else
        return nil
    end
end


--[[------------------------------------------------------------------------
    Police Vehicle Radar 
------------------------------------------------------------------------]]--
local radarEnabled = false
local hidden = false
local radarInfo =
{
    patrolSpeed = "000",

    speedType = "mph",

    fwdPrevVeh = 0,
    fwdXmit = true,
    fwdMode = "same",
    fwdSpeed = "000",
    fwdFast = "000",
    fwdFastLocked = false,
    fwdDir = nil,
    fwdFastSpeed = 0,
    fwdPlate = "",

    bwdPrevVeh = 0,
    bwdXmit = false,
    bwdMode = "none",
    bwdSpeed = "OFF",
    bwdFast = "OFF",
    bwdFastLocked = false,
    bwdDir = nil,
    bwdFastSpeed = 0,
    bwdPlate = "",

    fastResetLimit = 150,
    fastLimit = 55,

    angles = { [ "same" ] = { x = 0.0, y = 50.0, z = 0.0 }, [ "opp" ] = { x = -10.0, y = 50.0, z = 0.0 } }
}

RegisterNetEvent( 'wk:toggleRadar' )
AddEventHandler( 'wk:toggleRadar', function()
    local ped = GetPlayerPed( -1 )

    if ( IsPedSittingInAnyVehicle( ped ) ) then
        local vehicle = GetVehiclePedIsIn( ped, false )

        if ( GetVehicleClass( vehicle ) == 18 ) then
            radarEnabled = not radarEnabled

            if ( radarEnabled ) then
                TriggerEvent("pNotify:SendNotification",{text = "Rader <b style='color:#00ff00'>aktiveret",type = "info",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
            else
                TriggerEvent("pNotify:SendNotification",{text = "Rader <b style='color:#ff0000'>deaktiveret",type = "info",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
            end

            ResetFrontAntenna()
            ResetRearAntenna()

            SendNUIMessage({
                toggleradar = true,
                fwdxmit = radarInfo.fwdXmit,
                fwdmode = radarInfo.fwdMode,
                bwdxmit = radarInfo.bwdXmit,
                bwdmode = radarInfo.bwdMode
            })
        else
            TriggerEvent("pNotify:SendNotification",{text = "Du skal sidde i en politibil ",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
        end
    else
        TriggerEvent("pNotify:SendNotification",{text = "Du skal være i en bil ",type = "error",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
    end
end )

RegisterNetEvent( 'wk:changeRadarLimit' )
AddEventHandler( 'wk:changeRadarLimit', function( speed )
    radarInfo.fastLimit = speed
end )

function Radar_SetLimit()
    Citizen.CreateThread( function()
        DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )

        while true do
            if ( UpdateOnscreenKeyboard() == 1 ) then
                local speedStr = GetOnscreenKeyboardResult()

                if ( string.len( speedStr ) > 0 ) then
                    local speed = tonumber( speedStr )

                    if ( speed < 999 and speed > 1 ) then
                        TriggerEvent( 'wk:changeRadarLimit', speed )
                    end

                    break
                else
                    DisplayOnscreenKeyboard( false, "", "", "", "", "", "", 4 )
                end
            elseif ( UpdateOnscreenKeyboard() == 2 ) then
                break
            end

            Citizen.Wait( 0 )
        end
    end )
end

function ResetFrontAntenna()
    if ( radarInfo.fwdXmit ) then
        radarInfo.fwdSpeed = "000"
        radarInfo.fwdFast = "000"
    else
        radarInfo.fwdSpeed = "OFF"
        radarInfo.fwdFast = "   "
    end

    radarInfo.fwdDir = nil
    radarInfo.fwdFastSpeed = 0
    radarInfo.fwdFastLocked = false
    radarInfo.selectedUser = false
    radarInfo.fwdVeh = false
end

function ResetRearAntenna()
    if ( radarInfo.bwdXmit ) then
        radarInfo.bwdSpeed = "000"
        radarInfo.bwdFast = "000"
    else
        radarInfo.bwdSpeed = "OFF"
        radarInfo.bwdFast = "   "
    end

    radarInfo.bwdDir = nil
    radarInfo.bwdFastSpeed = 0
    radarInfo.bwdFastLocked = false
end

function ResetFrontFast()
    if ( radarInfo.fwdXmit ) then
        radarInfo.fwdFast = "000"
        radarInfo.fwdFastSpeed = 0
        radarInfo.fwdFastLocked = false
        radarInfo.selectedUser = false
        radarInfo.fwdVeh = false

        SendNUIMessage( { lockfwdfast = false } )
    end
end

function ResetRearFast()
    if ( radarInfo.bwdXmit ) then
        radarInfo.bwdFast = "000"
        radarInfo.bwdFastSpeed = 0
        radarInfo.bwdFastLocked = false

        SendNUIMessage( { lockbwdfast = false } )
    end
end

function CloseRadarRC()
    SendNUIMessage({
        toggleradarrc = true
    })

    TriggerEvent( 'wk:toggleMenuControlLock', false )

    SetNuiFocus( false )
end

function ToggleSpeedType()
    if ( radarInfo.speedType == "mph" ) then
        radarInfo.speedType = "kmh"
        TriggerEvent("pNotify:SendNotification",{text = "Fart sat til <b style='color:#ffff00'> KM/T âœ…",type = "info",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
    else
        radarInfo.speedType = "mph"
        TriggerEvent("pNotify:SendNotification",{text = "Fart sat til <b style='color:#ffff00'> MPH âœ…",type = "info",timeout = (5000),layout = "centerRight",queue = "global",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer=true})
    end
end

function GetVehSpeed( veh )
    if ( radarInfo.speedType == "mph" ) then
        return GetEntitySpeed( veh ) * 3.6
    end
end

local lastplate = ""
function ManageVehicleRadar()
    if ( radarEnabled ) then
        local ped = GetPlayerPed( -1 )

        if ( IsPedSittingInAnyVehicle( ped ) ) then
            local vehicle = GetVehiclePedIsIn( ped, false )

            if ( GetPedInVehicleSeat( vehicle, -1 ) == ped and GetVehicleClass( vehicle ) == 18 ) then
                -- Patrol speed 
                local vehicleSpeed = round( GetVehSpeed( vehicle ), 0 )

                radarInfo.patrolSpeed = FormatSpeed( vehicleSpeed )

                -- Rest of the radar options 
                local vehiclePos = GetEntityCoords( vehicle, true )
                local h = round( GetEntityHeading( vehicle ), 0 )

                -- Front Antenna 
                if ( radarInfo.fwdXmit ) then
                    local forwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.fwdMode ].x, radarInfo.angles[ radarInfo.fwdMode ].y, radarInfo.angles[ radarInfo.fwdMode ].z )
                    local fwdPos = { x = forwardPosition.x, y = forwardPosition.y, z = forwardPosition.z }
                    local _, fwdZ = GetGroundZFor_3dCoord( fwdPos.x, fwdPos.y, fwdPos.z + 500.0 )

                    if ( fwdPos.z < fwdZ and not ( fwdZ > vehiclePos.z + 1.0 ) ) then
                        fwdPos.z = fwdZ + 0.5
                    end

                    local packedFwdPos = vector3( fwdPos.x, fwdPos.y, fwdPos.z )
                    local fwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedFwdPos )

                    if ( DoesEntityExist( fwdVeh ) and IsEntityAVehicle( fwdVeh ) ) then
                        local fwdVehSpeed = round( GetVehSpeed( fwdVeh ), 0 )
                        local fwdPlate = tostring( GetVehicleNumberPlateText(fwdVeh) ) or ""


                        local fwdVehHeading = round( GetEntityHeading( fwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, fwdVehHeading, 100 )

                        if not radarInfo.fwdFastLocked then
                            radarInfo.fwdVeh = fwdVeh
                            radarInfo.fwdPlate = fwdPlate
                            radarInfo.fwdSpeed = FormatSpeed( fwdVehSpeed )
                            radarInfo.fwdDir = dir
                            if lastplate ~= fwdPlate then
                                local users = vRPex.getUsers()
                                for k,v in pairs(users) do
                                    if "P "..v.reg == fwdPlate then
                                        if v.warned ~= false or v.license ~= 1 then
                                            radarInfo.selectedUser = v
                                            radarInfo.fwdFastLocked = true
                                            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
                                            Wait(200)
                                            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
                                            Wait(200)
                                            PlaySoundFrontend(-1, "Hang_Up", "Phone_SoundSet_Michael", 1)
                                        end
                                    end
                                end
                            end
                        end

                        if ( fwdVehSpeed > radarInfo.fastLimit and not radarInfo.fwdFastLocked ) then
                            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )

                            radarInfo.fwdFastSpeed = fwdVehSpeed
                            radarInfo.fwdFastLocked = true

                            SendNUIMessage( { lockfwdfast = true } )
                        end

                        radarInfo.fwdFast = FormatSpeed( radarInfo.fwdFastSpeed )

                        radarInfo.fwdPrevVeh = fwdVeh
                    end
                end

                -- Rear Antenna 
                if ( radarInfo.bwdXmit ) then
                    local backwardPosition = GetOffsetFromEntityInWorldCoords( vehicle, radarInfo.angles[ radarInfo.bwdMode ].x, -radarInfo.angles[ radarInfo.bwdMode ].y, radarInfo.angles[ radarInfo.bwdMode ].z )
                    local bwdPos = { x = backwardPosition.x, y = backwardPosition.y, z = backwardPosition.z }
                    local _, bwdZ = GetGroundZFor_3dCoord( bwdPos.x, bwdPos.y, bwdPos.z + 500.0 )

                    if ( bwdPos.z < bwdZ and not ( bwdZ > vehiclePos.z + 1.0 ) ) then
                        bwdPos.z = bwdZ + 0.5
                    end

                    local packedBwdPos = vector3( bwdPos.x, bwdPos.y, bwdPos.z )
                    local bwdVeh = GetVehicleInDirectionSphere( vehicle, vehiclePos, packedBwdPos )

                    if ( DoesEntityExist( bwdVeh ) and IsEntityAVehicle( bwdVeh ) ) then
                        local bwdVehSpeed = round( GetVehSpeed( bwdVeh ), 0 )
                        local bwdPlate = tostring( GetVehicleNumberPlateText(bwdVeh) ) or ""
                        local bwdVehHeading = round( GetEntityHeading( bwdVeh ), 0 )
                        local dir = IsEntityInMyHeading( h, bwdVehHeading, 100 )

                        radarInfo.bwdPlate = bwdPlate
                        radarInfo.bwdSpeed = FormatSpeed( bwdVehSpeed )
                        radarInfo.bwdDir = dir

                        if ( bwdVehSpeed > radarInfo.fastLimit and not radarInfo.bwdFastLocked ) then
                            PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )

                            radarInfo.bwdFastSpeed = bwdVehSpeed
                            radarInfo.bwdFastLocked = true

                            SendNUIMessage( { lockbwdfast = true } )
                        end

                        radarInfo.bwdFast = FormatSpeed( radarInfo.bwdFastSpeed )

                        radarInfo.bwdPrevVeh = bwdVeh
                    end
                end

                SendNUIMessage({
                    patrolspeed = radarInfo.patrolSpeed,
                    fwdspeed = radarInfo.fwdSpeed,
                    fwdfast = radarInfo.fwdFast,
                    fwddir = radarInfo.fwdDir,
                    fwdPlate = radarInfo.fwdPlate,
                    bwdspeed = radarInfo.bwdSpeed,
                    bwdfast = radarInfo.bwdFast,
                    bwddir = radarInfo.bwdDir,
                    bwdPlate = radarInfo.bwdPlate,
                })
            end
        end
    end
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)
        if radarInfo.selectedUser ~= nil and radarInfo.selectedUser ~= false then
            if radarInfo.selectedUser.license ~= 1 and radarInfo.selectedUser.warned == false then
                local driver = "Nej"
                if radarInfo.selectedUser.license == 2 then
                    driver = "Frakendt"
                end
                DrawRect(0.9, 0.744, 0.2, 0.19, 0,0,0,200)
                ply_drawTxt("~r~Kørekort",4,1,0.9,0.6525,0.7,255,50,50,255)
                ply_drawTxt("~y~Kørekort: ~w~"..driver,4,1,0.9,0.70,0.5,255,255,255,255)
                ply_drawTxt("~y~CPR: ~w~"..radarInfo.selectedUser.cpr,4,1,0.9,0.73,0.5,255,255,255,255)
                ply_drawTxt("~y~Ejer: ~w~"..radarInfo.selectedUser.name,4,1,0.9,0.76,0.5,255,255,255,255)
                ply_drawTxt("~y~Køretøj: ~w~"..GetDisplayNameFromVehicleModel(GetEntityModel(radarInfo.fwdVeh)),4,1,0.9,0.79,0.5,255,255,255,255)
            elseif radarInfo.selectedUser.warned ~= false then
                local height = 0.19
                local offset = 0.744
                local lastoffset = 0.79
                if radarInfo.selectedUser.license ~= 1 then
                    height = 0.22
                    offset = 0.757
                    lastoffset = 0.82
                end
                DrawRect(0.9, offset, 0.2, height, 0,0,0,200)
                ply_drawTxt("~r~Efterlyst",4,1,0.9,0.6525,0.7,255,50,50,255)
                ply_drawTxt("~y~CPR: ~w~"..radarInfo.selectedUser.cpr,4,1,0.9,0.70,0.5,255,255,255,255)
                ply_drawTxt("~y~Ejer: ~w~"..radarInfo.selectedUser.name,4,1,0.9,0.7300,0.5,255,255,255,255)
                ply_drawTxt("~y~Køretøj: ~w~"..GetDisplayNameFromVehicleModel(GetEntityModel(radarInfo.fwdVeh)),4,1,0.9,0.76,0.5,255,255,255,255)
                if radarInfo.selectedUser.license ~= 1 then
                    local driver = "Nej"
                    if radarInfo.selectedUser.license == 2 then
                        driver = "Frakendt"
                    end
                    ply_drawTxt("~y~Kørekort: ~w~"..driver,4,1,0.9,0.79,0.5,255,255,255,255)
                end
                ply_drawTxt("~y~Antal efterlysninger: ~w~"..#json.decode(radarInfo.selectedUser.warned),4,1,0.9,lastoffset,0.5,255,255,255,255)
            end
        end
    end
end)

function ply_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    SetTextCentre(centre)
    DrawText(x , y)
end

RegisterNetEvent( 'wk:radarRC' )
AddEventHandler( 'wk:radarRC', function()
    Citizen.Wait( 10 )

    TriggerEvent( 'wk:toggleMenuControlLock', true )

    radarInfo.fwdXmit = true
    ResetFrontAntenna()
    SendNUIMessage( { fwdxmit = radarInfo.fwdXmit } )

    radarInfo.fwdMode = "same"

    SendNUIMessage( { fwdmode = radarInfo.fwdMode } )


    SendNUIMessage({
        toggleradarrc = true
    })

    SetNuiFocus( true, true )
end )

RegisterNUICallback( "RadarRC", function( data, cb )
    -- Toggle Radar
    if ( data == "radar_toggle" ) then
        TriggerEvent( 'wk:toggleRadar' )

        -- Front Antenna
    elseif ( data == "radar_frontopp" and radarInfo.fwdXmit ) then
        radarInfo.fwdMode = "opp"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontxmit" ) then
        radarInfo.fwdXmit = not radarInfo.fwdXmit
        ResetFrontAntenna()
        SendNUIMessage( { fwdxmit = radarInfo.fwdXmit } )

        if ( radarInfo.fwdXmit == false ) then
            radarInfo.fwdMode = "none"
        else
            radarInfo.fwdMode = "same"
        end

        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )
    elseif ( data == "radar_frontsame" and radarInfo.fwdXmit ) then
        radarInfo.fwdMode = "same"
        SendNUIMessage( { fwdmode = radarInfo.fwdMode } )

        -- Rear Antenna
    elseif ( data == "radar_rearopp" and radarInfo.bwdXmit ) then
        radarInfo.bwdMode = "opp"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearxmit" ) then
        radarInfo.bwdXmit = not radarInfo.bwdXmit
        ResetRearAntenna()
        SendNUIMessage( { bwdxmit = radarInfo.bwdXmit } )

        if ( radarInfo.bwdXmit == false ) then
            radarInfo.bwdMode = "none"
        else
            radarInfo.bwdMode = "same"
        end

        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )
    elseif ( data == "radar_rearsame" and radarInfo.bwdXmit ) then
        radarInfo.bwdMode = "same"
        SendNUIMessage( { bwdmode = radarInfo.bwdMode } )

        -- Set Fast Limit
    elseif ( data == "radar_setlimit" ) then
        CloseRadarRC()
        Radar_SetLimit()

        -- Speed Type
    elseif ( data == "radar_speedtype" ) then
        ToggleSpeedType()

        -- Close
    elseif ( data == "close" ) then
        CloseRadarRC()
    end

    if ( cb ) then cb( 'ok' ) end
end )

Citizen.CreateThread( function()
    SetNuiFocus( false )

    while true do
        ManageVehicleRadar()

        -- Only run 2 times a second, more realistic, also prevents spam 
        Citizen.Wait( 500 )
    end
end )

Citizen.CreateThread( function()
    while true do
        -- These control pressed natives must be the disabled check ones. 

        -- LCtrl is pressed and M has just been pressed 
        if ( IsDisabledControlPressed( 1, 36 ) and IsDisabledControlJustPressed( 1, 244 ) ) then
            local ped = GetPlayerPed( -1 )

            if ( IsPedSittingInAnyVehicle( ped ) ) then
                local vehicle = GetVehiclePedIsIn( ped, false )
                if ( GetVehicleClass( vehicle ) == 18 ) then
                    TriggerEvent( 'wk:radarRC' )
                end
            end
        end

        -- LCtrl is not being pressed and M has just been pressed 
        if ( not IsDisabledControlPressed( 1, 36 ) and IsDisabledControlJustPressed( 1, 244 ) ) then
            ResetFrontFast()
            ResetRearFast()
        end

        local ped = GetPlayerPed( -1 )
        local inVeh = IsPedSittingInAnyVehicle( ped )
        local veh = nil

        if ( inVeh ) then
            veh = GetVehiclePedIsIn( ped, false )
        end

        if ( ( (not inVeh or (inVeh and GetVehicleClass( veh ) ~= 18)) and radarEnabled and not hidden) or IsPauseMenuActive() and radarEnabled ) then
            hidden = true
            SendNUIMessage( { hideradar = true } )
        elseif ( inVeh and GetVehicleClass( veh ) == 18 and radarEnabled and hidden ) then
            hidden = false
            SendNUIMessage( { hideradar = false } )
        end

        Citizen.Wait( 0 )
    end
end )


--[[------------------------------------------------------------------------
    Menu Control Lock - Prevents certain actions 
    Thanks to the authors of the ES Banking script. 
------------------------------------------------------------------------]]--
local locked = false

RegisterNetEvent( 'wk:toggleMenuControlLock' )
AddEventHandler( 'wk:toggleMenuControlLock', function( lock )
    locked = lock
end )

Citizen.CreateThread( function()
    while true do
        if ( locked ) then
            local ped = GetPlayerPed( -1 )

            DisableControlAction( 0, 1, true ) -- LookLeftRight
            DisableControlAction( 0, 2, true ) -- LookUpDown
            DisableControlAction( 0, 24, true ) -- Attack
            DisablePlayerFiring( ped, true ) -- Disable weapon firing
            DisableControlAction( 0, 142, true ) -- MeleeAttackAlternate
            DisableControlAction( 0, 106, true ) -- VehicleMouseControlOverride

            SetPauseMenuActive( false )
        end

        Citizen.Wait( 0 )
    end
end )


--[[------------------------------------------------------------------------
    Notify  
------------------------------------------------------------------------]]--
function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentSubstringPlayerName( text )
    DrawNotification( false, true )
end 