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
  # uid: {type: Schema.Types.ObjectId, index: true}
  nick: {type: String, default: '匿名用户'}
  pw: {type: String}
  email: {type: String}
  isOnline: {type: Boolean, default: false}
  friends: {type: Array, default: []}
  msgs: {type:Array, default: []}
)
msgSchema = new Schema(
  # scid: {type: Schema.Types.ObjectId}
  type: {type: Number}
  from: {type: Object}
  to: {type: Schema.Types.ObjectId}
  content: {type: String}
  time: { type: String, default: ''}
  count: {type: Number, default: 1}
)

Account = db.model('Account', accountSchema)

Msg = db.model('Msg', msgSchema)

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

exports.setIsOnline = (_id, isOnline)->
  Account.findOneAndUpdate {_id: _id}, {isOnline: isOnline}, (err, result)->
    # console.log err, result

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

exports.addMsg = (msg, callback)->
  instance = new Msg(msg)
  instance.save (err, result)->
    Account.findOne {_id: msg.to}, (err, doc)->
      if !err 
        doc.msgs.push(result._id)
        doc.save()
        callback(true)
  callback(false)
  instance
exports.getMsgs = (msgIds, callback)->
  Msg.find {_id: {$in: msgIds}}, callback
exports.delMsg = (fid, toid, callback)->
  Msg.find {'from._id': fid, to: toid}, (err, docs)->
    if !err 
      for doc1 in docs
        doc1.count -= 1
        Account.findOne {_id: toid}, (err, doc2)->
          index = doc2.msgs.indexOf(doc1._id)
          doc2.msgs.splice(index, 1)
          doc2.save()
          callback true
        if doc1.count == 0
          doc1.remove()
        doc1.save()
    callback false