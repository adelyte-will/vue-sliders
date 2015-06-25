# Dependencies
gulp = require 'gulp'
gutil = require 'gulp-util'
webpack = require 'webpack'
coffee = require 'gulp-coffee'
jade = require 'gulp-jade'
browser_sync = require 'browser-sync'
fs = require 'fs'
karma = require('karma').server

webpackConfig = require './webpack.config.coffee'

# Watcher
gulp.task 'watch', ['build'], (done) ->
  # Jade
  gulp.watch './src/**/*.jade', ['jade']

  # Webpack
  gulp.watch './src/**/*.coffee', ['webpack']
  gulp.watch './src/**/*.scss', ['webpack']

  done()

# Build
gulp.task 'build', ['webpack', 'jade']

# Webpack
gulp.task 'webpack', (done) ->
  webpack webpackConfig, (error, stats) ->
    if error
      throw new gutil.PluginError 'webpack', error

    gutil.log '[webpack]', stats.toString()

  done()

# Jade
gulp.task 'jade', (done) ->
  gulp.src './src/*.jade', base: 'src'
    .pipe jade pretty: true, locals: { web: true }
    .pipe gulp.dest './dist'


  done()

# Server
gulp.task 'serve', ->
  browser_sync
    open: false
    server:
      baseDir: './dist'
      middleware: [
        (request, response, next) ->
          response.setHeader 'Access-Control-Allow-Origin', '*'
          next()
      ]

# Test
gulp.task 'test', (done) ->
  gulp.src ['./karma.config.coffee']
    .pipe coffee bare: true
      .on 'error', gutil.log
    .pipe gulp.dest '.'

  karma.start
    configFile: "#{__dirname}/karma.config.js"
    singleRun: true
  , done
