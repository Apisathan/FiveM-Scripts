RegisterNUICallback('mobilepay_sendpayment', function(data, cb)
  TriggerServerEvent('gcPhone:mobilepay_sendpayment', data)
end)
