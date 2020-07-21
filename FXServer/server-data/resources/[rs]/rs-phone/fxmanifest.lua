fx_version 'bodacious'
games { 'gta5' }

author 'MaBo'
description 'Randstad Phone'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/*.js',
    'html/img/*.png',
    'html/img/backgrounds/*.jpg',
    'html/img/apps/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf'
}

client_scripts {
    'client/main.lua',
    'client/animations.lua'
}

server_scripts {
    'server/main.lua',
    'config.lua'
}

exports {
    'InPhone'
}