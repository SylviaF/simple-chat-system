define ['searchPanel', 'infoBubble', 'chatBox'], (SearchPanel, InfoBubble, ChatBox)->
  MainApp = (socket)->
    this.all = $ '.appMainContainer'
    this.appMainNick = $('.appMainContainer .myNick')
    this.appMainFriends = $('.appMainContainer .tabContentInner')
    this.infoBubble = new InfoBubble(socket)
    this.searchPanel = new SearchPanel(socket)
    this.chatBoxs = []
    this.searchFriendBtn = $ '.appMainContainer #searchFriend'
    this.socket = socket
    null
  MainApp.prototype =
    myaccount: null
    init: (myaccount, friends)->
      # console.log "myaccount: ", myaccount
      this.myaccount = myaccount
      this.addFriends(friends)
      this.all.data('myemail', myaccount.email)
      this.appMainNick.html(myaccount.nick)
      this.searchPanel.init(myaccount)
      this.infoBubble.init(myaccount)
      # this.chatBox.init(myaccount)
      this.addEvent()
    addEvent: ()->
      that = this
      that.searchFriendBtn.click ()->
        that.searchPanel.show()
    show: ()->
      this.all.show()
    hide: ()->
      this.all.hide()
    addFriends: (faccounts)->
      this.appMainFriends.html('')
      for faccount, i in faccounts
        this.addFriendItem(faccount, 'hi')
      
    addFriendItem: (faccount, recentMsg)->
      array = [
        '<div class="friendLine"><img src="../images/defaultUserAvatar.png" class="favatar"><div class="finfo"><div class="fid hidden">'
        faccount._id
        '</div><div class="fnick">'
        faccount.nick
        '</div><div class="recentMsg">'
        recentMsg
        '</div></div></div>'
      ]
      item = $ array.join('')
      that = this
      item.click ()->
        chatBox = new ChatBox(that.socket, faccount)
        chatBox.init(that.myaccount)
        chatBox.show()
        console.log chatBox
        that.chatBoxs.push chatBox
      this.appMainFriends.append(item)

  exports = MainApp
