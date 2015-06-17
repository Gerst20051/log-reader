express = require 'express'
connect = require 'connect'
favicon = require 'serve-favicon'
http = require 'http'
path = require 'path'
socketio = require 'socket.io'
Tail = require('tail').Tail
routes = require '../../routes/index'

app = express()
server = http.createServer(app).listen 9099
io = socketio.listen server

app.use favicon(path.join(__dirname, '../../public/assets/favicon.ico'))
app.use '/', routes
app.use '/public', express.static(path.join(__dirname, '../../public'))
app.set 'views', path.join(__dirname, '../../views')
app.set 'view engine', 'jade'

console.log "Server listening on port 9099..."

fileName = '/var/log/syslog'
tail = new Tail fileName

tail.on 'line', (data) ->
    io.sockets.emit 'new-data',
        channel: 'stdout'
        value: data

# io.sockets.on 'connection', (socket) ->
#     socket.emit 'new-data',
#         channel: 'stdout'
#         value: "tail file #{fileName}"
