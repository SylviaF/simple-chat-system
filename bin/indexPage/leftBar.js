(function() {
  define(function(require) {
    var exports, leftBar;
    leftBar = function(socket) {
      this.appBtn = $('.leftBar .appBtn');
      this.socket = socket;
      return null;
    };
    return exports = leftBar;
  });

}).call(this);
