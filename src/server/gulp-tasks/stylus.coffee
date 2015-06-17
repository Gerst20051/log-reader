stylus = require 'gulp-stylus'
debug = require 'gulp-debug'
concat = require 'gulp-concat'

module.exports = (gulp) ->
  ->
    gulp.src('./src/client/stylus/**/*.styl')
      .pipe(debug({ title: 'STYLUS FILE:' }))
      .pipe(stylus())
      .pipe(concat('main.css'))
      .pipe gulp.dest('./public/assets/css')
    return
