(function() {
  var LoginPanel;

  LoginPanel = function() {
    this.all = $('.loginContainer');
    this.closeBtn = $('.loginContainer .close');
    this.accountIpt = $('.loginContainer #loginAccount');
    this.pwIpt = $('.loginContainer #loginPw');
    this.errHint = $('.loginContainer .errHint');
    this.loginBtn = $('.loginContainer .loginBtn');
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
        return that.all.hide();
      });
      return that.loginBtn.click(function() {
        if (!that.accountIpt.val().length) {
          return that.errHint.html('请输入正确的QQ帐号!');
        } else if (!that.pwIpt.val().length) {
          return that.errHint.html('你还没有输入密码');
        } else {

        }
      });
    }
  };

  $(function() {
    var loginPanel;
    loginPanel = new LoginPanel();
    return loginPanel.init();
  });

}).call(this);
