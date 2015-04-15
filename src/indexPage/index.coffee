require ['login', 'leftBar'], (LoginPanel, LeftBar)->

  WebApp = (socket)->
    this.loginPanel = new LoginPanel(socket)
    this.leftBar = new LeftBar(socket)
    this.socket = socket 
    null

  WebApp.prototype =
    init: ()->
      this.loginPanel.init()
      this.addEvent()

    addEvent: ()->
      that = this
      that.leftBar.appBtn.click ()->
        that.loginPanel.show()

  $ ()->
    socket = null
    _socket = io.connect 'http://localhost'
    _socket.on 'connect', (data)->
      socket = _socket;
      if !socket
        alert '没有连接到服务器'
        return 
      webApp = new WebApp(socket)
      webApp.init()