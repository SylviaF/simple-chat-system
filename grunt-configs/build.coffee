module.exports = (grunt, options) ->
  tasks:
    copy:
      # subtask of copy
      build:
        files: [
          {expand: true, cwd: 'src', flatten: false, src: ['{css,js}/*.{css,js}'], dest: 'bin'},
          {expand: true, cwd: 'src', flatten: true, src: ['images/*'], dest: 'bin/images/'},
          {expand: true, cwd: 'src', flatten: true, src: 'indexPage/**/images/*', dest: 'bin/indexPage/images'}
        ]
      release:
        files: [ 
          {expand: true, cwd: 'bin/images', flatten: true, src: ['*'], dest: 'release/images/'},
          {expand: true, cwd: 'bin', flatten: true, src: ['**/*.jpg', '**/*.bmp', '**/*.gif', '**/*.png', '!images/*'], dest: 'release/css/images/'},
          {expand: true, cwd: 'bin', flatten: true, src: ['**/*.html'], dest: 'release/'},
          {expand: true, cwd: 'bin', flatten: true, src: ['**/*.js'], dest: 'release/js'}
        ]
    clean:
      build:
        src: [ 'bin' ]
      release:
        src: ['release', '.tmp']