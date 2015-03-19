(function() {
  var RegForm;

  RegForm = function() {
    this.nick = $('#nick');
    this.pw = $('#pw');
    this.rpw = $('#rpw');
    this.email = $('#email');
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
      return that.email.blur(function() {
        return that.checkEmail(this);
      });
    },
    checkNick: function(obj) {
      if (!obj.value.length) {
        this.showError(obj, '昵称不可以为空');
        return;
      }
      return this.showCorrect(obj);
    },
    checkPw: function(obj) {
      var pw, regExp1, regExp2, regExp3, regExp4;
      pw = obj.value;
      regExp1 = /\s/;
      regExp2 = /^\d{0,8}$/;
      regExp3 = /(^[\w]{0,5}$)|(^[\w]{17,}$)/;
      regExp4 = /[\u4E00-\u9FA5]+/;
      if (!pw.length) {
        return this.showError(obj, '密码不可以为空');
      } else if (regExp1.test(pw)) {
        return this.showError(obj, '不能包含空格');
      } else if (regExp2.test(pw)) {
        return this.showError(obj, '不能为低于9位的纯数字');
      } else if (regExp3.test(pw)) {
        return this.showError(obj, '长度为6-16个字符');
      } else if (regExp4.test(pw)) {
        return this.showError(obj, '不能含有中文');
      } else {
        return this.showCorrect(obj);
      }
    },
    checkRpw: function(obj) {
      if (!obj.value.length) {
        return this.showError(obj, '重复密码不可以为空');
      } else if (obj.value !== this.pw.value) {
        return this.showError(obj, '两次密码输入不一致');
      } else {
        return this.showCorrect(obj);
      }
    },
    checkEmail: function(obj) {
      var regExp;
      regExp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
      if (!obj.value.length) {
        return this.showError(obj, '邮箱不可以为空');
      } else if (regExp.test(obj.value)) {
        return this.showCorrect(obj);
      } else {
        return this.showError(obj, '邮箱格式不正确');
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
