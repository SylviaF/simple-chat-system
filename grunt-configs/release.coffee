module.exports = (grunt, options) ->
  tasks:
    pkg: grunt.file.readJSON('package.json')
    concat: {}
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    cssmin:
      options:
        banner:'/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        beautify:
          ascii_only: true
    filerev:
      options:
        algorithm: 'md5'
        length: 8
      files: 
        src: ['release/**/*.{jpg,jpeg,gif,png,ico,js,css}']
    useminPrepare:
      html: 'bin/**/*.html'
      options:
        dest: 'release'
    usemin:
      options:
        assetsDirs: ['release']
      html: ['release/*.html']
      css: ['release/css/*.css']