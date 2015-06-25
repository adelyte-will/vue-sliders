webpack = require 'webpack'
bourbon = require('node-bourbon').includePaths;

# Plugins
# ExtractTextPlugin = require 'extract-text-webpack-plugin'

# Config
module.exports =
  entry: './src/app'
  output:
    path: './dist'
    filename: 'app.js'
  module:
    loaders: [
      test: /\.coffee$/, loader: 'coffee'
    ,
      test: /\.css$/, loader: 'style!css'
    ,
      test: /\.scss$/, loader: "style!css!sass?includePaths[]=" + bourbon
    ,
      test: /\.jade$/, loader: 'jade'
    ,
      test: /\.(ttf|eot|svg|woff|woff2)(\?v=[0-9]\.[0-9]\.[0-9])?$/, loader: 'file-loader?name=assets/fonts/[name].[ext]'
    ,
      test: /\.json$/, loader: 'html?name=assets/data/[name].[ext]'
    ]
  resolve:
    modulesDirectories: ['src', 'node_modules', 'bower_components']
    extensions: ['', '.coffee']
  node:
    fs: 'empty'
  plugins: [
    new webpack.ProvidePlugin
      '_': 'lodash'
      'Vue': 'vue/dist/vue.js'
    # new webpack.ResolverPlugin(new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin('bower.json', ['main']))
  ]
