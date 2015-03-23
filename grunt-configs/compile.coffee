module.exports = (grunt, options) ->
  tasks:
    coffee:
      build:
        files:[
          {expand: true, cwd: 'src', flatten: true, src: ['*.coffee'], dest: 'bin', ext: '.js'},
          {expand: true, cwd: 'src/js', flatten: true, src: ['*.coffee'], dest: 'bin/js', ext: '.js'},
          {expand: true, flatten: true, cwd: 'src', src: ['indexPage/**/*.coffee'], dest: 'bin/indexPage', ext: '.js'},
          {expand: true, flatten: true, cwd: 'src', src: ['regPage/**/*.coffee'], dest: 'bin/regPage', ext: '.js'}
        ]
    less:
      build:
        options:
          bare: true
        files: [
          {expand: true, cwd: 'src/css', flatten: true, src: ['*.less'], dest: 'bin/css', ext: '.css'},
          {expand: true, flatten: true, cwd: 'src', src: ['indexPage/**/*.less'], dest: 'bin/indexPage', ext: '.css'},
          {expand: true, flatten: true, cwd: 'src', src: ['regPage/**/*.less'], dest: 'bin/regPage', ext: '.css'}
        ]
    jade:
      compile: 
        options:
          pretty: true #为了使用usemin
        files:
          [expand: true, cwd: 'src', src: [ '*Page/*.jade'], dest: 'bin', ext: '.html']