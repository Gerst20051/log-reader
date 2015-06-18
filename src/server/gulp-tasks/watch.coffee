browserSync = require 'browser-sync'

module.exports = (gulp) ->
  ->
    gulp.watch './src/client/stylus/**/*.styl', [ 'stylus' ]
    gulp.watch './src/client/coffee/**/*.coffee', [ 'browserify' ]
    gulp.watch './views/**/*.jade', [
      'server',
      ->
        setTimeout browserSync.reload, 4e3
        return
    ]
    return
