RegisterServerEvent('rollcarwindows')
AddEventHandler('rollcarwindows', function(veh,bool,front)
	TriggerClientEvent("rollcarwindows",-1,veh,bool,front)
end)