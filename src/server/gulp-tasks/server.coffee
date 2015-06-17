spawn = require('child_process').spawn
node = undefined

module.exports = (gulp) ->
  ->
    if node
      node.kill()
    node = spawn('coffee', [ './src/server/app.coffee' ], stdio: 'inherit')
    node.on 'close', (code) ->
      if code == 8
        gulp.log 'Error detected, waiting for changes...'
      return
    return

process.on 'exit', ->
  if node
    node.kill()
  return
