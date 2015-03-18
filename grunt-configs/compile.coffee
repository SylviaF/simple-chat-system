module.exports = (grunt, options) ->
  tasks:
    coffee:
      build:
        expand: true
        cwd: 'src'
        src: [ '**/*.coffee' ]
        dest: 'bin'
        ext: '.js'
    less:
      src:
        options:
          bare: true
        files: [expand: true, cwd: 'src', src: ['**/*.less', '!tests/**/*.*'], dest: 'bin/', ext: '.css']
    jade:
      compile: 
        options:
          pretty: true #为了使用usemin
        files:
          [expand: true, cwd: 'src', src: [ '**/*.jade', '!layout.jade'], dest: 'bin', ext: '.html']