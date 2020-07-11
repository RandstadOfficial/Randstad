module.exports = {
    // Update playerlist
    updatePlayerList: () => {
        var playerslist = {};

        for (i = 0; i < GetNumPlayerIndices(); i++) {
            Object.assign(playerslist, {id: i+1, name: GetPlayerName(i+1), ping: GetPlayerPing(i+1)})
        }

        return playerslist;
    },
};