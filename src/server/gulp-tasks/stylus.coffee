stylus = require 'gulp-stylus'
debug = require 'gulp-debug'
plumber = require 'gulp-plumber'
concat = require 'gulp-concat'
minifyCss = require 'gulp-minify-css'
sourcemaps = require 'gulp-sourcemaps'
browserSync = require 'browser-sync'

module.exports = (gulp) ->
  ->
    gulp.src('./src/client/stylus/**/*.styl')
      .pipe debug({ title: 'STYLUS FILE:' })
      .pipe plumber()
      .pipe stylus()
      .pipe plumber.stop()
      .pipe concat('main.css')
      .pipe sourcemaps.init()
      .pipe minifyCss()
      .pipe sourcemaps.write()
      .pipe gulp.dest('./public/assets/css')
      .pipe browserSync.reload({ stream: true })
    return
