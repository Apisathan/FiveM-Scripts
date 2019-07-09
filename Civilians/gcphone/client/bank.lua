--====================================================================================
--  Function APP BANK
--====================================================================================

RegisterNetEvent('gcPhone:setBankMoney')
AddEventHandler('gcPhone:setBankMoney', function(value)
      SendNUIMessage({event = 'updateBankbalance', banking = value})
end)
