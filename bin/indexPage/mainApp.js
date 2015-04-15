(function() {
  define(['searchPanel', 'infoBubble'], function(SearchPanel, InfoBubble) {
    var MainApp, exports;
    MainApp = function(socket) {
      this.all = $('.appMainContainer');
      this.appMainNick = $('.appMainContainer .myNick');
      this.appMainFriends = $('.appMainContainer .tabContentInner');
      this.infoBubble = new InfoBubble(socket);
      this.searchPanel = new SearchPanel(socket);
      this.searchFriendBtn = $('.appMainContainer #searchFriend');
      this.socket = socket;
      return null;
    };
    MainApp.prototype = {
      init: function(myaccount, friends) {
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
          this.addFriendItem(faccount, 'hi');
          _results.push(null);
        }
        return _results;
      },
      addFriendItem: function(faccount, recentMsg) {
        var array, item;
        array = ['<div class="friendLine"><img src="../images/defaultUserAvatar.png" class="favatar"><div class="finfo"><div class="fid hidden">', faccount._id, '</div><div class="fnick">', faccount.nick, '</div><div class="recentMsg">', recentMsg, '</div></div></div>'];
        item = array.join('');
        return this.appMainFriends.append(item);
      }
    };
    return exports = MainApp;
  });

}).call(this);
