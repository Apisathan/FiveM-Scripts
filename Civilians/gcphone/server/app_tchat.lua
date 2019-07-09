RMySQL = module("vrp_mysql", "MySQL")
RMySQL.createCommand("vRP/gcphone_getTchatChannelMessages","SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100")
RMySQL.createCommand("vRP/gcphone_addTchatChannelMessage","INSERT INTO phone_app_chat (`userid`, `channel`, `message`) VALUES(@userid, @channel, @message); SELECT * from phone_app_chat WHERE `id` = (SELECT LAST_INSERT_ID());")


local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function TchatGetMessageChannel (channel, cbr)
  local task = Task(cbr)
  RMySQL.query("vRP/gcphone_getTchatChannelMessages", {channel = channel}, function(rows, affected)
    if #rows > 0 then
      task({rows})
    end
  end)
end

function TchatAddMessage (userid, channel, message)
  RMySQL.query("vRP/gcphone_addTchatChannelMessage", {userid = userid, channel = channel, message = message}, function(rows, affected)
    if #rows > 0 then
      TriggerClientEvent('gcPhone:tchat_receive', -1, {channel=rows[1].channel,message=rows[1].message,time=rows[1].time,userid=rows[1].userid})
    end
  end)
end


RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
  local user_id = vRP.getUserId({source})
  TchatAddMessage(user_id,channel, message)
end)