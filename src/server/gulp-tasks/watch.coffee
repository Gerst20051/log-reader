module.exports = (gulp) ->
  ->
    gulp.watch './src/client/stylus/**/*.styl', [ 'stylus' ]
    gulp.watch './src/client/coffee/**/*.coffee', [ 'browserify' ]
    return
