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
          data: {}
        files:
          [expand: true, cwd: 'src', src: [ '**/*.jade' ], dest: 'bin', ext: '.html']