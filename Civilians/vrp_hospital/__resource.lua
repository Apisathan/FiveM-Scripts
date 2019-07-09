dependency 'vrp'

server_scripts {
	'sv_hospital.lua'
}

client_script {
    "lib/Tunnel.lua",
    "lib/Proxy.lua",
	'cl_hospital.lua'
}