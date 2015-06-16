coffee = require 'gulp-coffee'
debug = require 'gulp-debug'

module.exports = (gulp) ->
  ->
    gulp.src('./src/*.coffee').pipe(debug({title: 'ANDREW:'})).pipe(coffee(bare: true)).pipe gulp.dest('./build')
    return
