yaml = require 'node-yaml-config'
path = require 'path'
browserSync = require 'browser-sync'

config = yaml.load(path.join(__dirname, '../../../config.yml'))

module.exports = (gulp) ->
  ->
    browserSync.init proxy: config.server.hostname + ':' + config.server.port
    return
