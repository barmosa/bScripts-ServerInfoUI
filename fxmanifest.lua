fx_version 'cerulean'
game 'gta5'

author 'bScripts'
description 'bScripts | Logo UI'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    'config/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'html/index.html',
    'html/styles.css',
    'html/script.js'
}
