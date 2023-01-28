

fx_version "bodacious"
game { "gta5" }

client_scripts {
	"@vrp/lib/utils.lua",
	"src/client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"src/server/*"
}

files {
	"src/ui/*",
	"src/ui/**/*",
	"src/ui/**/**/*",
}

ui_page "src/ui/app.html"