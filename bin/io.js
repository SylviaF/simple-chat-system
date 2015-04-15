(function() {
  var IO;

  IO = function(server) {
    var io, onlineUsers;
    io = require('socket.io');
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
        onlineUsers[client.id] = socket;
        return console.log("onlineUsers: ", onlineUsers);
      });
      socket.on('req add friend', function(data) {
        if (onlineUsers[data.to]) {
          onlineUsers[data.to].emit('req ' + data.to, data.from);
          return onlineUsers[data.from.id].on('reply ' + data.from, function(data) {
            if (!data) {
              return console.log(data.to, ' refuse being a friend with ', data.from.id);
            } else {
              return console.log(data.to, ' accept being a friend with ', data.from.id);
            }
          });
        } else {
          return console.log(data.to, ' is not online');
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
