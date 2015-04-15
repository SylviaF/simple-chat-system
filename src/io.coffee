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
      onlineUsers[client.id] = socket
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
      
    socket.on 'disconnect', ()->
      if client && client.id
        onlineUsers[client.id] = null
      console.log client.nick, ' disconnect'
  
module.exports = IO