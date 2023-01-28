

fx_version "cerulean"
game "gta5"
lua54 "yes"

ui_page "ui/index.html"
shared_script "shared.lua"

client_scripts {
	'@vrp/lib/utils.lua',
	"client/**/*.lua"
}

server_scripts {
	'@vrp/lib/utils.lua',
	"server/**/*.lua"
}

files {
	"ui/*.ogg",
	"ui/css/*.css",
	"ui/js/*.js",
	"ui/index.html"
}