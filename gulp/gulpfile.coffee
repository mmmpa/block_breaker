gulp = require 'gulp'
watch = require 'gulp-watch'
shell = require 'gulp-shell'
plumber = require 'gulp-plumber'
path = require 'path'
livereload = require 'gulp-livereload'

srcs = '../src/**/*.hx'
swf = path.join(__dirname, '../export/game.swf')

gulp.task 'default', ->
  livereload.listen()

  watch(srcs).on 'change', (path) ->
    gulp.src path
      .pipe plumber()
      .pipe shell([
        'echo '
        'echo building'
        'haxe "compile.hxml"'
        'echo builded'
      ], templateData: outpath: (s) ->
        s.replace /\.c/, '.out'
      )

  watch(swf).on 'change', (path) ->
    gulp.src swf
      .pipe livereload()
