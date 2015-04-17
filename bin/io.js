(function() {
  var IO;

  IO = function(server) {
    var db, io, onlineUsers;
    io = require('socket.io');
    db = require('./db');
    io = io.listen(server, {
      log: false
    });
    onlineUsers = {};
    return io.sockets.on('connection', function(socket) {
      var client;
      client = {};
      socket.on('online user', function(data) {
        client.id = data.id;
        client.email = data.email;
        client.nick = data.nick;
        if (onlineUsers[client.id]) {
          socket.emit('more log at once', client);
        }
        onlineUsers[client.id] = socket;
        socket.broadcast.emit('isOnline', client.id, true);
        return db.setIsOnline(client.id, true);
      });
      socket.on('req add friend', function(data) {
        if (onlineUsers[data.to]) {
          return onlineUsers[data.to].emit('req ' + data.to, data.from);
        } else {
          return db.addMsg({
            type: 1,
            from: data.from,
            to: data.to,
            content: '请求添加好友'
          }, function(flag) {
            return console.log('offline req add friend');
          });
        }
      });
      socket.on('rep add friend', function(data) {
        var reply;
        if (onlineUsers[data.to]) {
          onlineUsers[data.to].emit('reply ' + data.to, data.from, data.reply);
        } else {
          reply = data.reply ? '已经添加你为好友' : '拒绝添加你为好友';
          db.addMsg({
            type: 2,
            from: data.from,
            to: data.to,
            content: reply
          }, function(flag) {
            return console.log('offline rep add friend');
          });
        }
        if (data.reply) {
          return db.addFriend(data.to, data.from.id, function(flag) {
            if (flag) {
              return console.log('successly add friend');
            }
          });
        }
      });
      socket.on('read msg', function(fid, toid) {
        return db.delMsg(fid, toid, function(flag) {
          return console.log(flag, ' read msg from ', fid);
        });
      });
      socket.on('single chat', function(data) {
        if (onlineUsers[data.to]) {
          return onlineUsers[data.to].emit('single chat ' + data.to, data.from, data.msg, data.time);
        } else {
          return db.addMsg({
            type: 3,
            from: data.from,
            to: data.to,
            content: data.msg,
            time: data.time
          }, function(flag) {
            return console.log('offline rep add friend');
          });
        }
      });
      return socket.on('disconnect', function() {
        if (client && client.id) {
          onlineUsers[client.id] = null;
        }
        socket.broadcast.emit('isOnline', client.id, false);
        db.setIsOnline(client.id, false);
        return console.log(client.nick, ' disconnect');
      });
    });
  };

  module.exports = IO;

}).call(this);
