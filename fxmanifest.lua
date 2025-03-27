fx_version 'cerulean'
game 'gta5'

author 'Omes'
description 'Traffic Control System - Manage pedestrian, vehicle, and parked car density'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}


