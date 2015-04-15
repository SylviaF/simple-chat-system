(function() {
  var Account, Schema, SingleChat, accountSchema, db, mongoose, singleChatSchema;

  mongoose = require('mongoose');

  db = mongoose.connect('mongodb://localhost/test', function(err) {
    if (!err) {
      return console.log("connected to mongoDB");
    } else {
      throw err;
    }
  });

  Schema = mongoose.Schema;

  accountSchema = new Schema({
    uid: {
      type: Schema.Types.ObjectId,
      index: true
    },
    nick: {
      type: String,
      "default": '匿名用户'
    },
    pw: {
      type: String
    },
    email: {
      type: String
    },
    isOnline: {
      type: Boolean,
      "default": false
    },
    friends: {
      type: Array,
      "default": []
    }
  });

  singleChatSchema = new Schema({
    scid: {
      type: Schema.Types.ObjectId
    },
    fromid: {
      type: Number
    },
    toid: {
      type: Number
    },
    content: {
      type: String
    },
    date: {
      type: Date,
      "default": Date.now
    },
    isRead: {
      type: Boolean,
      "default": false
    }
  });

  Account = db.model('Account', accountSchema);

  SingleChat = db.model('SingleChat', singleChatSchema);

  exports.checkEmailExist = function(_email, callback) {
    return Account.findOne({
      email: _email
    }, callback);
  };

  exports.getPwByEmail = function(_email, callback) {
    return Account.findOne({
      email: _email
    }, 'pw', callback);
  };

  exports.getAccountByEmail = function(_email, callback) {
    return Account.findOne({
      email: _email
    }, '-pw', callback);
  };

  exports.getAccountById = function(_id, callback) {
    return Account.findOne({
      _id: _id
    }, '-pw', callback);
  };

  exports.getAccountsByEmailAndNick = function(_email, _nick, callback) {
    return Account.find({
      email: new RegExp(_email, 'gi'),
      nick: new RegExp(_nick, 'gi')
    }, callback);
  };

  exports.getAllAccouts = function(callback) {
    return Account.find(callback);
  };

  exports.addAcounts = function(_account, callback) {
    var instance;
    instance = new Account(_account);
    instance.save(callback);
    return instance;
  };

  exports.getFriendsId = function(myid, callback) {
    return Account.findOne({
      _id: myid
    }, 'friends', callback);
  };

  exports.getFriends = function(FIds, callback) {
    console.log('FIds: ', FIds);
    return Account.find({
      _id: {
        $in: FIds
      }
    }, '-pw', callback);
  };

  exports.addFriend = function(myid, fid, callback) {
    return Account.findOne({
      _id: myid
    }, function(err, doc1) {
      if (!err) {
        Account.findOne({
          _id: fid
        }, function(err, doc2) {
          if (!err) {
            doc1.friends.push(fid);
            doc1.save();
            doc2.friends.push(myid);
            doc2.save();
            return callback(true);
          }
        });
      }
      return callback(false);
    });
  };

}).call(this);
