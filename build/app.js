var greetings, io, path, socket;

path = require('path');

greetings = require('.' + __dirname + '/greetings');

alert(greetings('Andrew'));

io = require('socket.io-client');

socket = io('http://localhost');
