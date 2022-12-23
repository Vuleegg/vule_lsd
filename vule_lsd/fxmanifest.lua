fx_version 'cerulean'
game 'gta5'
deskripcija 'za kurcenje'
autor 'vulegg'

lua54 'yes'
shared_script '@ox_lib/init.lua'

client_script {
    'client/**.lua',
    'config.lua'
}

server_script {
    'server/**.lua',
    'config.lua'
}

dependencies {
    'es_extended',
    'ox_lib'
}