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
        db.addMsg {type: 1, from: data.from, to: data.to, content: '请求添加好友'}, (flag)->
          console.log 'offline req add friend'
 
    socket.on 'rep add friend', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'reply ' + data.to, data.from, data.reply
      else
        reply = if data.reply then '已经添加你为好友' else '拒绝添加你为好友'
        db.addMsg {type: 2, from: data.from, to: data.to, content: reply}, (flag)->
          console.log 'offline rep add friend'

      if data.reply
        db.addFriend data.to, data.from.id, (flag)->
          if flag
            console.log ('successly add friend')

    socket.on 'read msg', (fid, toid)->
      db.delMsg fid, toid, (flag)->
        console.log flag, ' read msg from ', fid

    socket.on 'single chat', (data)->
      if onlineUsers[data.to]
        onlineUsers[data.to].emit 'single chat '+data.to, data.from, data.msg, data.time
      else
        db.addMsg {type: 3, from: data.from, to: data.to, content: data.msg, time: data.time}, (flag)->
          console.log 'offline rep add friend'
      
    socket.on 'disconnect', ()->
      if client && client.id
        onlineUsers[client.id] = null
      socket.broadcast.emit 'isOnline', client.id, false
      db.setIsOnline client.id, false
      console.log client.nick, ' disconnect'
  
module.exports = IO