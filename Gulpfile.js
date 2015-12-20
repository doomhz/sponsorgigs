require('coffee-script').register();

var fs        = require("fs");
var dirsum    = require("dirsum");
var crypto    = require("crypto");
var gulp      = require("gulp");
var stylus    = require("gulp-stylus");
var rename    = require("gulp-rename");
var minifycss = require("gulp-minify-css");
var coffee    = require('gulp-coffee');
var uglify    = require('gulp-uglify');
var changed   = require('gulp-changed');
var env       = process.env.NODE_ENV || 'development';
var force     = process.env.GULP_FORCE || false;

var paths = {
  styles: [
    'assets/css/master.styl'
  ],
  scripts: 'assets/js/**/*.coffee',
  vendor_scripts: [
    // 'public/js/vendor/wheel_canvas.js'
  ],
  coffee: []
};

gulp.task('styles', function() {
  var dest = 'public/css';
  var t = gulp.src(paths.styles, {base: 'assets/css/'})
  if (env !== 'production' && !force) {
    t.pipe(changed(dest, {extension: '.css'}))
  }
  t.pipe(stylus())
  .pipe(gulp.dest(dest))
  if (env === 'production') {
    t.pipe(rename({suffix: '.min'}))
    // .pipe(minifycss())
    .pipe(gulp.dest(dest));
  }
  return t;
});

gulp.task('scripts', function() {
  var dest = 'public/js';
  var t = gulp.src(paths.scripts, {base: 'assets/js/'})
  if (env !== 'production' && !force) {
    t.pipe(changed(dest, {extension: '.js'}))
  }
  if (env === 'production') {
    t.pipe(coffee({bare: true})).pipe(gulp.dest(dest)).pipe(rename({suffix: '.min'})).pipe(uglify()).pipe(gulp.dest(dest));
  } else {
    t.pipe(coffee({bare: true})).pipe(gulp.dest(dest));
  }
  return t;
});

gulp.task('vendor_scripts', function() {
  var dest = 'public/js/vendor';
  return gulp.src(paths.vendor_scripts, {base: 'public/js/vendor'})
  .pipe(rename({suffix: '.min'}))
  .pipe(uglify())
  .pipe(gulp.dest(dest));
});

gulp.task('coffee', function() {
  var coffeePaths = paths.coffee;
  var dest = null;
  for (var i = 0; i < coffeePaths.length; i++){
    dest = coffeePaths[i].substr(0, coffeePaths[i].indexOf("/") + 1);
    gulp.src(coffeePaths[i])
    .pipe(coffee({bare: true}))
    .pipe(gulp.dest(dest));
  }
  return;
});

gulp.task('digest_assets', function() {
  dirsum.digest('assets/css', 'sha1', function(err, hashes) {
    if (err) throw err;
    console.log("CSS digest: " + hashes.hash);
    fs.writeFileSync(process.cwd() + "/css.digest", hashes.hash)
    dirsum.digest('assets/js', 'sha1', function(err, hashes) {
      if (err) throw err;
      console.log("JS digest: " + hashes.hash);
      dirsum.digest('public/js/vendor', 'sha1', function(err, hashesVendor) {
        if (err) throw err;
        console.log("JS vendor digest: " + hashesVendor.hash);
        var jsHash = crypto.createHash("sha1").update(hashes.hash + hashesVendor.hash, "utf8").digest("hex")
        console.log("JS final digest: " + jsHash);
        fs.writeFileSync(process.cwd() + "/js.digest", jsHash)
        dirsum.digest('public/img', 'sha1', function(err, hashes) {
          if (err) throw err;
          console.log("IMG digest: " + hashes.hash);
          fs.writeFileSync(process.cwd() + "/img.digest", hashes.hash)
          return;
        });
      });
    });
  });
});

gulp.task('watch', function() {
  gulp.watch(paths.styles, ['styles']);
  gulp.watch(paths.scripts, ['scripts']);
  gulp.watch(paths.coffee, ['coffee']);
});

gulp.task('watch_scripts', function() {
  gulp.watch(paths.scripts, ['scripts']);
});

gulp.task('watch_styles', function() {
  gulp.watch(paths.styles, ['styles']);
});

gulp.task('default', ['watch', 'scripts', 'styles', 'coffee']);
