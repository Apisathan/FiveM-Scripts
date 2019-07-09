
ui_page 'html/index.html'

files {
	'html/index.html',
	'html/static/css/app.css',
	'html/static/js/app.js',
	'html/static/js/manifest.js',
	'html/static/js/vendor.js',

	'html/static/config/config.json',
	
	-- Coque
	'html/static/img/coque/oneplus6t.png',
	'html/static/img/coque/s9.png',
	'html/static/img/coque/iphonex.png',

	-- Background
	'html/static/img/background/01.jpg',
	'html/static/img/background/02.jpg',
	'html/static/img/background/03.jpg',
	'html/static/img/background/04.jpg',
	'html/static/img/background/05.jpg',
	'html/static/img/background/06.jpg',
	'html/static/img/background/07.jpg',
	'html/static/img/background/08.jpg',
	'html/static/img/background/09.jpg',
	'html/static/img/background/10.jpg',
	'html/static/img/background/11.jpg',
	'html/static/img/background/12.jpg',
	'html/static/img/background/13.jpg',
	'html/static/img/background/14.jpg',
	'html/static/img/background/15.jpg',
	'html/static/img/background/16.jpg',
	'html/static/img/background/17.jpg',
	'html/static/img/background/18.jpg',
	'html/static/img/background/19.jpg',
	'html/static/img/background/20.jpg',
	'html/static/img/background/21.jpg',
	'html/static/img/background/22.png',
	'html/static/img/background/23.png',
	'html/static/img/background/back001.jpg',
	'html/static/img/background/back002.jpg',
	'html/static/img/background/back003.jpg',
	
	'html/static/img/icons_app/call.png',
	'html/static/img/icons_app/contacts.png',
	'html/static/img/icons_app/sms.png',
	'html/static/img/icons_app/settings.png',
	'html/static/img/icons_app/menu.png',
	'html/static/img/icons_app/bourse.png',
	'html/static/img/icons_app/tchat.png',
	'html/static/img/icons_app/photo.png',
	'html/static/img/icons_app/bank.png',
	'html/static/img/icons_app/9gag.png',
	'html/static/img/icons_app/politi.png',
	'html/static/img/icons_app/mekaniker.png',
	'html/static/img/icons_app/advokat.png',
	'html/static/img/icons_app/taxi.png',
	'html/static/img/icons_app/ambulance.png',
	'html/static/img/icons_app/news.png',
	'html/static/img/icons_app/mobilepay.png',
	'html/static/img/icons_app/twitter.png',
	'html/static/img/icons_app/bilbasen.png',
	'html/static/img/icons_app/lommeregner.png',
	'html/static/img/icons_app/realestate.png',
	'html/static/img/icons_app/psykolog.png',
	'html/static/img/icons_app/guard.png',

	'html/static/img/app_mobilepay/splashmobilepay.png',
	'html/static/img/app_mobilepay/mobilepay.png',
	'html/static/img/app_news/splashnews.png',
	
	'html/static/img/app_twitter/splashtwitter.png',
	'html/static/img/app_twitter/profil.png',
	'html/static/img/app_twitter/twitter.png',

	'html/static/img/app_bank/logo.png',

	'html/static/img/app_tchat/splashtchat.png',

	'html/static/img/courbure.png',
	'html/static/fonts/fontawesome-webfont.ttf',

	'html/static/sound/ring.ogg',
	'html/static/sound/tchatNotification.ogg',
	'html/static/sound/Phone_Call_Sound_Effect.ogg',
	'html/static/sound/twitternotify.ogg',

}

client_script {
	"lib/Proxy.lua",
	"lib/Tunnel.lua",
	"config.lua",
	"client/animation.lua",
	"client/client.lua",

	"client/photo.lua",
	"client/app_tchat.lua",
	"client/bank.lua",
	"client/addons.lua",
	"client/app_mobilepay.lua",
	"client/app_twitter.lua",
	"client/app_news.lua",
	"client/emoji.lua",
}

server_script {
    "@vrp/lib/utils.lua",
	"config.lua",
	"server/server.lua",
	"server/addons.lua",
	"server/app_tchat.lua",
	"server/app_mobilepay.lua",
	"server/app_twitter.lua",
	"server/app_news.lua",
}
