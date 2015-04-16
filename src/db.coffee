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
exports.getAccountById = (_id, callback)->
  Account.findOne {_id: _id}, '-pw', callback
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
exports.getFriendsId = (myid, callback)->
  Account.findOne {_id: myid}, 'friends', callback
exports.getFriends = (FIds, callback)->
  Account.find {_id: { $in:FIds}}, '-pw', callback
exports.addFriend = (myid, fid, callback)->
  Account.findOne {_id: myid}, (err, doc1)->
    if !err 
      Account.findOne {_id: fid}, (err, doc2)->
        if !err
          doc1.friends.push(fid)
          doc1.save()
          doc2.friends.push(myid)
          doc2.save()
          callback(true)
    callback(false)       