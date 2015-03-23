require(['jquery','login', 'infoBubble', 'leftBar'],
  ($, LoginPanel, InfoBubble, LeftBar)->

    WebApp = ()->
      this.loginPanel = new LoginPanel()
      this.infoBubble = new InfoBubble()
      this.leftBar = new LeftBar()
      null

    WebApp.prototype =
      init: ()->
        this.loginPanel.init()
        this.infoBubble.init()
        this.addEvent()
      addEvent: ()->
        that = this
        that.leftBar.appBtn.click(
          ()->
            that.loginPanel.show()
        )
    $(
      ()->
        webApp = new WebApp()
        webApp.init()
		)
)
