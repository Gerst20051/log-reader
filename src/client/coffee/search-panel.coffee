$ = require 'jquery'

$ ->
  $('#searchPanel').on 'change', '.searchInput', ->
    switch $(this).attr('id')
      when 'filterText' then filterText()
      when 'highlightText' then highlightText()
      when 'excludeText' then excludeText()
      else console.log 'unknown search input'
    return
  return

filterText = ->
  console.log $('#filterText').val()
  return

highlightText = ->
  console.log $('#highlightText').val()
  return

excludeText = ->
  console.log $('#excludeText').val()
  return
