(function() {
  define(function(require) {
    var InfoBubble, exports;
    InfoBubble = function(socket) {
      this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg');
      this.recentCount = $('.infoBubbleContainer .bubblePanel .count');
      this.infoAllCount = $('.infoBubbleContainer .infoTitle .count');
      this.infoListContent = $('.infoBubbleContainer .infoListContent ul');
      this.cancelNotifyBtn = $('.infoBubbleContainer .cancelNotifyBtn');
      this.viewAllBtn = $('.infoBubbleContainer .viewAllBtn');
      this.infoFroms = {};
      this.infos = [];
      this.myid = null;
      this.mynick = null;
      this.socket = socket;
      return null;
    };
    InfoBubble.prototype = {
      init: function(myaccount) {
        this.myid = myaccount._id;
        this.mynick = myaccount.nick;
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.socket.on('req ' + that.myid, function(data) {
          console.log('receive a request to make friend from ', data.nick);
          return that.addInfoItem(data, '请求添加好友', 1);
        });
        that.socket.on('reply ' + that.myid, function(from, reply) {
          if (!reply) {
            console.log(from.nick, ' refuse being a friend with you');
            return that.addInfoItem(from, '拒绝添加你为好友', 2);
          } else {
            console.log(from.nick, ' accept being a friend with you');
            return that.addInfoItem(from, '已经添加你为好友', 2);
          }
        });
        that.socket.on('single chat ' + that.myid, function(from, msg, time) {
          return that.addInfoItem(from, msg, 3);
        });
        that.cancelNotifyBtn.click(function() {
          return that.clearNotice();
        });
        return that.viewAllBtn.click(function() {
          var info, _i, _len, _ref;
          _ref = that.infos;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            info = _ref[_i];
            that.infoListContent.find('#' + info).click();
          }
          return that.clearNotice();
        });
      },
      clearNotice: function() {
        this.recentMsg.html('系统：暂无消息');
        this.recentCount.html(0);
        this.infoAllCount.html(0);
        this.infoListContent.html('');
        return this.infoFroms = {};
      },
      initInfoList: function(msgs) {
        var msg, _i, _len, _results;
        _results = [];
        for (_i = 0, _len = msgs.length; _i < _len; _i++) {
          msg = msgs[_i];
          _results.push(this.addInfoItem(msg.from, msg.content, msg.type));
        }
        return _results;
      },
      addInfoItem: function(from, msg, type) {
        var info, infoTmp, j, that;
        if (!from.id) {
          from.id = from._id;
        }
        if (this.infoFroms[from.id]) {
          this.infoFroms[from.id] += 1;
          info = this.infoListContent.find(['#', from.id].join(''));
          info.remove();
        } else {
          this.infoFroms[from.id] = 1;
          this.infos.push(from.id);
        }
        infoTmp = ['<li id="', from.id, '"><a><span class="hidden">', from.email, '</span><span class="nick">', from.nick, '：</span><span class="msg">', msg, '</span><span class="countContainer">(<span class="count">', this.infoFroms[from.id], '</span>)</span></a></li>'];
        info = $(infoTmp.join(''));
        that = this;
        info.click(function() {
          var next, rpl;
          if (type === 1) {
            rpl = confirm(['添加 ', from.nick, ' 为好友'].join(''));
            that.socket.emit('rep add friend', {
              from: {
                id: that.myid,
                nick: that.mynick
              },
              to: from.id,
              reply: rpl
            });
          }
          if (type === 2) {
            alert([from.nick, msg].join(''));
          }
          if (type === 3) {
            $(['#', from.id, 'ChatBox'].join('')).show();
          }
          next = info.next('li');
          if (next.length) {
            that.recentMsg.html(next.find('.nick').html() + '：' + next.find('.msg').html());
            that.recentCount.html(next.find('.count').html());
          } else {
            that.recentMsg.html('系统：暂无消息');
            that.recentCount.html(0);
          }
          that.infoAllCount.html(parseInt(that.infoAllCount.html()) - that.infoFroms[from.id]);
          that.infoFroms[from.id] = 0;
          that.infos.splice(that.infos.indexOf(from.id, 1));
          return this.remove();
        });
        this.infoListContent.prepend(info);
        this.recentMsg.html(from.nick + '：' + msg);
        this.recentCount.html(this.infoFroms[from.id]);
        j = parseInt(this.infoAllCount.html()) + 1;
        return this.infoAllCount.html(j);
      }
    };
    return exports = InfoBubble;
  });

}).call(this);
