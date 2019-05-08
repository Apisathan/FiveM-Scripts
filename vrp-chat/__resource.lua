--
-- Created by IntelliJ IDEA.
-- User: Apisathan
-- Date: 11-01-2019
-- Time: 20:22
-- Github: https://github.com/Apisathan/FiveM-Scripts
--

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency 'vrp'

server_scripts {
    '@vrp/lib/utils.lua',
    'server.lua'
}

client_scripts {
    'client.lua'
}