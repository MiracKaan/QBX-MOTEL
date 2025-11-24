fx_version 'cerulean'
game 'gta5'

name 'qbx-motel'
author 'Mirage'
version '2.0.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'

client_scripts {
    '@qbx_core/modules/playerdata.lua', 
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}
