(function() {
  define(function(require) {
    var InfoBubble, exports;
    InfoBubble = function(socket) {
      this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg');
      this.recentCount = $('.infoBubbleContainer .bubblePanel .count');
      this.infoTitle = $('.infoBubbleContainer .infoTitle');
      this.infoListContent = $('.infoBubbleContainer .infoListContent');
      this.myemail = null;
      this.socket = socket;
      return null;
    };
    InfoBubble.prototype = {
      init: function(myemail) {
        this.myemail = myemail;
        this.addEvent();
        return this.socket.on('req ' + myemail, function(data) {
          return console.log('receive a request to make friend from ', data);
        });
      },
      addEvent: function() {
        var that;
        return that = this;
      }
    };
    return exports = InfoBubble;
  });

}).call(this);
