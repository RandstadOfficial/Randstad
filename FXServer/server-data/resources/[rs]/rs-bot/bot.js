const { Client } = require('discord.js');
const client = new Client;

global.config = require("./config.json")

client.on('ready', () => {
    console.log(`Discord Bot logged in as ${client.user.tag}`);
});

client.login(config.token);