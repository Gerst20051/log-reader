browserSync = require 'browser-sync'

module.exports = (gulp) ->
  ->
    browserSync.init proxy: 'passport-vagrant-image:9099'
    return
