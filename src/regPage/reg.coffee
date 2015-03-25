RegForm = ()->
  this.nick = $('#nick')
  this.pw = $('#pw')
  this.rpw = $('#rpw')
  this.email = $('#email')
  this.regBtn = $('#regBtn')
  this.ready = [false, false, false, false]
  null

RegForm.prototype = 
  init: ()->
    this.addEvent()
  addEvent: ()->
    that = this
    # 输入的focus事件
    that.nick.focus(()-> that.focusIpt(this))
    that.pw.focus(()-> that.focusIpt(this))
    that.rpw.focus(()-> that.focusIpt(this))
    that.email.focus(()-> that.focusIpt(this))
    # 输入的blur事件
    that.nick.blur(
      ()-> 
        that.checkNick this
    )
    that.pw.blur(
      ()->
        that.checkPw this
    )
    that.rpw.blur(
      ()->
        that.checkRpw this
    )
    that.email.blur(
      ()->
        that.checkEmail this
    )

    # click事件
    that.regBtn.click(
      ()->
        if that.checkReady()
          $.ajax
            method: 'POST'
            url: '/api/checkEmailExist'
            data: 
              nick: that.nick.val()
              pw: that.pw.val()
              email: that.email.val()
            dataType: 'json'
            success: (data)->
              console.log data
              if !data.flag
                alert(data.err)
              else
                alert("您已经成功注册！可用邮箱号登录")
            error: (err)->
              console.log err

    )

  checkReady: ()->
    if this.ready[0] is false
      this.checkNick(this.nick)
    else if this.ready[1] is false
      this.checkPw(this.pw)
    else if this.ready[2] is false
      this.checkRpw(this.rpw)
    else if this.ready[3] is false
      this.checkEmail(this.email)

    if this.ready[0] is true and this.ready[1] is true and this.ready[2] is true and this.ready[3] is true
      true
    else 
      false
      
  # 检查昵称格式
  checkNick: (obj)->
    if !obj.value.length
      this.showError obj, '昵称不可以为空'
      this.ready[0] = false
      return
    this.showCorrect obj
    this.ready[0] = true
  checkPw: (obj)->
    pw = obj.value
    regExp1 = /\s/
    regExp2 = /^\d{0,8}$/
    regExp3 = /(^[\w]{0,5}$)|(^[\w]{17,}$)/
    regExp4 = /[\u4E00-\u9FA5]+/
    if !pw.length
      this.showError obj, '密码不可以为空'
      this.ready[1] = false
    else if regExp1.test pw
      this.showError obj, '不能包含空格'
      this.ready[1] = false
    else if regExp2.test pw
      this.showError obj, '不能为低于9位的纯数字'
      this.ready[1] = false
    else if regExp3.test pw
      this.showError obj, '长度为6-16个字符'
      this.ready[1] = false
    else if regExp4.test pw
      this.showError obj, '不能含有中文'
      this.ready[1] = false
    else
      this.showCorrect obj
      this.ready[1] = true
  checkRpw: (obj)->
    if !obj.value.length
      this.showError obj, '重复密码不可以为空'
      this.ready[2] = false
    else if obj.value != this.pw.val()
      this.showError obj, '两次密码输入不一致'
      this.ready[2] = false
    else
      this.showCorrect obj
      this.ready[2] = true
  checkEmail: (obj)->
    regExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
    if !obj.value.length
      this.showError obj, '邮箱不可以为空'
      this.ready[3] = false
    else if regExp.test obj.value
      this.showCorrect obj
      this.ready[3] = true
    else
      this.showError obj, '邮箱格式不正确'
      this.ready[3] = false

  # 恢复初始提示模样（当输入时）
  focusIpt: (obj)->
    iptBorder = $(obj).closest('.inputBorder')
    ipt = iptBorder.parents('.inputLine')
    iptTip = ipt.find('.tip')
    iptError = ipt.find('.error')
    iptCorrect = ipt.find('.correct')
    iptBorder.removeClass('inputError').addClass('inputCorrect')
    iptError.hide()
    iptCorrect.hide()
    iptTip.show()
  # 显示错误提示（当输入完成且有误时）
  showError: (obj, errText)->
    iptBorder = $(obj).closest('.inputBorder')
    ipt = iptBorder.parents('.inputLine')
    iptTip = ipt.find('.tip')
    iptError = ipt.find('.error')
    iptCorrect = ipt.find('.correct')
    iptBorder.removeClass('inputCorrect').addClass('inputError')
    iptTip.hide()
    iptCorrect.hide()
    iptError.html(errText)
    iptError.show()
  # 显示输入正确的提示
  showCorrect: (obj)->
    iptBorder = $(obj).closest('.inputBorder')
    ipt = iptBorder.parents('.inputLine')
    iptTip = ipt.find('.tip')
    iptError = ipt.find('.error')
    iptCorrect = ipt.find('.correct')
    iptBorder.removeClass('inputError').addClass('inputCorrect')
    iptError.hide()
    iptTip.hide()
    iptCorrect.show()

# 初始化注册表单
$(
  ()->
    regForms = new RegForm()
    regForms.init()
    null
)
