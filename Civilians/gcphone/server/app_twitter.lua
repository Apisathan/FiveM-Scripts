RMySQL = module("vrp_mysql", "MySQL")
RMySQL.createCommand("vRP/gcphone_addTweet","INSERT INTO `phone_twitter`(`userid`, `name`, `message`, `time`) VALUES (@userid, @name, @message, @time)")

function twitter_addMessage (user_id, name, message, time)
  RMySQL.execute("vRP/gcphone_addTweet", {userid = user_id, name = name, message = message, time = time}, function(affected)
    TriggerEvent("gcphone:addtweet",name,message,time)
    TriggerClientEvent('gcPhone:twitter_receive', -1, {userid=user_id,name=name,message=message,time=time})
  end)
end

RegisterServerEvent('gcPhone:twitter_addMessage')
AddEventHandler('gcPhone:twitter_addMessage', function(message, time)
  local user_id = vRP.getUserId({source})
  local steam = GetPlayerName(source)
  vRP.getUserIdentity({user_id, function(identity)
    local name = identity.firstname.." "..identity.name
    twitter_addMessage(user_id,name,message,time)
    sendToDiscord(steam, 'TWITTER: **'..user_id..'** - **'..name..'**: '..message..'')
  end})
end)

function sendToDiscord(name, message)
    if message == nil or message == '' or message:sub(1, 1) == '/' then return FALSE end
    local server = GetConvar("servernumber", "0")
    if server == "1" then
        PerformHttpRequest('https://discordapp.com/api/webhooks/539933234994085888/g1WNJRL4RiB_ujDFBhd3Azs-lIxW_mapRxrtm6O6gFGDxwHvU4TX-vbJaXq85b68e0Vq', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    elseif server == "2" then
        PerformHttpRequest('https://discordapp.com/api/webhooks/539933929034219521/NaNuyA97FOfxbwi4w2E6Is7nKV2XItHQ_-_G0vhsYiqKUSCkZnnhO_FbADioFq7vcCXY', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    elseif server == "3" then
        PerformHttpRequest('https://discordapp.com/api/webhooks/539933991109918726/6KHsesPuRJabwN14zmAH3Fs3BHVpEfpaLkYHYDd0tPb1HUKEy-rsO4CWFlJnElP7cRjY', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    elseif server == "4" then
        PerformHttpRequest('https://discordapp.com/api/webhooks/539934032134275083/d3gb__vB1xSGmdmrE1AXCVfF306iB4eVIkhT4xUurOs2zDIV5UOeFl-edA2iM7FWA6y0', function(err, text, headers) end, 'POST', json.encode({username = name, content = message}), { ['Content-Type'] = 'application/json' })
    end
end
