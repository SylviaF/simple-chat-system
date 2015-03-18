module.exports = (grunt, options) ->
  tasks:
    copy:
      # subtask of copy
      build:
        cwd: 'src'
        src: [ '**', '!**/*.less', '!**/*.coffee', '!**/*.jade' ]
        dest: 'bin'
        expand: true
      release:
        files: [ 
          {expand: 'true', cwd: 'bin', flatten: true, src: ['**/*.jpg', '**/*.bmp', '**/*.gif', '**/*.png'], dest: 'release/images/'},
          {expand: 'true', cwd: 'bin', flatten: true, src: ['**/*.html'], dest: 'release/'}
        ]
    clean:
      build:
        src: [ 'bin' ]
      release:
        src: ['release', '.tmp']