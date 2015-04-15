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
        return onlineUsers[client.id] = socket;
      });
      socket.on('req add friend', function(data) {
        if (onlineUsers[data.to]) {
          return onlineUsers[data.to].emit('req ' + data.to, data.from);
        } else {
          return console.log(data.to, ' is not online');
        }
      });
      socket.on('rep add friend', function(data) {
        if (onlineUsers[data.to]) {
          onlineUsers[data.to].emit('reply ' + data.to, data.from, data.reply);
        } else {
          console.log(data.to, ' is not online');
        }
        if (data.reply) {
          return db.addFriend(data.to, data.from.id, function(flag) {
            if (flag) {
              return console.log('successly add friend');
            }
          });
        }
      });
      return socket.on('disconnect', function() {
        if (client && client.id) {
          onlineUsers[client.id] = null;
        }
        return console.log(client.nick, ' disconnect');
      });
    });
  };

  module.exports = IO;

}).call(this);
