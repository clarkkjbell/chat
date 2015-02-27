ChatServer = require '../lib/chat-server'
ChatClient = require '../lib/chat-client'

describe "Client/server interactions", ->
  [server, client1, client2] = []

  beforeEach ->
    server = new ChatServer
    client1 = new ChatClient('localhost:8000')
    client2 = new ChatClient('localhost:8000')
    waitsFor (done) -> server.listen(8000).then(done)

  afterEach ->
    # server.close()

  it "allows connected clients to send each other messages on channels", ->
    channelA1 = client1.getChannel('a')
    channelA2 = client2.getChannel('a')

    waitsFor (done) ->
      channelA2.subscribe().then(done)

    runs ->
      channelA1.postMessage(body: "Message 1")
      channelA1.postMessage(body: "Message 2")
      channelA1.postMessage(body: "Message 3")

    waitsFor ->
      channelA2.messages.length is 3

    runs ->
      expect(channelA2.messages).toEqual [
        {body: "Message 1"}
        {body: "Message 2"}
        {body: "Message 3"}
      ]
