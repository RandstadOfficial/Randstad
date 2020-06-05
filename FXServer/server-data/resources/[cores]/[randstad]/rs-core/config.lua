RSConfig = {}

RSConfig.MaxPlayers = GetConvarInt('sv_maxclients', 32) -- Gets max players from config file, default 32
RSConfig.IdentifierType = "steam" -- Set the identifier type (can be: steam, license)
RSConfig.DefaultSpawn = {x=-1035.71,y=-2731.87,z=12.86,a=0.0}

RSConfig.Money = {}
RSConfig.Money.MoneyTypes = {['cash'] = 500, ['bank'] = 5000, ['crypto'] = 0 } -- ['type']=startamount - Add or remove money types for your server (for ex. ['blackmoney']=0), remember once added it will not be removed from the database!
RSConfig.Money.DontAllowMinus = {'cash', 'crypto'} -- Money that is not allowed going in minus

RSConfig.Player = {}
RSConfig.Player.MaxWeight = 120000 -- Max weight a player can carry (currently 120kg, written in grams)
RSConfig.Player.MaxInvSlots = 40 -- Max inventory slots for a player
RSConfig.Player.Bloodtypes = {
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
}

RSConfig.Server = {} -- General server config
RSConfig.Server.closed = false -- Set server closed (no one can join except people with ace permission 'rsadmin.join')
RSConfig.Server.closedReason = "Nog een klein beetje geduld..." -- Reason message to display when people can't join the server
RSConfig.Server.uptime = 0 -- Time the server has been up.
RSConfig.Server.whitelist = false -- Enable or disable whitelist on the server
RSConfig.Server.discord = "https://discord.gg/2DRbeFy" -- Discord invite link
RSConfig.Server.PermissionList = {} -- permission list