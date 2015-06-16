gulp = require 'gulp'
browserify = require('browserify')
source = require('vinyl-source-stream')

gulp.task 'browserify', ->
  browserify('../src/app.coffee').bundle().pipe(source('bundle.js')).pipe gulp.dest('./build/')
