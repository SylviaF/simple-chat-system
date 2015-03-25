(function() {
  var RegForm;

  RegForm = function() {
    this.nick = $('#nick');
    this.pw = $('#pw');
    this.rpw = $('#rpw');
    this.email = $('#email');
    this.regBtn = $('#regBtn');
    this.ready = [false, false, false, false];
    return null;
  };

  RegForm.prototype = {
    init: function() {
      return this.addEvent();
    },
    addEvent: function() {
      var that;
      that = this;
      that.nick.focus(function() {
        return that.focusIpt(this);
      });
      that.pw.focus(function() {
        return that.focusIpt(this);
      });
      that.rpw.focus(function() {
        return that.focusIpt(this);
      });
      that.email.focus(function() {
        return that.focusIpt(this);
      });
      that.nick.blur(function() {
        return that.checkNick(this);
      });
      that.pw.blur(function() {
        return that.checkPw(this);
      });
      that.rpw.blur(function() {
        return that.checkRpw(this);
      });
      that.email.blur(function() {
        return that.checkEmail(this);
      });
      return that.regBtn.click(function() {
        if (that.checkReady()) {
          return $.ajax({
            method: 'POST',
            url: '/api/checkEmailExist',
            data: {
              nick: that.nick.val(),
              pw: that.pw.val(),
              email: that.email.val()
            },
            dataType: 'json',
            success: function(data) {
              console.log(data);
              if (!data.flag) {
                return alert(data.err);
              } else {
                return alert("您已经成功注册！可用邮箱号登录");
              }
            },
            error: function(err) {
              return console.log(err);
            }
          });
        }
      });
    },
    checkReady: function() {
      if (this.ready[0] === false) {
        this.checkNick(this.nick);
      } else if (this.ready[1] === false) {
        this.checkPw(this.pw);
      } else if (this.ready[2] === false) {
        this.checkRpw(this.rpw);
      } else if (this.ready[3] === false) {
        this.checkEmail(this.email);
      }
      if (this.ready[0] === true && this.ready[1] === true && this.ready[2] === true && this.ready[3] === true) {
        return true;
      } else {
        return false;
      }
    },
    checkNick: function(obj) {
      if (!obj.value.length) {
        this.showError(obj, '昵称不可以为空');
        this.ready[0] = false;
        return;
      }
      this.showCorrect(obj);
      return this.ready[0] = true;
    },
    checkPw: function(obj) {
      var pw, regExp1, regExp2, regExp3, regExp4;
      pw = obj.value;
      regExp1 = /\s/;
      regExp2 = /^\d{0,8}$/;
      regExp3 = /(^[\w]{0,5}$)|(^[\w]{17,}$)/;
      regExp4 = /[\u4E00-\u9FA5]+/;
      if (!pw.length) {
        this.showError(obj, '密码不可以为空');
        return this.ready[1] = false;
      } else if (regExp1.test(pw)) {
        this.showError(obj, '不能包含空格');
        return this.ready[1] = false;
      } else if (regExp2.test(pw)) {
        this.showError(obj, '不能为低于9位的纯数字');
        return this.ready[1] = false;
      } else if (regExp3.test(pw)) {
        this.showError(obj, '长度为6-16个字符');
        return this.ready[1] = false;
      } else if (regExp4.test(pw)) {
        this.showError(obj, '不能含有中文');
        return this.ready[1] = false;
      } else {
        this.showCorrect(obj);
        return this.ready[1] = true;
      }
    },
    checkRpw: function(obj) {
      if (!obj.value.length) {
        this.showError(obj, '重复密码不可以为空');
        return this.ready[2] = false;
      } else if (obj.value !== this.pw.val()) {
        this.showError(obj, '两次密码输入不一致');
        return this.ready[2] = false;
      } else {
        this.showCorrect(obj);
        return this.ready[2] = true;
      }
    },
    checkEmail: function(obj) {
      var regExp;
      regExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
      if (!obj.value.length) {
        this.showError(obj, '邮箱不可以为空');
        return this.ready[3] = false;
      } else if (regExp.test(obj.value)) {
        this.showCorrect(obj);
        return this.ready[3] = true;
      } else {
        this.showError(obj, '邮箱格式不正确');
        return this.ready[3] = false;
      }
    },
    focusIpt: function(obj) {
      var ipt, iptBorder, iptCorrect, iptError, iptTip;
      iptBorder = $(obj).closest('.inputBorder');
      ipt = iptBorder.parents('.inputLine');
      iptTip = ipt.find('.tip');
      iptError = ipt.find('.error');
      iptCorrect = ipt.find('.correct');
      iptBorder.removeClass('inputError').addClass('inputCorrect');
      iptError.hide();
      iptCorrect.hide();
      return iptTip.show();
    },
    showError: function(obj, errText) {
      var ipt, iptBorder, iptCorrect, iptError, iptTip;
      iptBorder = $(obj).closest('.inputBorder');
      ipt = iptBorder.parents('.inputLine');
      iptTip = ipt.find('.tip');
      iptError = ipt.find('.error');
      iptCorrect = ipt.find('.correct');
      iptBorder.removeClass('inputCorrect').addClass('inputError');
      iptTip.hide();
      iptCorrect.hide();
      iptError.html(errText);
      return iptError.show();
    },
    showCorrect: function(obj) {
      var ipt, iptBorder, iptCorrect, iptError, iptTip;
      iptBorder = $(obj).closest('.inputBorder');
      ipt = iptBorder.parents('.inputLine');
      iptTip = ipt.find('.tip');
      iptError = ipt.find('.error');
      iptCorrect = ipt.find('.correct');
      iptBorder.removeClass('inputError').addClass('inputCorrect');
      iptError.hide();
      iptTip.hide();
      return iptCorrect.show();
    }
  };

  $(function() {
    var regForms;
    regForms = new RegForm();
    regForms.init();
    return null;
  });

}).call(this);
