stylus = require 'gulp-stylus'

module.exports = (gulp) ->
  ->
    gulp.src('../../public/assets/stylesheets/**/*.styl').pipe(stylus()).pipe gulp.dest('../../public/assets/stylesheets')
    return

