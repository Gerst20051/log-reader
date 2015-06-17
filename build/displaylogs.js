$(document).ready(function() {
  var container, socket;
  socket = io.connect('http://localhost:9099');
  container = $('#container');
  socket.on('new-data', function(data) {
    var newItem;
    newItem = $('<div>' + data.value + '</div>');
    container.append(newItem);
  });
});
