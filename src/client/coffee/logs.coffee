$ = require 'jquery'
io = require 'socket.io-client'
worker = require './webworkers.coffee'
config = require './../../../config.yml'

socket = io.connect config.default.server.hostname + ':' + config.default.server.port

logRows = []
parsedRows = []
processingRows = false

errorArray = [
  'Error'
  'error'
  'Exception'
  'exception'
  'Fatal'
  'fatal'
  'PDOException'
  'STDERR'
  'Undefined'
  'undefined'
  'Warning'
  'warning'
]

blacklistErrorArray = [
  'Paypal not configured for this operator'
]

addRow = (original_value, value) ->
  if 0 == original_value.indexOf 'tail'
    return
  $newLog = $ '<div class="log-row">' + value + '</div>'
  rowHasError = false
  errorArray.forEach (errorText) ->
    if -1 < original_value.indexOf errorText
      rowHasError = true
    return
  rowHasBlacklistedError = false
  blacklistErrorArray.forEach (blacklistErrorText) ->
    if -1 < original_value.indexOf blacklistErrorText
      rowHasBlacklistedError = true
    return
  if rowHasError is true and rowHasBlacklistedError is false
    $newLog.addClass 'alert-log-row'
    $('#errorLogs').prepend $newLog.clone()
  if $('body').hasClass 'paused'
    $('#hiddenLogs').prepend $newLog
  else
    parsedRows.unshift $newLog
  return

worker.setResponseCallback addRow

$ ->
  socket.on 'new-data', (data) ->
    if typeof data.value is 'object'
      logRows = logRows.concat data.value
      if processingRows is false
        processRows()
    return
  setInterval ( ->
    $('#normalLogs').children('.log-row:gt(' + config.default.setting.max_log_results + ')').remove()
    return
  ), 60e3
  return

processRows = ->
  if logRows.length
    worker.postMessage (
      type: 'request'
      config: config.default
      body_status:
        eyeopen: $('body').hasClass 'eyeopen'
      msg: logRows.shift()
    )
    setTimeout processRows, 0
  else
    processingRows = false

# highlightSyntax()
highlightSyntax = ->
  # SyntaxHighlighter.defaults['gutter'] = false
  # SyntaxHighlighter.defaults['toolbar'] = false
  # SyntaxHighlighter.all()
  # SyntaxHighlighter.highlight()
  return

$ ->
  $('#logs').on 'click', '.log-row-data', (e) ->
    e.preventDefault()
    $(this).next().toggleClass('eyeopened')
    return

prependLogs = ->
  parsedRowsLength = parsedRows.length
  $('#normalLogs').prepend parsedRows.splice(0, parsedRowsLength)

setInterval prependLogs, 0.2 * 1e3

# errorArray.forEach (errorText) ->
#   nodeTextArray = nodeTextHTML.split(errorText)
#   nodeTextHTML = nodeTextArray.join('<span class="alert_text">' + errorText + '</span>')
#   return
