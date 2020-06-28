
module.exports = {
    updatePlayerCount: (client, maxPlayers, seconds) => {
        const interval = setInterval(function setPlayerCount() {
            status = `${GetNumPlayerIndices()}/${maxPlayers} SPELERS`
            // status = `10000000/64 SPELERS`
            client.user.setActivity(status, {type: 'WATCHING'})

            return setPlayerCount;
        }(), seconds * 1000)
    }
}