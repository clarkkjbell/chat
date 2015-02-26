SSE = require 'sse'
Loophole = require 'loophole'
express = Loophole.allowUnsafeEval -> require 'express'
bodyParser = Loophole.allowUnsafeEval -> require 'body-parser'

module.exports =
class ChatServer
  constructor: (@port) ->

  start: ->
    channels = {}

    app = express()
    app.use(bodyParser.json())

    app.get "/channels/:name/messages", (req, res) ->
      {name} = req.params

      if req.headers.accept is 'text/event-stream'
        client = new SSE.Client(req, res)
        client.initialize()
        channels[name] ?= new ChannelServer(name)
        channels[name].join(client)
      else
        res.writeHead(200, 'Content-Type': 'text/plain')
        res.end('okay')

    app.post "/channels/:name/messages", (req, res) ->
      {name} = req.params
      console.log "POSTING", req.body
      channels[name]?.createMessage(req.body)
      res.writeHead(200, 'Content-Type': 'text/plain')
      res.end('okay')

    new Promise (resolve, reject) =>
      app.listen(@port, resolve)

class ChannelServer
  constructor: (@name) ->
    @clients = []

  join: (client) ->
    @clients.push(client)

  createMessage: (message) ->
    message = JSON.stringify(message)
    client.send "create", message for client in @clients
