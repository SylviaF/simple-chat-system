(function() {
  define(['searchPanel', 'infoBubble', 'chatBox'], function(SearchPanel, InfoBubble, ChatBox) {
    var MainApp, exports;
    MainApp = function(socket) {
      this.all = $('.appMainContainer');
      this.appMainNick = $('.appMainContainer .myNick');
      this.appMainFriends = $('.appMainContainer .tabContentInner');
      this.infoBubble = new InfoBubble(socket);
      this.searchPanel = new SearchPanel(socket);
      this.chatBoxs = [];
      this.searchFriendBtn = $('.appMainContainer #searchFriend');
      this.socket = socket;
      return null;
    };
    MainApp.prototype = {
      myaccount: null,
      init: function(myaccount, friends) {
        this.myaccount = myaccount;
        this.addFriends(friends);
        this.all.data('myemail', myaccount.email);
        this.appMainNick.html(myaccount.nick);
        this.searchPanel.init(myaccount);
        this.infoBubble.init(myaccount);
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
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
        var faccount, i, _i, _len, _results;
        this.appMainFriends.html('');
        _results = [];
        for (i = _i = 0, _len = faccounts.length; _i < _len; i = ++_i) {
          faccount = faccounts[i];
          _results.push(this.addFriendItem(faccount, 'hi'));
        }
        return _results;
      },
      addFriendItem: function(faccount, recentMsg) {
        var array, item, that;
        array = ['<div class="friendLine"><img src="../images/defaultUserAvatar.png" class="favatar"><div class="finfo"><div class="fid hidden">', faccount._id, '</div><div class="fnick">', faccount.nick, '</div><div class="recentMsg">', recentMsg, '</div></div></div>'];
        item = $(array.join(''));
        that = this;
        item.click(function() {
          var chatBox;
          chatBox = new ChatBox(that.socket, faccount);
          chatBox.init(that.myaccount);
          chatBox.show();
          console.log(chatBox);
          return that.chatBoxs.push(chatBox);
        });
        return this.appMainFriends.append(item);
      }
    };
    return exports = MainApp;
  });

}).call(this);
