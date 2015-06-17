coffee = require 'gulp-coffee'
debug = require 'gulp-debug'

module.exports = (gulp) ->
  ->
    gulp.src('./src/client/coffee/**/*.coffee')
      .pipe(debug({ title: 'COFFEE FILE:' }))
      .pipe(coffee(bare: true))
      .pipe gulp.dest('./build')
    return
