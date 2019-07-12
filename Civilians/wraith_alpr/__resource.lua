--[[-----------------------------------------------------------------------

    Wraith Radar System - v1.01
    Created by WolfKnight

-----------------------------------------------------------------------]]--

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "nui/radar.html"

files {
	"nui/digital-7.regular.ttf", 
	"nui/radar.html",
	"nui/radar.css",
	"nui/radar.js"
}

client_script {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"cl_radar.lua"
}