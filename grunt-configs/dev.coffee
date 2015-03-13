module.exports = (grunt, options) ->
  tasks:
    watch:
      stylesheets:
        files: 'src/**/*.less'
        tasks: [ 'less' ]
      scripts:
        files: 'src/**/*.coffee'
        tasks: [ 'scripts' ]
      jade:
        files: 'src/**/*.jade'
        tasks: [ 'jade' ]
      copy:
        files: [ 'src/**', '!src/**/*.styl', '!src/**/*.coffee', '!src/**/*.jade' ]
        tasks: [ 'copy' ]
    express:
      build:
        options:
          server: 'tests/server.js'
          bases: 'tests'
          livereload: true
          port: 3000