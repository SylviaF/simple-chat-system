define (require)->
  InfoBubble = (socket)->
    # this.bubblePanel = $('.infoBubbleContainer .bubblePanel')
    # this.infoList = $('.infoBubbleContainer .infoList')
    this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg')
    this.recentCount = $('.infoBubbleContainer .bubblePanel .count')
    this.infoTitle = $('.infoBubbleContainer .infoTitle')
    this.infoListContent = $('.infoBubbleContainer .infoListContent ul')
    this.infoFroms = {}
    this.myemail = null
    this.socket = socket
    null

  InfoBubble.prototype =
    init: (myid)->
      this.myid = myid
      this.addEvent()

    addEvent: ()->
      that = this
      that.socket.on 'req '+ that.myid, (data)->
        console.log 'receive a request to make friend from ', data.nick
        # 显示添加好友申请消息
        that.addInfoItem(data, '请求添加好友')

    addInfoItem: (from, msg)->
      i = 1
      if this.infoFroms[from.id]
        info = this.infoListContent.find(['#', from.id].join(''))
        i = parseInt(info.find('.count').html()) + 1
        info.remove()
      infoTmp = [
        '<li id="'
        from.id
        '"><a><span class="hidden">'
        from.email
        '</span><span class="nick">'
        from.nick
        '：</span><span class="msg">'
        msg
        '</span><span class="countContainer">(<span class="count">'
        i
        '</span>)</span></a></li>'
      ]
      info = infoTmp.join('')
      this.infoListContent.append(info)
      this.infoFroms[from.id] = true
      # this.recentMsg.html(from.nick'：')

  exports = InfoBubble