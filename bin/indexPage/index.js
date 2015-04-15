(function() {
  require(['login', 'leftBar'], function(LoginPanel, LeftBar) {
    var WebApp;
    WebApp = function(socket) {
      this.loginPanel = new LoginPanel(socket);
      this.leftBar = new LeftBar(socket);
      this.socket = socket;
      return null;
    };
    WebApp.prototype = {
      init: function() {
        this.loginPanel.init();
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
      var socket, _socket;
      socket = null;
      _socket = io.connect('http://localhost');
      return _socket.on('connect', function(data) {
        var webApp;
        socket = _socket;
        if (!socket) {
          alert('没有连接到服务器');
          return;
        }
        webApp = new WebApp(socket);
        return webApp.init();
      });
    });
  });

}).call(this);
