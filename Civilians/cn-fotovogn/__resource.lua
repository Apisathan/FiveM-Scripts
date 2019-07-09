--
-- Created by IntelliJ IDEA.
-- User: Sling
-- Date: 26-03-2019
-- Time: 20:27
-- Made for CiviliansNetwork
--

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
dependency "vrp"

client_scripts{ 
  "Proxy.lua",
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "server.lua"
}