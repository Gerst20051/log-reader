browserify = require 'browserify'
glob = require 'glob'
source = require 'vinyl-source-stream'

module.exports = (gulp) ->
  ->
    #files = glob.sync('./src/client/coffee/**/*.coffee')
    files = glob.sync('./src/client/coffee/app.coffee')
    browserify({ entries: files })
      .bundle()
      .pipe(source('bundle.js'))
      .pipe gulp.dest('./public/assets/javascript/')
    return
