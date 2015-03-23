module.exports = (grunt)->
  # process.env.DEBUG = 'aw'
  # helper = require 'grunt-configs/helper'

  # 自动读取并加载项目 packge.json 文件中 devDependencies 配置下以 grunt-* 开头的依赖库
  require('load-grunt-tasks')(grunt, {pattern: 'grunt-*', '!grunt-bower-requirejs'})

  configs = require('load-grunt-configs')(grunt, {config: {src: './grunt-configs/*.coffee'}})

  grunt.initConfig configs


  grunt.registerTask "dev", [
    "clean:build",
    "jade",
    "copy:build",
    "coffee",
    "less",
    "express",
    "watch"
  ]

  grunt.registerTask "release", [
    #"dev",
    "clean:release",
    "copy:release",
    "useminPrepare",
    "concat",
    "uglify",
    "cssmin",
    "filerev",
    "usemin",
  ]
  
  grunt.registerTask "default", ["dev", "watch"]
