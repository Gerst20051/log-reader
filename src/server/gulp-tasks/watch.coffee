browserSync = require 'browser-sync'

module.exports = (gulp) ->
  ->
    gulp.watch './src/client/stylus/**/*.styl', [ 'stylus' ]
    gulp.watch './src/client/coffee/**/*.coffee', [ 'browserify' ]
    gulp.watch './views/**/*.pug', [
      'server',
      ->
        setTimeout browserSync.reload, 4e3
        return
    ]
    return
