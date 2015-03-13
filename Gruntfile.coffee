module.exports = (grunt)->
  # process.env.DEBUG = 'aw'
  # helper = require 'grunt-configs/helper'

  # 自动读取并加载项目 packge.json 文件中 devDependencies 配置下以 grunt-* 开头的依赖库
  require('load-grunt-tasks')(grunt, {pattern: 'grunt-*', '!grunt-bower-requirejs'})

  grunt.renameTask('bower', '__bower__')
  grunt.loadNpmTasks('grunt-bower-requirejs')
  grunt.renameTask('bower', 'bowerRequireJS')
  grunt.renameTask('__bower__', 'bower')

  configs = require('load-grunt-configs')(grunt, {config: {src: './grunt-configs/*.coffee'}})

  grunt.initConfig configs


  grunt.registerTask "dev", [
    "clean:build",
    "jade",
    "copy:build",
    "coffee",
    "less"
  ]

  grunt.registerTask "release", [
    #"dev",
    "clean:release"
    "uglify",
    "cssmin",
    "copy:release",
  ]
  
  grunt.registerTask "default", ["dev", "watch"]
