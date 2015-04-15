define (require)->
  InfoBubble = (socket)->
    # this.bubblePanel = $('.infoBubbleContainer .bubblePanel')
    # this.infoList = $('.infoBubbleContainer .infoList')
    this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg')
    this.recentCount = $('.infoBubbleContainer .bubblePanel .count')
    this.infoTitle = $('.infoBubbleContainer .infoTitle')
    this.infoListContent = $('.infoBubbleContainer .infoListContent')
    this.myemail = null
    this.socket = socket
    null

  InfoBubble.prototype =
    init: (myemail)->
      this.myemail = myemail
      this.addEvent()
      this.socket.on 'req '+myemail, (data)->
        console.log 'receive a request to make friend from ', data
        # 显示添加好友申请消息
    addEvent: ()->
      that = this

  exports = InfoBubble