rest = require 'restler'

module.exports =
class Client
  constructor: (@serverHost) ->
    @channels = {}

  postMessage: -> Promise.resolve()

  getChannel: (name) ->
    @channels[name] ?= new ChannelClient(this, name)

class ChannelClient
  constructor: (@client, @name) ->

  getChannelURL: ->
    "http://#{@client.serverHost}/channels/#{@name}"

  subscribe: ->
    @messagesEventSource = new EventSource("#{@getChannelURL()}/messages")
    @messagesEventSource.addEventListener 'create', (message) ->
      console.log "CREATE!!"
      console.log "create", JSON.parse(message.data)

  postMessage: (message) ->
    rest.postJson "#{@getChannelURL()}/messages", message
