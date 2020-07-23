const express =  require('express');
const app = express();
const http = require('http').createServer(app);

// Setup sockets
const socketio = require('socket.io');
const io = socketio(http);


const functions = require('./utils/functions.js');

try {
    eval('GetResourcePath(GetCurrentResourceName())');
    runningOnFivem = true;
  } catch(e) {}

  app.use(express.json());

  http.listen(1997, (err, res) => {
    console.log(`Everything looks good ! Have fun`);
    console.log(`Listening on "localhost:1997" `);
  });

  app.get('/', (err, res) => {
    res.send({
        uptime: process.uptime(),
        resourcesCount: GetNumResources(),
        playerCount: GetNumPlayerIndices(),
        queueCount: exports.connectqueue.rsQueueSize(),
    })
  });

  app.get('/playerlist', (err, res) => {
      res.send({
        players: functions.updatePlayerList()
      })
  });


  io.on('connect', (socket) => {
    console.log('App connected to socket');

    socket.on('refreshQueue', () => {
        socket.emit('getQueueList', {
            uptime: process.uptime(),
            resourcesCount: GetNumResources(),
            playerCount: GetNumPlayerIndices(),
            queueCount: exports.connectqueue.rsQueueSize(),
        });
    });

    socket.on('disconnect', () => {
        console.log('App disconnected from socket');
    });
  });


app.get('/maestro', (err, res) => {
    res.send("Maestro is noob");
});
