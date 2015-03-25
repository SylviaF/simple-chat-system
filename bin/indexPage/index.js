(function() {
  require(['jquery', 'login', 'infoBubble', 'leftBar', 'searchPanel'], function($, LoginPanel, InfoBubble, LeftBar, SearchPanel) {
    var WebApp;
    WebApp = function() {
      this.loginPanel = new LoginPanel();
      this.infoBubble = new InfoBubble();
      this.leftBar = new LeftBar();
      this.searchPanel = new SearchPanel();
      return null;
    };
    WebApp.prototype = {
      init: function() {
        this.loginPanel.init();
        this.infoBubble.init();
        this.searchPanel.init();
        return this.addEvent();
      },
      addEvent: function() {
        var that;
        that = this;
        return that.leftBar.appBtn.click(function() {
          return that.loginPanel.show();
        });
      }
    };
    return $(function() {
      var webApp;
      webApp = new WebApp();
      return webApp.init();
    });
  });

}).call(this);
