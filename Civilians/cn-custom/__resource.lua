resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

dependency "vrp"

client_scripts {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
    "lib/enum.lua",
    "client/vinduerul.lua",
    "client/npcplatechanger.lua",
    "client/lift.lua",
    "client/autopilot.lua",
}

server_scripts {
    "@vrp/lib/utils.lua",
    "server/drift.lua",
    "server/lift.lua",
    "server/vinduerul.lua",
}
