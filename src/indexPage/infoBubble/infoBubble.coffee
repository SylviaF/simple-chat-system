define (require)->
	InfoBubble = (data)->
		# this.bubblePanel = $('.infoBubbleContainer .bubblePanel')
		# this.infoList = $('.infoBubbleContainer .infoList')
		this.recentMsg = $('.infoBubbleContainer .bubblePanel .msg')
		this.recentCount = $('.infoBubbleContainer .bubblePanel .count')
		this.infoTitle = $('.infoBubbleContainer .infoTitle')
		this.infoListContent = $('.infoBubbleContainer .infoListContent')
		null

	InfoBubble.prototype =
		init: ()->
			this.addEvent()
		addEvent: ()->
			that = this
		modifyMsgCount: ()->

		modifyRecentMsg: ()->

	exports = InfoBubble