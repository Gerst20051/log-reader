$ = require 'jquery'
greetings = require './greetings.coffee'
require './logs.coffee'
require './control-panel.coffee'
require './search-panel.coffee'

console.log 'Greeting', greetings 'Passport'

$ ->
  $('#logs').on 'mouseover', '.log-row', (e) ->
    $(this).delay(0.5 * 1e3).queue ->
      $(this).find('.log-row-data').addClass 'enable-hover'
      return
    return
  $('#logs').on 'mouseleave', '.log-row', (e) ->
    $(this).find('.log-row-data').removeClass 'enable-hover'
    $(this).finish()
    return
  return
