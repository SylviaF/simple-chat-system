define (require)->
  ChatBox = (socket, faccount)->
    this.model = $('#chatBoxModel')
    this.model.clone(true).attr('id', [faccount._id, 'ChatBox'].join('')).addClass('chatBox').appendTo('body')
    this.all = $(['#', faccount._id, 'ChatBox'].join(''))
    this.favatar = this.all.find('.chatTitle .favatar')
    this.chatInput = this.all.find('.chatInput')
    this.chatBtn = this.all.find('.chatBtn .send')
    this.chatContent = this.all.find('.chatContent')
    this.closeBtn = this.all.find('.chatTitleBtn .closeBtn')
    this.fnick = this.all.find('.fnick')
    this.fnick.html(faccount.nick)
    this.socket = socket
    this.faccount = faccount
    null

  ChatBox.prototype =
    init: (myaccount)->
      if !this.faccount.isOnline
        this.favatar.addClass 'gray'
      this.myaccount = myaccount
      this.addEvent()

    addEvent: ()->
      that = this

      that.socket.on 'isOnline', (id, isOnline)->
        if id == that.faccount._id
          if isOnline
            that.favatar.removeClass('gray')
          else
            that.favatar.addClass('gray')

      that.socket.on 'single chat '+ that.myaccount._id, (from, msg, time)->
        console.log from, msg, time
        that.addChatItem from, msg, time, 1

      that.closeBtn.click ()->
        that.hide()

      that.chatBtn.click ()->
        msg = that.chatInput.html()
        time = that.getTime()
        if msg
          that.addChatItem that.myaccount, msg, time, 0
          that.chatInput.html('')
          that.socket.emit 'single chat', {from: that.myaccount, to: that.faccount._id, msg: msg, time: time}
        else
          alert '请输入要发送的内容'

    # type: 0-我发出的，1-我收到的
    addChatItem: (from, msg, time, type)->
      if type == 1 && from._id != this.faccount._id
        return
      tmp = [
        '<div class="msgLine"><div class="msgLineTitle '
        if type then 'other' else 'me'
        '"><span>'
        from.nick
        '</span><span class="time">'
        time
        '</span></div><div class="msgLineContent"> <div class="msg">'
        msg
        '</div></div></div>'
      ]
      this.chatContent.append tmp.join('')

    show: ()->
      this.all.show()
    hide:()->
      this.all.hide()
    getTime: ()->
      new Date().format("yyyy-MM-dd hh:mm:ss")

  exports = ChatBox