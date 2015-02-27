rest = require 'restler'

module.exports =
class Client
  constructor: (@serverHost) ->
    @channels = {}

  getChannel: (name) ->
    @channels[name] ?= new ChannelClient(this, name)

class ChannelClient
  constructor: (@client, @name) ->
    @messages = []

  getChannelURL: ->
    "http://#{@client.serverHost}/channels/#{@name}"

  subscribe: ->
    @messagesEventSource = new EventSource("#{@getChannelURL()}/messages")
    @messagesEventSource.addEventListener 'create', (event) =>
      message = JSON.parse(event.data)
      @messages.push(message)

    new Promise (resolve) => @messagesEventSource.onopen = resolve

  postMessage: (message) ->
    rest.postJson "#{@getChannelURL()}/messages", message
