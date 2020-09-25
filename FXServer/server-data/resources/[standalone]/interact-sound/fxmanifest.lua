-- FXVersion Version
fx_version 'adamant'
games { 'gta5' }

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page "client/html/index.html"

-- Files needed for NUI
files {
    'client/html/index.html',
    'client/html/sounds/*.ogg',
}
