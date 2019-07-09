--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 11-01-2019
-- Time: 20:22
-- Made for CiviliansNetwork
--
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts{
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "lib/enum.lua",
    "config.lua",
    "client.lua",
}

server_scripts{
    "@vrp/lib/utils.lua",
    "config.lua",
    "server.lua",
}
