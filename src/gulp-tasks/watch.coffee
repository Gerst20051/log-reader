module.exports = (gulp) ->
  ->
    gulp.watch '.public/assets/stylesheets/**/*.styl', [ 'stylus' ]
    return

