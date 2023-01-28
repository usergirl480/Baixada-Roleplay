fx_version "bodacious"
game { "gta5" }

use_fxv2_oal "yes"
lua54 "yes"

client_scripts {
    "@vrp/lib/vehicles.lua",
    "@vrp/lib/utils.lua",
    "src/shared/*",
    "src/vRP.lua",
    "src/client/**/*"
}

server_scripts {
    "@vrp/lib/vehicles.lua",
    "@vrp/lib/utils.lua",
    "src/shared/*",
    "src/sha256.lua",
    "src/vRP.lua",
    "src/server/**/*"
}