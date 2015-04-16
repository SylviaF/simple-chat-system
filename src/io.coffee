IO = (server)->
  io = require('socket.io')
  db = require('./db')
  io = io.listen(server, { log: false })
  onlineUsers = {}
  io.sockets.on 'connection', (socket)->
    client = {}

    socket.on 'online user', (data)->
      client.id = data.id
      client.email = data.email
      client.nick = data.nick
      # console.log "data: ", data
      # console.log "client: ", client
      if onlineUsers[client.id]
        socket.emit 'more log at once', client
      onlineUsers[client.id] = socket
      socket.broadcast.emit 'isOnline', client.id, true
      db.setIsOnline client.id, true
      # console.log "onlineUsers: ", onlineUsers

    socket.on 'req add friend', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'req ' + data.to, data.from
      else
        console.log data.to, ' is not online'

    socket.on 'rep add friend', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'reply ' + data.to, data.from, data.reply
      else
        console.log data.to, ' is not online'

      if data.reply
        db.addFriend data.to, data.from.id, (flag)->
          if flag
            console.log ('successly add friend')

    socket.on 'single chat', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'single chat '+data.to, data.from, data.msg, data.time
      else
        console.log data.to, ' is not online'
      
    socket.on 'disconnect', ()->
      if client && client.id
        onlineUsers[client.id] = null
      socket.broadcast.emit 'isOnline', client.id, false
      db.setIsOnline client.id, false
      console.log client.nick, ' disconnect'
  
module.exports = IO