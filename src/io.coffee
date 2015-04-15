IO = (server)->
  io = require('socket.io')
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
      console.log "onlineUsers: ", onlineUsers

    socket.on 'req add friend', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'req ' + data.to, data.from
        onlineUsers[data.from.id].on 'reply ' + data.from, (data)->
          if !data
            console.log data.to, ' refuse being a friend with ', data.from.id
          else
            console.log data.to, ' accept being a friend with ', data.from.id
      else
        console.log data.to, ' is not online'
      
    socket.on 'disconnect', ()->
      if client && client.id
        onlineUsers[client.id] = null
      console.log client.nick, ' disconnect'
  
module.exports = IO