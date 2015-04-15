(function() {
  define(function(require) {
    var SearchPanel, exports;
    SearchPanel = function(socket) {
      this.all = $('.searchPanelContainer');
      this.closeBtn = $('.searchPanelContainer .closeBtn');
      this.inputForm = $('.searchPanelContainer .inputForm');
      this.searchResult = $('.searchPanelContainer .searchResult');
      this.email = $('.searchPanelContainer .semail');
      this.nick = $('.searchPanelContainer .snick');
      this.searchBtn = $('.searchPanelContainer .searchPanelBtn a');
      this.methodRadio = $('.searchPanelContainer input[name="method"]');
      this.method = 0;
      this.heading = $('.searchPanelContainer  .searchPanelContent h5');
      this.accurateIpt = $('.searchPanelContainer .inputs');
      this.socket = socket;
      return null;
    };
    SearchPanel.prototype = {
      init: function(myemail) {
        this.all.hide();
        this.all.data('myemail', myemail);
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.closeBtn.click(function() {
          that.all.hide();
          that.inputForm.show();
          that.searchResult.hide();
          that.email.val('');
          that.nick.val('');
          return that.heading.html('查找方式');
        });
        that.methodRadio.click(function() {
          that.method = parseInt($('input:radio[name="method"]:checked').val());
          if (!that.method) {
            return that.accurateIpt.show();
          } else {
            return that.accurateIpt.hide();
          }
        });
        return that.searchBtn.click(function() {
          return $.ajax({
            type: 'POST',
            url: '/api/getAccouts',
            data: {
              method: that.method,
              email: that.email.val(),
              nick: that.nick.val()
            },
            dataType: 'json',
            success: function(data) {
              if (!data.flag) {
                return console.log(data.err);
              } else {
                that.heading.html('查找结果');
                that.addUserList(data.result);
                that.inputForm.hide();
                return that.searchResult.show();
              }
            },
            error: function(err) {
              return console.log(err);
            }
          });
        });
      },
      addUserList: function(userList) {
        var classes, cls, i, that, user, _i, _len;
        that = this;
        classes = ['odd', ''];
        that.searchResult.html('');
        for (i = _i = 0, _len = userList.length; _i < _len; i = ++_i) {
          user = userList[i];
          cls = classes[i % 2];
          that.addUserItem(user, cls);
        }
        return $('.searchPanelContainer .findItem .addFriendBtn').click(function() {
          var femail, myemail;
          myemail = that.all.data('myemail');
          femail = $(this).prev('.info').find('.email').html();
          if (myemail === femail) {
            alert('不可添加自己为好友');
            return;
          }
          $.ajax({
            type: 'POST',
            data: {
              myemail: myemail,
              femail: femail
            },
            url: '/api/isFriend',
            dataType: 'json',
            success: function(data) {
              if (!data.flag) {
                return console.log(data.err);
              } else {
                if (!data.result) {
                  return that.socket.emit('req add friend', {
                    from: myemail,
                    to: femail
                  });
                } else {
                  return alert(femail, ' 已经是你的好友了，不需添加好友关系');
                }
              }
            },
            error: function(err) {
              return console.log(err);
            }
          });
          return null;
        });
      },
      addUserItem: function(userItem, classname) {
        var array, item;
        array = ['<div class="findItem ' + classname + '"><div class="info"><div class="nick">', userItem.nick, '</div><div class="second"><span>在线：</span><span class="isOnline">是</span></div><div class="second"><span>邮箱：</span><span class="email">', userItem.email, '</span></div></div><div class="btn addFriendBtn">加为好友</div></div>'];
        item = array.join('');
        return this.searchResult.append(item);
      },
      show: function() {
        return this.all.show();
      },
      hide: function() {
        return this.all.hide();
      }
    };
    return exports = SearchPanel;
  });

}).call(this);
