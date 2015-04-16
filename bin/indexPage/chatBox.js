(function() {
  define(function(require) {
    var ChatBox, exports;
    ChatBox = function(socket, faccount) {
      this.model = $('#chatBoxModel');
      this.model.clone(true).attr('id', [faccount._id, 'ChatBox'].join('')).addClass('chatBox').appendTo('body');
      this.all = $(['#', faccount._id, 'ChatBox'].join(''));
      this.favatar = this.all.find('.chatTitle .favatar');
      this.chatInput = this.all.find('.chatInput');
      this.chatBtn = this.all.find('.chatBtn .send');
      this.chatContent = this.all.find('.chatContent');
      this.closeBtn = this.all.find('.chatTitleBtn .closeBtn');
      this.fnick = this.all.find('.fnick');
      this.fnick.html(faccount.nick);
      this.socket = socket;
      this.faccount = faccount;
      return null;
    };
    ChatBox.prototype = {
      init: function(myaccount) {
        if (!this.faccount.isOnline) {
          this.favatar.addClass('gray');
        }
        this.myaccount = myaccount;
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        that.socket.on('isOnline', function(id, isOnline) {
          if (id === that.faccount._id) {
            if (isOnline) {
              return that.favatar.removeClass('gray');
            } else {
              return that.favatar.addClass('gray');
            }
          }
        });
        that.socket.on('single chat ' + that.myaccount._id, function(from, msg, time) {
          console.log(from, msg, time);
          return that.addChatItem(from, msg, time, 1);
        });
        that.closeBtn.click(function() {
          return that.hide();
        });
        return that.chatBtn.click(function() {
          var msg, time;
          msg = that.chatInput.html();
          time = that.getTime();
          if (msg) {
            that.addChatItem(that.myaccount, msg, time, 0);
            that.chatInput.html('');
            return that.socket.emit('single chat', {
              from: that.myaccount,
              to: that.faccount._id,
              msg: msg,
              time: time
            });
          } else {
            return alert('请输入要发送的内容');
          }
        });
      },
      addChatItem: function(from, msg, time, type) {
        var tmp;
        if (type === 1 && from._id !== this.faccount._id) {
          return;
        }
        tmp = ['<div class="msgLine"><div class="msgLineTitle ', type ? 'other' : 'me', '"><span>', from.nick, '</span><span class="time">', time, '</span></div><div class="msgLineContent"> <div class="msg">', msg, '</div></div></div>'];
        return this.chatContent.append(tmp.join(''));
      },
      show: function() {
        return this.all.show();
      },
      hide: function() {
        return this.all.hide();
      },
      getTime: function() {
        return new Date().format("yyyy-MM-dd hh:mm:ss");
      }
    };
    return exports = ChatBox;
  });

}).call(this);
