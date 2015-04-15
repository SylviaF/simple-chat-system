(function() {
  var app, debug, http, normalizePort, onError, onListening, port, server;

  app = require('./server');

  debug = require('debug')('nodejs-demo:server');

  http = require('http');

  normalizePort = function(val) {
    var port;
    port = parseInt(val, 10);
    if (isNaN(port)) {
      return val;
    }
    if (port >= 0) {
      return port;
    }
    return false;
  };

  onListening = function() {
    var addr, bind;
    addr = server.address();
    bind = typeof addr === 'string' ? 'pipe ' + addr : 'port ' + addr.port;
    return debug('Listening on ' + bind);
  };

  onError = function(error) {
    var bind;
    if (error.syscall !== 'listen') {
      throw error;
    }
    bind = typeof port === 'string' ? 'Pipe ' + port : 'Port ' + port;
    switch (error.code) {
      case 'EACCES':
        console.error(bind + ' requires elevated privileges');
        process.exit(1);
        break;
      case 'EADDRINUSE':
        console.error(bind + ' is already in use');
        process.exit(1);
        break;
      default:
        throw error;
    }
  };

  port = normalizePort(process.env.PORT || '3000');

  app.set('port', port);

  server = http.createServer(app);

  require('./io')(server);

  server.listen(port);

}).call(this);
