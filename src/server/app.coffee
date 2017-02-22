yaml = require 'node-yaml-config'
path = require 'path'
express = require 'express'
http = require 'http'
socketio = require 'socket.io'
favicon = require 'serve-favicon'
Tail = require('tail').Tail
routes = require '../../routes/index'

config = yaml.load(path.join(__dirname, '../../config.yml'))
port = config.server.port

app = express()
server = http.createServer(app).listen port
io = socketio.listen server

app.use favicon(path.join(__dirname, '../../public/assets/favicon.ico'))
app.use '/', routes
app.use '/public', express.static(path.join(__dirname, '../../public'))
app.set 'views', path.join(__dirname, '../../views')
app.set 'view engine', 'pug'

console.log "Server listening on port #{port}..."

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
