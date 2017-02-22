worker = new Worker('./log-worker.coffee')

worker.setResponseCallback = (callback) ->
  worker.callback = callback
  return

worker.onmessage = (e) ->
  result = e.data
  if result.type is 'debug'
    console.log result.type, result.msg
  else if result.type is 'response'
    worker.callback result.original_msg, result.msg
  return

module.exports = worker
