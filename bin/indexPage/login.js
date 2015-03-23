(function() {
  define(function(require) {
    var LoginPanel, exports;
    LoginPanel = function() {
      this.all = $('.loginContainer');
      this.closeBtn = $('.loginContainer .close');
      this.accountIpt = $('.loginContainer #loginAccount');
      this.pwIpt = $('.loginContainer #loginPw');
      this.errHint = $('.loginContainer .errHint');
      this.loginBtn = $('.loginContainer .loginBtn');
      this.mask = $('.mask');
      return null;
    };
    LoginPanel.prototype = {
      init: function() {
        console.log(this);
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.closeBtn.click(function() {
          return that.hide();
        });
        return that.loginBtn.click(function() {
          if (!that.accountIpt.val().length) {
            return that.errHint.html('请输入正确的QQ帐号!');
          } else if (!that.pwIpt.val().length) {
            return that.errHint.html('你还没有输入密码');
          } else {
            return that.hide();
          }
        });
      },
      show: function() {
        this.all.show();
        return this.mask.show();
      },
      hide: function() {
        this.all.hide();
        return this.mask.hide();
      }
    };
    return exports = LoginPanel;
  });

}).call(this);
