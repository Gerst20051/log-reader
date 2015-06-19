$ = require 'jquery'
io = require 'socket.io-client'
socket = io.connect 'passport-vagrant-image:9099'

$ ->
  container = $ '#logs'
  socket.on 'new-data', (data) ->
    if 0 != data.value.indexOf 'tail'
      newItem = $ '<div class="log-row">' + getRow(data.value) + '</div>'
      container.prepend newItem
    return
  return

getRow = (data) ->
  html = []
  html.push "<div class=\"log-row-data nowrap\">#{data}</div>"
  html.push "<div class=\"log-row-details\">#{data}</div>"
  return html.join ''

$ ->
  $('#logs').on 'click', '.log-row-data', (e) ->
    e.preventDefault()
    $(this).next().toggle()
    return
