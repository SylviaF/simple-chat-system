(function() {
  define(['searchPanel', 'infoBubble', 'chatBox'], function(SearchPanel, InfoBubble, ChatBox) {
    var MainApp, exports;
    MainApp = function(socket) {
      this.all = $('.appMainContainer');
      this.appMainNick = $('.appMainContainer .myNick');
      this.appMainFriends = $('.appMainContainer .tabContentInner');
      this.infoBubble = new InfoBubble(socket);
      this.searchPanel = new SearchPanel(socket);
      this.chatBoxs = {};
      this.searchFriendBtn = $('.appMainContainer #searchFriend');
      this.socket = socket;
      return null;
    };
    MainApp.prototype = {
      myaccount: null,
      init: function(myaccount, friends) {
        var that;
        this.myaccount = myaccount;
        this.addFriends(friends);
        this.all.data('myemail', myaccount.email);
        this.appMainNick.html(myaccount.nick);
        this.searchPanel.init(myaccount);
        this.infoBubble.init(myaccount);
        that = this;
        $.ajax({
          type: 'POST',
          data: {
            msgs: myaccount.msgs.join('&')
          },
          url: '/api/getMsgs',
          dataType: 'json',
          success: function(data) {
            var friend, _i, _len, _results;
            if (data.flag) {
              that.infoBubble.initInfoList(data.result);
              that.initNotice(data.result);
              _results = [];
              for (_i = 0, _len = friends.length; _i < _len; _i++) {
                friend = friends[_i];
                _results.push(that.chatBoxs[friend._id].initChatBoxMsg(data.result));
              }
              return _results;
            }
          }
        });
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.socket.on('isOnline', function(id, isOnline) {
          if (isOnline) {
            return that.appMainFriends.find('#' + id + 'favatar').removeClass('gray');
          } else {
            return that.appMainFriends.find('#' + id + 'favatar').addClass('gray');
          }
        });
        that.socket.on('single chat ' + that.myaccount._id, function(from, msg, time) {
          return that.appMainFriends.find(['#mainAppFriends', from._id].join('')).addClass('notice');
        });
        return that.searchFriendBtn.click(function() {
          return that.searchPanel.show();
        });
      },
      show: function() {
        return this.all.show();
      },
      hide: function() {
        return this.all.hide();
      },
      addFriends: function(faccounts) {
        var chatBox, faccount, i, _i, _len;
        this.appMainFriends.html('');
        for (i = _i = 0, _len = faccounts.length; _i < _len; i = ++_i) {
          faccount = faccounts[i];
          this.addFriendItem(faccount, 'hi');
          chatBox = new ChatBox(this.socket, faccount);
          chatBox.init(this.myaccount);
          this.chatBoxs[faccount._id] = chatBox;
        }
        return console.log(this.chatBoxs);
      },
      addFriendItem: function(faccount, recentMsg) {
        var array, item, that;
        array = ['<div class="friendLine" id="mainAppFriends', faccount._id, '"><img id="', [faccount._id, 'favatar'].join(''), '" src="../images/defaultUserAvatar.png" class="favatar', faccount.isOnline ? '' : ' gray', '"><div class="finfo"><div class="fid hidden">', faccount._id, '</div><div class="fnick">', faccount.nick, '</div><div class="recentMsg">', recentMsg, '</div></div></div>'];
        item = $(array.join(''));
        that = this;
        item.click(function() {
          item.removeClass('notice');
          return that.chatBoxs[faccount._id].show();
        });
        return this.appMainFriends.append(item);
      },
      initNotice: function(msgs) {
        var msg, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = msgs.length; _i < _len; _i++) {
          msg = msgs[_i];
          _results.push(this.appMainFriends.find(['#manAppFriends', msg.from._id].join('')).addClass('notice'));
        }
        return _results;
      }
    };
    return exports = MainApp;
  });

}).call(this);
