module.exports = (grunt, options) ->
  tasks:
    pkg: grunt.file.readJSON('package.json')
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      release:
        files:
          [{
            expand:true,
            cwd:'bin/',
            src:'**/*.js',
            dest:'release/js/'
          }]
    cssmin:
      options:
        banner:'/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
        beautify:
          ascii_only: true
      release:
        files:
          [{
            expand:true,
            cwd:'bin/',
            src:'**/*.css',
            dest:'release/css/'
          }]
