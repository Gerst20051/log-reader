express = require 'express'
connect = require 'connect'
http = require 'http'
path = require 'path'
socketio = require 'socket.io'
Tail = require('tail').Tail

app = express()
server = http.createServer(app).listen 9099
io = socketio.listen server

app.set 'views', path.join(__dirname, '../views')
app.set 'view engine', 'jade'

app.get '/', (req, res) ->
    res.render 'index', {}
    return

console.log "Server listening on port 9099..."

fileName = '/var/log/syslog'
tail = new Tail fileName

tail.on 'line', (data) ->
    io.sockets.emit 'new-data',
        channel: 'stdout'
        value: data

io.sockets.on 'connection', (socket) ->
    socket.emit 'new-data',
        channel: 'stdout'
        value: "tail file #{fileName}"
