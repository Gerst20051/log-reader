coffee = require 'gulp-coffee'
debug = require 'gulp-debug'
plumber = require 'gulp-plumber'

module.exports = (gulp) ->
  ->
    gulp.src('./src/client/coffee/**/*.coffee')
      .pipe debug({ title: 'COFFEE FILE:' })
      .pipe plumber()
      .pipe coffee(bare: true)
      .pipe plumber.stop()
      .pipe gulp.dest('./build')
    return
