(function() {
  define(["mainApp"], function(MainApp) {
    var LoginPanel, exports;
    LoginPanel = function(socket) {
      this.all = $('.loginContainer');
      this.closeBtn = $('.loginContainer .close');
      this.accountIpt = $('.loginContainer #loginAccount');
      this.pwIpt = $('.loginContainer #loginPw');
      this.errHint = $('.loginContainer .errHint');
      this.loginBtn = $('.loginContainer .loginBtn');
      this.mask = $('.mask');
      this.mainApp = new MainApp(socket);
      this.islogin = false;
      this.socket = socket;
      return null;
    };
    LoginPanel.prototype = {
      init: function(socket) {
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
            return $.ajax({
              type: 'POST',
              data: {
                email: that.accountIpt.val(),
                pw: that.pwIpt.val()
              },
              url: '/api/login',
              dataType: 'json',
              success: function(data) {
                if (!data.flag) {
                  return that.errHint.html(data.err);
                } else {
                  that.islogin = true;
                  that.socket.emit('online user', {
                    email: data.result.email,
                    nick: data.result.nick
                  });
                  console.log(data.result);
                  $.ajax({
                    type: 'POST',
                    data: {
                      emails: data.result.friends
                    },
                    url: '/api/getFriends',
                    dataType: 'json',
                    success: function(data1) {
                      console.log('friends: ', data1);
                      if (!data1.flag) {
                        that.mainApp.init(data.result, []);
                        return that.mainApp.show();
                      } else {
                        that.mainApp.init(data.result, data1.result);
                        return that.mainApp.show();
                      }
                    },
                    error: function(err) {
                      return console.log(err);
                    }
                  });
                  return that.hide();
                }
              },
              error: function(err) {
                return alert(err);
              }
            });
          }
        });
      },
      show: function() {
        if (!this.islogin) {
          this.all.show();
          return this.mask.show();
        }
      },
      hide: function() {
        this.all.hide();
        return this.mask.hide();
      },
      setIslogin: function(islogin) {
        return this.islogin = islogin;
      }
    };
    return exports = LoginPanel;
  });

}).call(this);
