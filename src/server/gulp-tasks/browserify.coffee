glob = require 'glob'
browserify = require 'browserify'
source = require 'vinyl-source-stream'
buffer = require 'vinyl-buffer'
sourcemaps = require 'gulp-sourcemaps'
uglify = require 'gulp-uglify'
browserSync = require 'browser-sync'

module.exports = (gulp) ->
  ->
    files = glob.sync('./src/client/coffee/app.coffee')
    browserify({ entries: files })
      .bundle()
      .pipe source('bundle.js')
      .pipe buffer()
      .pipe sourcemaps.init()
      .pipe uglify()
      .pipe sourcemaps.write()
      .pipe gulp.dest('./public/assets/javascript/')
    setTimeout browserSync.reload, 1e3
    return
