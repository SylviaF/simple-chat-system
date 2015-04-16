(function() {
  define(function(require) {
    var ChatBox, exports;
    ChatBox = function(socket, faccount) {
      this.model = $('.chatBox');
      this.all = $(['#', faccount._id, 'ChatBox'].join(''));
      this.closeBtn = this.all.find('.chatTitleBtn .closeBtn');
      this.socket = socket;
      this.faccount = faccount;
      return null;
    };
    ChatBox.prototype = {
      myaccount: null,
      init: function(myaccount) {
        this.addEvent();
        this.myaccount = myaccount;
        return this.model.clone(true).attr('id', [myaccount._id, 'ChatBox'].join('')).appendTo('body');
      },
      addEvent: function() {
        var that;
        that = this;
        return that.closeBtn.click(function() {
          console.log(that);
          return that.hide();
        });
      },
      show: function() {
        return this.all.show();
      },
      hide: function() {
        return this.all.hide();
      }
    };
    return exports = ChatBox;
  });

}).call(this);
