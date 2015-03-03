exports.activate = ->
  ChatPanel = require './chat-panel'
  atom.workspace.addRightPanel(item: new ChatPanel)
