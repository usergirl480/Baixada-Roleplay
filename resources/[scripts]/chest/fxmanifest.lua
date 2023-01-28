

fx_version "bodacious"
game "gta5"

ui_page "src/ui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"src/vRP.lua",
	"src/client/*"
}

server_scripts {
	"@vrp/lib/itemlist.lua",
	"@vrp/lib/utils.lua",
	"src/vRP.lua",
	"src/server/*"
}

files {
	"src/ui/*"
}