define ['searchPanel', 'infoBubble', 'chatBox'], (SearchPanel, InfoBubble, ChatBox)->
  MainApp = (socket)->
    this.all = $ '.appMainContainer'
    this.appMainNick = $('.appMainContainer .myNick')
    this.appMainFriends = $('.appMainContainer .tabContentInner')
    this.infoBubble = new InfoBubble(socket)
    this.searchPanel = new SearchPanel(socket)
    this.chatBoxs = {}
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

      that.socket.on 'isOnline', (id, isOnline)->
        if isOnline
          that.appMainFriends.find('#'+id+'favatar').removeClass('gray')
        else
          that.appMainFriends.find('#'+id+'favatar').addClass('gray')

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
        # 为每个好友创建一个聊天框
        chatBox = new ChatBox(this.socket, faccount)
        chatBox.init(this.myaccount)
        this.chatBoxs[faccount._id] = chatBox
      console.log this.chatBoxs
      
    addFriendItem: (faccount, recentMsg)->
      array = [
        '<div class="friendLine"><img id="'
        [faccount._id, 'favatar'].join('')
        '" src="../images/defaultUserAvatar.png" class="favatar'
        if faccount.isOnline then '' else ' gray'
        '"><div class="finfo"><div class="fid hidden">'
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
        that.chatBoxs[faccount._id].show()
      this.appMainFriends.append(item)

  exports = MainApp
