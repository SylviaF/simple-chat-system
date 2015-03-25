module.exports = (grunt, options) ->
  tasks:
    watch:
      stylesheets:
        files: 'src/**/*.less'
        tasks: [ 'less', 'express' ]
      scripts:
        files: 'src/**/*.coffee'
        tasks: [ 'coffee', 'express' ]
      jade:
        files: 'src/**/*.jade'
        tasks: [ 'copy:jade', 'express' ]
      copy:
        files: [ 'src/**', '!src/**/*.styl', '!src/**/*.coffee', '!src/**/*.jade' ]
        tasks: [ 'copy:build', 'express']
    express:
      dev:
        options:
          script: 'bin/run.js'
          port: 3000
          output: ".+"
          delay: 10000
    mongobin:
      options:
        host: 'localhost'
        port: '27017'
        db: 'test'
      # restore_terms:
      #   task: 'restore'
      #   collection: 'terms'
      #   path: './dump/default'
      # dump:
      #   # if task is unspecified, mongobin will attempt to use the target key, 
      #   # in this case, 'dump'. 
      #   out: './dump/' + Date.now()