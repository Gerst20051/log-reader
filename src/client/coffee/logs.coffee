$ = require 'jquery'
io = require 'socket.io-client'
config = require './../../../config.yml'

socket = io.connect config.default.server.hostname + ':' + config.default.server.port

lineRegex = /((\w*)(->|::|GLOBAL:?)(\w*))(\[)(.*)(:)(\d*)(\])(:)((.*)( =>)(.*))?(.*)/;

errorArray = [
  'EMPTY'
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

loglevelArray = [
  'EMERG'    # system is unusable
  'ALERT'    # action must be taken immediately
  'CRIT'     # critical conditions
  'ERR'      # error conditions
  'WARNING'  # warning conditions
  'NOTICE'   # normal, but significant, condition
  'INFO'     # informational message
  'DEBUG'    # debug-level message
]

mysqlTerms = [
  'CREATE'
  'DROP'
  'SELECT'
  'UPDATE'
  'DELETE'
  'SHOW'
  'ALTER'
  'TRUNCATE'
]

# errorArray.forEach (errorText) ->
#   nodeTextArray = nodeTextHTML.split(errorText)
#   nodeTextHTML = nodeTextArray.join('<span class="alert_text">' + errorText + '</span>')
#   return

$ ->
  socket.on 'new-data', (data) ->
    if 0 != data.value.indexOf 'tail'
      addRow(data.value)
    return
  setInterval ( ->
    $('#logs #normalLogs').children('.log-row:gt(' + config.default.setting.max_log_results + ')').remove()
    return
  ), 60e3
  return

addRow = (value) ->
  $container = $ '#logs'
  $newLog = $ '<div class="log-row">' + getRow(value) + '</div>'
  rowHasError = false
  errorArray.forEach (errorText) ->
    if -1 < value.indexOf errorText
      rowHasError = true
    return
  if rowHasError is true
    $newLog.addClass 'alert-log-row'
    $container.find('#errorLogs').prepend $newLog.clone()
  if $('body').hasClass 'paused'
    $container.find('#hiddenLogs').prepend $newLog
  else
    $container.find('#normalLogs').prepend $newLog
  return

getRow = (data) ->
  html = []
  matches = data.match(/^(\w{3} \d{2}) (\d{2}:\d{2}:\d{2}) (.*) (V\d+):(.*) \(log level = (\d)\)$/)
  if matches and matches.length
    date = matches[1]
    time = matches[2]
    # leftdata = matches[3]
    # version = matches[4]
    realdata = matches[5]
    loglevel = matches[6]
    loglevel_formatted = loglevelArray[loglevel]
    loglevel_classname = loglevel_formatted.toLowerCase()
    html.push "<div class=\"log-row-time\">#{time}</div>"
    html.push "<div class=\"log-row-loglevel loglevel-#{loglevel_classname}\">#{loglevel_formatted}</div>"
  else
    datematches = data.match(/^(\w{3} \d{2}) (\d{2}:\d{2}:\d{2}) (.*)$/)
    if datematches and datematches.length
      time = datematches[2]
      realdata = datematches[3]
      systemmatches = realdata.match(new RegExp(config.default.server.hostname + ' (\\w*)(\\[\\d*\\])?: (.*)'))
      if systemmatches and systemmatches.length
        service = systemmatches[1].toUpperCase()
        service_classname = service.toLowerCase()
        realdata = systemmatches[3]
      else
        service = 'SYSTEM'
        service_classname = 'system'
      html.push "<div class=\"log-row-time\">#{time}</div>"
      html.push "<div class=\"log-row-loglevel loglevel-#{service_classname}\">#{service}</div>"
    else
      realdata = data
  linematches = realdata.match(lineRegex)
  parsedline = buildLine(linematches, realdata)
  html.push "<div class=\"log-row-data\">#{parsedline}</div>"
  if $('body').hasClass 'eyeopen'
    html.push "<div class=\"log-row-content eyeopened\">"
  else
    html.push "<div class=\"log-row-content\">"
  html.push "<div class=\"log-row-data-expanded\">#{parsedline}</div>"
  if linematches and linematches.length and linematches[14]
    syntaxhtml = addSyntaxHighlightingToNode(linematches[14])
    if syntaxhtml and syntaxhtml.length
      html.push "<div class=\"log-row-details\">#{syntaxhtml}</div>"
      # highlightSyntax()
  html.push "</div>"
  return html.join ''

buildLine = (matches, line) ->
  newline = []
  newline.push '<span>'
  if matches and matches.length
    if matches[1] == 'GLOBAL' and matches[3] == 'GLOBAL'
      newline.push '<span class="color_turquoise">GLOBAL</span>'
    else if matches[3] == 'GLOBAL:'
      newline.push '<span class="color_turquoise">GLOBAL</span>'
      newline.push '<span>:</span>'
      newline.push '<span class="color_peterriver">', matches[4], '</span>'
    else
      newline.push '<span class="color_emerland">', matches[2], '</span>'
      newline.push '<span>', matches[3], '</span>'
      newline.push '<span class="color_peterriver">', matches[4], '</span>'
    newline.push '<span>', matches[5], '</span>'
    newline.push '<span class="color_orange">', matches[6], '</span>'
    newline.push '<span>', matches[7], '</span>'
    newline.push '<span class="color_wetasphalt">', matches[8], '</span>'
    newline.push '<span>', matches[9], '</span>'
    if not matches[11]
      newline.push '<span class="color_pomegranate">', matches[10], '</span>'
      newline.push '<span class="color_midnightblue">', matches[15], '</span>'
    else
      newline.push '<span>', matches[10], '</span>'
      newline.push '<span class="color_amethyst">', matches[12], '</span>'
      newline.push '<span>', matches[13], '</span>'
      newline.push '<span class="color_greensea">', matches[14], '</span>'
  else
    newline.push line
  newline.push '</span>'
  newline.join ''

highlightSyntax = ->
  # SyntaxHighlighter.defaults['gutter'] = false
  # SyntaxHighlighter.defaults['toolbar'] = false
  # SyntaxHighlighter.all()
  # SyntaxHighlighter.highlight()
  return

addSyntaxHighlightingToNode = (data) ->
  matchedMysqlTerms = false
  mysqlTerms.forEach (mysqlTerm) ->
    if 1 == data.indexOf(mysqlTerm)
      matchedMysqlTerms = true
    return
  if matchedMysqlTerms == true # MYSQL
    return '<div><pre class="brush: sql">' + data.trim() + '</pre></div>' # vkbeautify.sql(data.trim())
  else if 1 == data.indexOf('[') or 1 == data.indexOf('{') # JSON
    return '<div><pre class="brush: js">' + JSON.stringify(JSON.parse(data.trim()), null, 4) + '</pre></div>'
  return

$ ->
  $('#logs').on 'click', '.log-row-data', (e) ->
    e.preventDefault()
    $(this).next().toggleClass('eyeopened')
    return
