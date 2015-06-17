gulp = require('gulp')

getTask = (task) ->
  require('./src/server/gulp-tasks/' + task) gulp

gulp.task 'browserify', getTask('browserify')
gulp.task 'stylus', getTask('stylus')
gulp.task 'coffee', getTask('coffee')
gulp.task 'watch', getTask('watch')
gulp.task 'default', [ 'browserify', 'stylus', 'coffee', 'watch' ]
