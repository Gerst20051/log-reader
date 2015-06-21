$ = require 'jquery'
io = require 'socket.io-client'
config = require './../../../config.yml'

socket = io.connect config.default.server.hostname + ':' + config.default.server.port
# socket2 = io.connect '10.0.1.12:8088'

$ ->
  container = $ '#logs'
  socket.on 'new-data', (data) ->
    if 0 != data.value.indexOf 'tail'
      if $('body').hasClass 'paused'
        newLog = $ '<div class="log-row hidden">' + getRow(data.value) + '</div>'
      else
        newLog = $ '<div class="log-row">' + getRow(data.value) + '</div>'
      if -1 < newLog.text().indexOf 'error'
        container.find('#errorLogs').prepend newLog.clone()
        newLog.addClass 'alert-log-row'
      container.find('#normalLogs').prepend newLog
    return
  # socket2.on 'new-data', (data) ->
  #   if 0 != data.value.indexOf 'tail'
  #     if $('body').hasClass 'paused'
  #       newLog = $ '<div class="log-row hidden">' + getRow(data.value) + '</div>'
  #     else
  #       newLog = $ '<div class="log-row">' + getRow(data.value) + '</div>'
  #     container.find('#normalLogs').prepend newLog
  #     if -1 < newLog.text().indexOf 'error'
  #       container.find('#errorLogs').prepend newLog
  #   return
  setInterval ( ->
    $('#logs #normalLogs').children('.log-row:gt(' + config.default.setting.max_log_results + ')').remove()
    return
  ), 60e3
  return

getRow = (data) ->
  html = []
  html.push "<div class=\"log-row-data\">#{data}</div>"
  if $('body').hasClass 'eyeopen'
    html.push "<div class=\"log-row-content eyeopened\">"
  else
    html.push "<div class=\"log-row-content\">"
  html.push "<div class=\"log-row-data-expanded\">#{data}</div>"
  if true
    html.push "<div class=\"log-row-details\">#{data}</div>"
  html.push "</div>"
  return html.join ''

$ ->
  $('#logs').on 'click', '.log-row-data', (e) ->
    e.preventDefault()
    $(this).next().toggleClass('eyeopened')
    return
