$(document).ready ->
  socket = io.connect('http://localhost:9099')
  container = $('#container')
  socket.on 'new-data', (data) ->
    newItem = $('<div>' + data.value + '</div>')
    container.append newItem
    return
  return
