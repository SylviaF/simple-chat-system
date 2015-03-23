module.exports = (grunt, options) ->
  tasks:
    watch:
      stylesheets:
        files: 'src/**/*.less'
        tasks: [ 'less' ]
      scripts:
        files: 'src/**/*.coffee'
        tasks: [ 'coffee', 'express' ]
      jade:
        files: 'src/**/*.jade'
        tasks: [ 'jade' ]
      copy:
        files: [ 'src/**', '!src/**/*.styl', '!src/**/*.coffee', '!src/**/*.jade' ]
        tasks: [ 'copy:build' ]
    express:
      dev:
        options:
          script: 'bin/server.js'
          port: 3000
          output: ".+"