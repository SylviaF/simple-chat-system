define (require)->

  LoginPanel = ()->
    this.all = $('.loginContainer')
    this.closeBtn = $('.loginContainer .close')
    this.accountIpt = $('.loginContainer #loginAccount')
    this.pwIpt = $('.loginContainer #loginPw')
    this.errHint = $('.loginContainer .errHint')
    this.loginBtn = $('.loginContainer .loginBtn')
    this.mask = $('.mask')
    this.appMainNick = $('.appMainContainer .myNick')
    this.appMain = $('.appMainContainer')
    this.islogin = false
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
                  that.appMainNick.html data.result.nick
                  that.appMain.show()
                  console.log data.result
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