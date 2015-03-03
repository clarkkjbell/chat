{CompositeDisposable} = require 'atom'
tv = require 'television'
{ChatPanel, AtomTextEditor, ol, li, div} = tv.tags('ChatPanel', 'AtomTextEditor')
Loophole = require 'loophole'
observe = Loophole.allowUnsafeNewFunction -> require 'data-kit'
ChatClient = require './chat-client'

module.exports =
tv.registerElement 'chat-panel',
  render: ->
    ChatPanel(
      ol className: "messages",
        li(message.body) for message in @channel.messages

      AtomTextEditor attributes: mini: true
    )

  didCreate: ->
    @client = new ChatClient
    @channel = @client.getChannel('lobby')
    @channel.subscribe()

  didAttach: ->
    @disposables = new CompositeDisposable
    @disposables.add observe(@channel.messages, @update.bind(this))

  didDetach: ->
    @disposables.dispose()
