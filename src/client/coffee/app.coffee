path = require 'path'
greetings = require(path.join(__dirname, 'greetings'))
alert greetings('Andrew')

io = require 'socket.io-client'
socket = io('http://localhost')
