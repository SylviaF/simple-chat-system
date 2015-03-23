(function() {
  define(function(require) {
    var InfoBubble, exports;
    InfoBubble = function(data) {
      this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg');
      this.recentCount = $('.infoBubbleContainer .bubblePanel .count');
      this.infoTitle = $('.infoBubbleContainer .infoTitle');
      this.infoListContent = $('.infoBubbleContainer .infoListContent');
      return null;
    };
    InfoBubble.prototype = {
      init: function() {
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        return that = this;
      },
      modifyMsgCount: function() {},
      modifyRecentMsg: function() {}
    };
    return exports = InfoBubble;
  });

}).call(this);
