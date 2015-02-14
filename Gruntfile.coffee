module.exports = (grunt)->
  # process.env.DEBUG = 'aw'
  # helper = require 'grunt-configs/helper'

  require('load-grunt-tasks')(grunt, {pattern: 'grunt-*', '!grunt-bower-requirejs'})
  grunt.renameTask('bower', '__bower__')
  grunt.loadNpmTasks('grunt-bower-requirejs')
  grunt.renameTask('bower', 'bowerRequireJS')
  grunt.renameTask('__bower__', 'bower')

  configs = require('load-grunt-configs')(grunt, {config: {src: './grunt-configs/*.coffee'}})

  grunt.initConfig configs


  grunt.registerTask "build", [
    "clean",
    "jade",
    "copy:bin",
    "copy:testsDriver",
    "coffee",
    "livescript:src", 
    "livescript:tests",
    "less",
    "bower",
    "bowerRequireJS",
    "copy:tests",
    "express",
    "watch"
  ]
  grunt.registerTask "default",
    ["shell", "build"]
