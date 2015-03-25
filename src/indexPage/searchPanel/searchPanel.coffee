define (require)->

  SearchPanel = ()->
    this.all = $('.searchPanelContainer')
    this.closeBtn = $('.searchPanelContainer .closeBtn')
    this.inputForm = $('.searchPanelContainer .inputForm')
    this.searchResult = $('.searchPanelContainer .searchResult')
    this.email = $('.searchPanelContainer .semail')
    this.nick = $('.searchPanelContainer .snick')
    this.searchBtn = $('.searchPanelContainer .searchPanelBtn a')
    this.methodRadio = $('.searchPanelContainer input[name="method"]')
    this.method = 0 # 0:精确查找, 1:查找所有
    this.heading = $('.searchPanelContainer  .searchPanelContent h5')
    this.accurateIpt = $('.searchPanelContainer .inputs')
    null

  SearchPanel.prototype =
    init: ()->
      this.all.hide()
      this.addEvent()
    addEvent: ()->
      that = this

      that.closeBtn.click ()->
        console.log 1
        that.all.hide()
        that.inputForm.show()
        that.searchResult.hide()
        that.email.val('')
        that.nick.val('')
        that.heading.html('查找方式')

      that.methodRadio.click ()->
        that.method = parseInt($('input:radio[name="method"]:checked').val())
        if !that.method
          that.accurateIpt.show()
        else
          that.accurateIpt.hide()

      that.searchBtn.click ()->
        $.ajax
          type: 'POST'
          url: '/api/getAccouts'
          data: 
            method: that.method
            email: that.email.val()
            nick: that.nick.val()
          dataType: 'json'
          success: (data)->
            if !data.flag
              console.log(data.err)
            else
              that.heading.html('查找结果')
              that.addUserList(data.result)
              that.inputForm.hide()
              that.searchResult.show()
              console.log(data.result)
          error: (err)->
            console.log err

    addUserList: (userList)->
      classes = ['odd', '']
      this.searchResult.html('')
      for user, i in userList
        cls = classes[i%2]
        this.addUserItem(user, cls)
    addUserItem: (userItem, classname)->
      array = [
        '<div class="findItem '+classname+'odd"><div class="info"><div class="nick">'
        userItem.nick
        '</div><div class="second"><span>在线：</span><span class="isOnline">是</span></div><div class="second"><span>邮箱：</span><span class="email">'
        userItem.email
        '</span></div></div><div class="btn">加为好友</div></div>'
      ]
      item = array.join('');
      this.searchResult.append(item)
  exports = SearchPanel