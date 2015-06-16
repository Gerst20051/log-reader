var Tail, app, connect, express, fileName, http, io, path, server, socketio, tail;

express = require('express');

connect = require('connect');

http = require('http');

path = require('path');

socketio = require('socket.io');

Tail = require('tail').Tail;

app = express();

server = http.createServer(app).listen(9099);

io = socketio.listen(server);

app.set('views', path.join(__dirname, '../views'));

app.set('view engine', 'jade');

app.get('/', function(req, res) {
  res.render('index', {});
});

console.log("Server listening on port 9099...");

fileName = '/var/log/syslog';

tail = new Tail(fileName);

tail.on('line', function(data) {
  return io.sockets.emit('new-data', {
    channel: 'stdout',
    value: data
  });
});

io.sockets.on('connection', function(socket) {
  return socket.emit('new-data', {
    channel: 'stdout',
    value: "tail file " + fileName
  });
});
