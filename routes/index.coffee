express = require 'express'
router = express.Router()
io = require 'socket.io-client'

router.get '/', (req, res) ->
  res.render 'index', {}
  return

module.exports = router
