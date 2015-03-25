require(['jquery','login', 'infoBubble', 'leftBar', 'searchPanel'],
  ($, LoginPanel, InfoBubble, LeftBar, SearchPanel)->

    WebApp = ()->
      this.loginPanel = new LoginPanel()
      this.infoBubble = new InfoBubble()
      this.leftBar = new LeftBar()
      this.searchPanel = new SearchPanel()
      null

    WebApp.prototype =
      init: ()->
        this.loginPanel.init()
        this.infoBubble.init()
        this.searchPanel.init()
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