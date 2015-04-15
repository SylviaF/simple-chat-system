IO = (server)->
  io = require('socket.io')
  io = io.listen(server, { log: false })
  onlineUsers = {}
  io.sockets.on 'connection', (socket)->
    client = {}
    socket.on 'online user', (data)->
      client.email = data.email
      client.nick = data.nick
      console.log "data: ", data
      console.log "client: ", client
      onlineUsers[data.email] = socket
      console.log "onlineUsers: ", onlineUsers
    socket.on 'req add friend', (data)->
      console.log data.from, ' want to be a friend with ', data.to
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'req ' + data.to, data.from
        onlineUsers[data.from].on 'reply ' + data.from, (data)->
          if !data
            console.log data.to, ' refuse being a friend with ', data.from
          else
            console.log data.to, ' accept being a friend with ', data.from
      else
        console.log data.to, ' is not online'
      
    socket.on 'disconnect', ()->
      if client && client.email
        onlineUsers[client.email] = null
      console.log client.nick, ' disconnect'
  
module.exports = IO