'use strict';
// Generated on 2014-03-11 using generator-gulp-webapp 0.0.4

var gulp = require('gulp');
var wiredep = require('wiredep').stream;

// Load plugins
var $ = require('gulp-load-plugins')();

var paths = {
  'scripts_coffee': 'app/scripts/coffee/**/*.coffee',
  'scripts_js': 'app/scripts/js/**/*.js',
  'scripts_dest': 'app/scripts/js',
  'scripts_dist': 'dist/scripts/js'
};

// Scripts
gulp.task('scripts', function () {
  return gulp.src(paths.scripts_coffee)
  .pipe($.coffeelint())
  .pipe($.coffeelint.reporter())
  .pipe($.coffee())
  .pipe(gulp.dest(paths.scripts_dest))
  .pipe(gulp.dest(paths.scripts_dist));
});

// HTML
gulp.task('html', function () {
  return gulp.src('app/*.html')
  .pipe($.useref())
  .pipe(gulp.dest('dist'))
  .pipe($.size());
});

// Images
gulp.task('images', function () {
  return gulp.src('app/images/**/*')
  .pipe($.cache($.imagemin({
    optimizationLevel: 3,
    progressive: true,
    interlaced: true
  })))
  .pipe(gulp.dest('dist/images'))
  .pipe($.size());
});

// Fonts
gulp.task('fonts', function () {
  return gulp.src('app/fonts/*')
  .pipe(gulp.dest('dist/fonts'))
});

// Sounds
gulp.task('sounds', function () {
  return gulp.src('app/sounds/*.mp3')
  .pipe(gulp.dest('dist/sounds'))
});

// Clean
gulp.task('clean', function () {
  return gulp.src(['dist/scripts', 'dist/images'], {read: false}).pipe($.clean());
});

// Bundle
gulp.task('bundle', ['scripts'],
  $.bundle('./app/*.html', {
    appDir: 'app',
    buildDir: 'dist',
    minify: false
  })
);

// Build
gulp.task('build', ['html', 'bundle', 'images', 'fonts', 'sounds']);

// Default task
gulp.task('default', ['clean'], function () {
  gulp.start('build');
});

// Connect
gulp.task('connect', $.connect.server({
  root: ['app'],
  port: 9000,
  livereload: true
}));

// Inject Bower components
gulp.task('wiredep', function () {
  gulp.src('app/styles/*.scss')
  .pipe(wiredep({
    directory: 'app/bower_components',
    ignorePath: 'app/bower_components/'
  }))
  .pipe(gulp.dest('app/styles'));

  gulp.src('app/*.html')
  .pipe(wiredep({
    directory: 'app/bower_components',
    ignorePath: 'app/'
  }))
  .pipe(gulp.dest('app'));
});

// Watch
gulp.task('watch', ['connect'], function () {
    // Watch for changes in `app` folder
    gulp.watch([
      'app/*.html',
      paths.scripts_coffee,
      'app/images/**/*'
      ], function(event) {
        return gulp.src(event.path)
        .pipe($.connect.reload());
      });


    // Watch .js files
    gulp.watch(paths.scripts_coffee, ['scripts']);

    // Watch image files
    gulp.watch('app/images/**/*', ['images']);

    // Watch bower files
    gulp.watch('app/bower_components/*', ['wiredep']);
  });
