module.exports = {
    updatePlayerCount: (client, seconds) => {
        const interval = setInterval(function setStatus() {
            status = `${GetNumPlayerIndices()}/64 PLAYERS`

            client.user.setActivity(status, {type: 'WATCHING'})
            return updatePlayerCount;
        }(), seconds * 1000)
    }
}