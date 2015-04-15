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
    init: (myemail)->
      this.all.hide()
      this.all.data('myemail', myemail)
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
        myemail = that.all.data('myemail')
        femail = $(this).prev('.info').find('.email').html()
        
        if myemail == femail
          alert '不可添加自己为好友'
          return

        $.ajax
          type: 'POST'
          data:
            myemail: myemail
            femail: femail
          url: '/api/isFriend'
          dataType: 'json'
          success: (data)->
            if !data.flag
              console.log data.err
            else
              if !data.result
                that.socket.emit 'req add friend', {from: myemail, to: femail}
                # $.ajax
                #   type: 'POST'
                #   data:
                #     myemail: myemail
                #     femail: femail
                #   url: '/api/addFriend'
                #   dataType: 'json'
                #   success: (data1)->
                #     if !data1.flag 
                #       console.log data1.err 
                #     else
                #       console.log data1.result
                #       alert '添加好友', femail, '成功'
                #   error: (err)->
                #     console.log err
              else
                alert femail, ' 已经是你的好友了，不需添加好友关系'
          error: (err)->
            console.log err
        null
    addUserItem: (userItem, classname)->
      array = [
        '<div class="findItem '+classname+'"><div class="info"><div class="nick">'
        userItem.nick
        '</div><div class="second"><span>在线：</span><span class="isOnline">是</span></div><div class="second"><span>邮箱：</span><span class="email">'
        userItem.email
        '</span></div></div><div class="btn addFriendBtn">加为好友</div></div>'
      ]
      item = array.join('')
      this.searchResult.append(item)
    show: ()->
      this.all.show()
    hide: ()->
      this.all.hide()
  exports = SearchPanel