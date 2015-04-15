(function() {
  define(function(require) {
    var InfoBubble, exports;
    InfoBubble = function(socket) {
      this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg');
      this.recentCount = $('.infoBubbleContainer .bubblePanel .count');
      this.infoTitle = $('.infoBubbleContainer .infoTitle');
      this.infoListContent = $('.infoBubbleContainer .infoListContent ul');
      this.infoFroms = {};
      this.myemail = null;
      this.socket = socket;
      return null;
    };
    InfoBubble.prototype = {
      init: function(myid) {
        this.myid = myid;
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        return that.socket.on('req ' + that.myid, function(data) {
          console.log('receive a request to make friend from ', data.nick);
          return that.addInfoItem(data, '请求添加好友');
        });
      },
      addInfoItem: function(from, msg) {
        var i, info, infoTmp;
        i = 1;
        if (this.infoFroms[from.id]) {
          info = this.infoListContent.find(['#', from.id].join(''));
          i = parseInt(info.find('.count').html()) + 1;
          info.remove();
        }
        infoTmp = ['<li id="', from.id, '"><a><span class="hidden">', from.email, '</span><span class="nick">', from.nick, '：</span><span class="msg">', msg, '</span><span class="countContainer">(<span class="count">', i, '</span>)</span></a></li>'];
        info = infoTmp.join('');
        this.infoListContent.append(info);
        return this.infoFroms[from.id] = true;
      }
    };
    return exports = InfoBubble;
  });

}).call(this);
