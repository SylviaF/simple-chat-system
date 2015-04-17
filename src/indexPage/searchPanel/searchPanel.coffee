define (require)->

  SearchPanel = (socket)->
    this.all = $('.searchPanelContainer')
    this.closeBtn = $('.searchPanelContainer .closeBtn')
    this.inputForm = $('.searchPanelContainer .inputForm')
    this.searchResult = $('.searchPanelContainer .searchResult')
    this.email = $('.searchPanelContainer .semail')
    this.nick = $('.searchPanelContainer .snick')
    this.searchBtn = $('.searchPanelContainer .searchPanelBtn a')
    this.methodRadio = $('.searchPanelContainer input[name="method"]')
    this.method = 0 # 0:精确查找, 1:查找所有
    this.heading = $('.searchPanelContainer  .searchPanelContent h5')
    this.accurateIpt = $('.searchPanelContainer .inputs')
    this.socket = socket
    null

  SearchPanel.prototype =
    init: (myaccount)->
      this.all.hide()
      this.myaccount = myaccount
      this.addEvent()
    addEvent: ()->
      that = this

      that.closeBtn.click ()->
        that.all.hide()
        that.inputForm.show()
        that.searchResult.hide()
        that.email.val('')
        that.nick.val('')
        that.heading.html('查找方式')

      that.methodRadio.click ()->
        that.method = parseInt($('input:radio[name="method"]:checked').val())
        if !that.method
          that.accurateIpt.show()
        else
          that.accurateIpt.hide()

      that.searchBtn.click ()->
        $.ajax
          type: 'POST'
          url: '/api/getAccouts'
          data: 
            method: that.method
            email: that.email.val()
            nick: that.nick.val()
          dataType: 'json'
          success: (data)->
            if !data.flag
              console.log(data.err)
            else
              that.heading.html('查找结果')
              console.log data.result
              that.addUserList(data.result)
              that.inputForm.hide()
              that.searchResult.show()
          error: (err)->
            console.log err

    addUserList: (userList)->
      that = this
      classes = ['odd', '']
      that.searchResult.html('')
      for user, i in userList
        cls = classes[i%2]
        that.addUserItem(user, cls)
      $('.searchPanelContainer .findItem .addFriendBtn').click ()->
        myid = that.myaccount._id
        fid = $(this).prev('.info').find('.id').html()
        if myid == fid
          alert '不可添加自己为好友'
          return

        $.ajax
          type: 'POST'
          data:
            myid: myid
            fid: fid
          url: '/api/isFriend'
          dataType: 'json'
          success: (data)->
            if !data.flag
              console.log data.err
            else
              if !data.result
                that.socket.emit 'req add friend', {from: {id: myid, nick: that.myaccount.nick, email: that.myaccount.email}, to: fid}
                alert '消息已发送'
              else
                alert [that.myaccount.nick, '已经是你的好友了，不需添加好友关系'].join('')
          error: (err)->
            console.log err
        null
    addUserItem: (userItem, classname)->
      array = [
        '<div class="findItem '+classname+'"><div class="info"><div class="nick">'
        userItem.nick
        '</div><div class="second"><span>在线：</span><span class="isOnline">'
        if userItem.isOnline then '是' else '否'
        '</span></div><div class="second"><span>邮箱：</span><span class="email">'
        userItem.email
        '</span><span class="id hidden">'
        userItem._id
        '</span></div></div><div class="btn addFriendBtn">加为好友</div></div>'
      ]
      item = array.join('')
      this.searchResult.append(item)
    show: ()->
      this.all.show()
    hide: ()->
      this.all.hide()
  exports = SearchPanel