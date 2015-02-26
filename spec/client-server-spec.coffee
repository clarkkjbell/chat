ChatServer = require '../lib/chat-server'
ChatClient = require '../lib/chat-client'

describe "Client/server interactions", ->
  [server, client1, client2] = []

  beforeEach ->
    server = new ChatServer(8000)
    client1 = new ChatClient('localhost:8000')
    client2 = new ChatClient('localhost:8000')
    waitsFor (done) -> server.start().then(done)

  # afterEach ->
  #   server.destroy()

  it "allows connected clients to send each other messages on channels", ->
    channelA1 = client1.getChannel('a')
    channelA2 = client2.getChannel('a')

    channelA2.subscribe()

    channelA1.postMessage(body: "Message 1")

    # waitsFor ->
    #   a2Messages.length > 0
    #
    # runs ->
    #   expect(a2Messages).toEqual [{body: "Message 1"}]
