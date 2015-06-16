var getTask, gulp;

gulp = require('gulp');

getTask = function(task) {
  return require('./src/gulp-tasks/' + task)(gulp);
};

gulp.task('stylus', getTask('stylus'));

gulp.task('coffee', getTask('coffee'));

gulp.task('watch', getTask('watch'));

gulp.task('default', ['stylus', 'coffee', 'watch']);
