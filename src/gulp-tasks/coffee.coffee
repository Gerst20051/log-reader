coffee = require 'gulp-coffee'

module.exports = (gulp) ->
  ->
    gulp.src('../*.coffee').pipe(coffee(bare: true)).pipe gulp.dest('../')
    return
