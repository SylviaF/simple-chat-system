define ["mainApp"], (MainApp)->

  LoginPanel = (socket)->
    this.all = $('.loginContainer')
    this.closeBtn = $('.loginContainer .close')
    this.accountIpt = $('.loginContainer #loginAccount')
    this.pwIpt = $('.loginContainer #loginPw')
    this.errHint = $('.loginContainer .errHint')
    this.loginBtn = $('.loginContainer .loginBtn')
    this.mask = $('.mask')
    this.mainApp = new MainApp(socket)
    this.islogin = false
    this.socket = socket
    null

  LoginPanel.prototype =
    init: ()->
      console.log(this)
      this.addEvent()
    addEvent: ()->
      that = this
      # 点击关闭按钮
      that.closeBtn.click(
        ()->
          that.hide()
      )
      # 点击登录按钮
      that.loginBtn.click(
        ()->
          if (!that.accountIpt.val().length)
            that.errHint.html('请输入正确的QQ帐号!')
          else if (!that.pwIpt.val().length)
            that.errHint.html('你还没有输入密码')
          else
            $.ajax
              type: 'POST'
              data: {
                email: that.accountIpt.val()
                pw: that.pwIpt.val()
              }
              url: '/api/login'
              dataType: 'json'
              success: (data)->
                if !data.flag
                  that.errHint.html(data.err)
                else
                  # 匹配成功
                  that.islogin = true
                  that.socket.emit 'online user', {id: data.result._id, email: data.result.email, nick: data.result.nick}
                  # that.mainApp.init(data.result)
                  # that.mainApp.show()
                  console.log data.result
                  $.ajax
                    type: 'POST'
                    data: 
                      ids: data.result.friends
                    url: '/api/getFriends'
                    dataType: 'json'
                    success: (data1)->
                      console.log 'friends: ', data1
                      if !data1.flag
                        that.mainApp.init(data.result, [])
                        that.mainApp.show()
                      else
                        that.mainApp.init(data.result, data1.result)
                        that.mainApp.show()
                    error: (err)->
                      console.log err
                  that.hide()
              error: (err)->
                alert(err)
            
      )
    show: ()->
      if !this.islogin
        this.all.show()
        this.mask.show()
    hide: ()->
      this.all.hide()
      this.mask.hide()
    setIslogin: (islogin)->
      this.islogin = islogin

  exports = LoginPanel