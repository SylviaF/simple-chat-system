define (require)->
  leftBar = (socket)->
    this.appBtn = $('.leftBar .appBtn')
    this.socket = socket
    null

  exports = leftBar