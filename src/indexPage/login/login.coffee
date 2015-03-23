define (require)->

  LoginPanel = ()->
    this.all = $('.loginContainer')
    this.closeBtn = $('.loginContainer .close')
    this.accountIpt = $('.loginContainer #loginAccount')
    this.pwIpt = $('.loginContainer #loginPw')
    this.errHint = $('.loginContainer .errHint')
    this.loginBtn = $('.loginContainer .loginBtn')
    this.mask = $('.mask')
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
            that.hide()
            
      )
    show: ()->
      this.all.show()
      this.mask.show()
    hide: ()->
      this.all.hide()
      this.mask.hide()

  exports = LoginPanel