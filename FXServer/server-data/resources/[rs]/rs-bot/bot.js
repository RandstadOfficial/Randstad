const { Client } = require('discord.js');
const client = new Client;
const { updatePlayerCount } = require("./utils/PlayerCount")

const maxPlayers = GetConvarInt('sv_maxclients')

global.config = require("./config.json")

client.on('ready', () => {
    console.log(`Discord Bot logged in as ${client.user.tag}`);
    updatePlayerCount(client, maxPlayers, 5)
});

client.login(config.token);