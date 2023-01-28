

fx_version 'bodacious'
game 'gta5'

ui_page 'assets/index.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'shared/*.lua',
	'client.lua',
}

server_scripts {
	'@vrp/lib/utils.lua',
	"@vrp/lib/itemlist.lua",
	'shared/*.lua',
	'server.lua',
}

files {
	'assets/*'
}