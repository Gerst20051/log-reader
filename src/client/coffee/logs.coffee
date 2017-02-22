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

addRows = (original_rows, rows) ->
  for row, index in rows
    addRow original_rows[index], row
  processingRows = false
  processRows()

addRow = (original_value, value) ->
  if 0 == original_value.indexOf 'tail'
    return
  $newLog = $ '<div class="log-row">' + value + '</div>'
  rowHasError = false
  errorArray.forEach (errorText) ->
    if -1 < original_value.indexOf errorText
      rowHasError = true
  rowHasBlacklistedError = false
  blacklistErrorArray.forEach (blacklistErrorText) ->
    if -1 < original_value.indexOf blacklistErrorText
      rowHasBlacklistedError = true
  if rowHasError is true and rowHasBlacklistedError is false
    $newLog.addClass 'alert-log-row'
    $('#errorLogs').prepend $newLog.clone()
  if $('body').hasClass 'paused'
    $('#hiddenLogs').prepend $newLog
  else
    parsedRows.unshift $newLog

worker.setResponseCallback addRows

$ ->
  socket.on 'new-data', (data) ->
    if typeof data.value is 'object'
      logRows = logRows.concat data.value
      if processingRows is false
        processRows()
  setInterval ( ->
    $('#normalLogs').children('.log-row:gt(' + config.default.setting.max_log_results + ')').remove()
  ), 60e3

processRows = ->
  logRowsLength = logRows.length
  if logRowsLength and processingRows is false
    processingRows = true
    worker.postMessage (
      type: 'request'
      config: config.default
      body_status:
        eyeopen: $('body').hasClass 'eyeopen'
      msg: logRows.splice(0, logRowsLength)
    )

highlightSyntax = ->
  SyntaxHighlighter.defaults['gutter'] = false
  SyntaxHighlighter.defaults['toolbar'] = false
  SyntaxHighlighter.highlight()

$ ->
  $('#logs').on 'click', '.log-row-data', (e) ->
    e.preventDefault()
    $(this).next().toggleClass('eyeopened')

prependLogs = ->
  parsedRowsLength = parsedRows.length
  $('#normalLogs').prepend parsedRows.splice(0, parsedRowsLength)

setInterval prependLogs, 0.25 * 1e3

setInterval highlightSyntax, 5e3

# errorArray.forEach (errorText) ->
#   nodeTextArray = nodeTextHTML.split(errorText)
#   nodeTextHTML = nodeTextArray.join('<span class="alert_text">' + errorText + '</span>')
#   return
