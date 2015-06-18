$ = require 'jquery'
greetings = require './greetings.coffee'

console.log 'Greeting', greetings 'Andrew'
$ ->
    $('body').append 'hey andrew!'

io = require 'socket.io-client'
socket = io 'http://passport-vagrant-image:9099'
