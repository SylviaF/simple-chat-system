define (require)->
  ChatBox = (socket, faccount)->
    this.model = $('.chatBox')
    this.all = $(['#', faccount._id, 'ChatBox'].join(''))
    this.closeBtn = this.all.find('.chatTitleBtn .closeBtn')
    this.socket = socket
    this.faccount = faccount
    null

  ChatBox.prototype =
    myaccount: null
    init: (myaccount)->
      this.addEvent()
      this.myaccount = myaccount
      this.model.clone(true).attr('id', [myaccount._id, 'ChatBox'].join('')).appendTo('body')

    addEvent: ()->
      that = this
      that.closeBtn.click ()->
        console.log that
        that.hide()

    show: ()->
      this.all.show()
    hide:()->
      this.all.hide()

  exports = ChatBox