gulp = require 'gulp'
watch = require 'gulp-watch'
shell = require 'gulp-shell'
plumber = require 'gulp-plumber'
path = require 'path'
livereload = require 'gulp-livereload'

rootPath = path.join(__dirname, '../')
srcs = path.join(__dirname, '../src/**/*.hx')
swf = path.join(__dirname, '../export/game.swf')
tests = path.join(__dirname, '../test/model/**/*.hx')

gulp.task 'default', ->
  livereload.listen()

  watch(srcs)
    .on 'error', (e)->
      console.log e
    .on 'change', (path) ->
      gulp.src path
        .pipe plumber()
        .pipe shell([
          'echo '
          'echo building'
          'haxe "compile.hxml"'
          'echo built'
          #'cp -f ../export/built.swf ../for_air/game.swf'
          '$AIR_HOME/bin/mxmlc -load-config=config.xml ../export/as3/__main2__.as -output ../export/built.swf'
          'cp -f ../export/built.swf ../export/game.swf'
          'cp -f ../export/game.swf ../for_air/game.swf'
        ], {})

  watch(swf)
    .on 'error', (e)->
      console.log e
    .on 'change', (path) ->
      gulp.src swf
        .pipe livereload()

gulp.task 'munit', ->
  watch(tests).on 'change', (path) ->
    console.log path
    gulp.src path
      .pipe plumber()
      .pipe shell([
        "cd #{rootPath}; haxelib run munit test -as"
      ], {})
