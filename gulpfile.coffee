gulp = require('gulp')

getTask = (task) ->
  require('./src/server/gulp-tasks/' + task) gulp

gulp.task 'browserify', getTask('browserify')
gulp.task 'stylus', getTask('stylus')
gulp.task 'watch', getTask('watch')
gulp.task 'server', getTask('server')
gulp.task 'browser-sync', getTask('browser-sync')
gulp.task 'default', [ 'browserify', 'stylus', 'watch', 'server', 'browser-sync' ]
