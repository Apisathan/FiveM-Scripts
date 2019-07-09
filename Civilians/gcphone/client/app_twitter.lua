RegisterNetEvent("gcPhone:twitter_receive")
AddEventHandler("gcPhone:twitter_receive", function(message)
  message.message = Emojit(message.message)
  SendNUIMessage({event = 'twitter_receive', message = message})
end)

RegisterNetEvent("gcPhone:RefreshTwitter")
AddEventHandler("gcPhone:RefreshTwitter", function(messages)
  local lmessages = json.decode(messages)
  for k,v in pairs(lmessages) do
    Wait(10)
    if v.message ~= nil then
      v.message = Emojit(v.message)
    end
  end
  lmessages = json.encode(lmessages)
  SendNUIMessage({event = 'RefreshTwitter', message = lmessages})
end)

RegisterNUICallback('twitter_sendMessage', function(data, cb)
  TriggerServerEvent('gcPhone:twitter_addMessage', data.message, data.time)
end)

function Emojit(text)
  for i = 1, #emoji do
    for k = 1, #emoji[i][1] do
      text = string.gsub(text, emoji[i][1][k], emoji[i][2])
    end
  end
  return text
end