mongoose = require('mongoose')
db = mongoose.connect 'mongodb://localhost/test', (err)->
  if !err
    console.log "connected to mongoDB"
  else
    throw err

# db.once 'open', ()->
#   console.log('connection successful')
# db.on 'error', ()->
#   console.error.bind console, '连接错误'

Schema = mongoose.Schema

accountSchema = new Schema(
  uid: {type: Schema.Types.ObjectId, index: true}
  nick: {type: String, default: '匿名用户'}
  pw: {type: String}
  email: {type: String}
  isOnline: {type: Boolean, default: false}
  friends: {type: Array, default: []}
)

singleChatSchema = new Schema(
  scid: {type: Schema.Types.ObjectId}
  fromid: {type: Number}
  toid: {type: Number}
  content: {type: String}
  date: { type: Date, default: Date.now}
  isRead: {type: Boolean, default: false}
)

Account = db.model('Account', accountSchema)

SingleChat = db.model('SingleChat', singleChatSchema)

exports.checkEmailExist = (_email, callback)->
  Account.findOne {email: _email}, callback
exports.getPwByEmail = (_email, callback)->
  Account.findOne {email: _email}, 'pw', callback
exports.getAccountByEmail = (_email, callback)->
  Account.findOne {email: _email}, '-pw', callback
exports.getAccountsByEmailAndNick  = (_email, _nick, callback)->
  Account.find {email: new RegExp(_email, 'gi'), nick: new RegExp(_nick, 'gi')}, callback
exports.getAllAccouts = (callback)->
  Account.find callback
exports.addAcounts = (_account, callback)->
  instance = new Account(_account)
  instance.save callback
  instance

# exports.getAccountsByEmails = (emails, callback)->
#   tmp = '(' + emails.join('|') + ')'
#   regExp = new RegExp(tmp)
#   Account.find {email: regExp}, callback
exports.getFriendsEmail = (myemail, callback)->
  Account.findOne {email: myemail}, 'friends', callback
exports.getFriends = (FEmails, callback)->
  Account.find {email: { $in:FEmails}}, '-pw', callback
exports.addFriend = (myemail, femial, callback)->
  Account.findOne {email: myemail}, (err, doc)->
    if !err 
      doc.friends.push(femial)