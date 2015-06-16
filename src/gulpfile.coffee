gulp = require 'gulp'
stylus = require 'gulp-stylus'
watch = require 'gulp-watch'
coffee = require 'gulp-coffee'

gulp.task 'stylus', ->
  gulp.src('./public/stylesheets/**/*.styl').pipe(stylus()).pipe gulp.dest('./public/stylesheets')
  return

gulp.task 'watch', ->
  gulp.watch './public/stylesheets/**/*.styl', [ 'stylus' ]
  return

gulp.task 'coffee', ->
  gulp.src('./src/*.coffee').pipe(coffee(bare: true)).pipe gulp.dest('./src/')
  return

gulp.task 'default', [
  'stylus'
  'watch'
  'coffee'
]

