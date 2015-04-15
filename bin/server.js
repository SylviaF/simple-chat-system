(function() {
  var app, bodyParser, express, path, routes;

  express = require('express');

  path = require('path');

  bodyParser = require('body-parser');

  routes = require('./routes/index');

  app = express();

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'jade');

  app.use(bodyParser.json());

  app.use(bodyParser.urlencoded({
    extended: false
  }));

  app.use(express['static'](__dirname + '/regPage'));

  app.use(express['static'](__dirname + '/indexPage'));

  app.use(express['static'](__dirname));

  app.use('/', routes);

  module.exports = app;

}).call(this);
