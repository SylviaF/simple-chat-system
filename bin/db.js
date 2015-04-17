(function() {
  var Account, Msg, Schema, accountSchema, db, mongoose, msgSchema;

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
    },
    msgs: {
      type: Array,
      "default": []
    }
  });

  msgSchema = new Schema({
    type: {
      type: Number
    },
    from: {
      type: Object
    },
    to: {
      type: Schema.Types.ObjectId
    },
    content: {
      type: String
    },
    time: {
      type: String,
      "default": ''
    },
    count: {
      type: Number,
      "default": 1
    }
  });

  Account = db.model('Account', accountSchema);

  Msg = db.model('Msg', msgSchema);

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

  exports.setIsOnline = function(_id, isOnline) {
    return Account.findOneAndUpdate({
      _id: _id
    }, {
      isOnline: isOnline
    }, function(err, result) {});
  };

  exports.getFriendsId = function(myid, callback) {
    return Account.findOne({
      _id: myid
    }, 'friends', callback);
  };

  exports.getFriends = function(FIds, callback) {
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

  exports.addMsg = function(msg, callback) {
    var instance;
    instance = new Msg(msg);
    instance.save(function(err, result) {
      return Account.findOne({
        _id: msg.to
      }, function(err, doc) {
        if (!err) {
          doc.msgs.push(result._id);
          doc.save();
          return callback(true);
        }
      });
    });
    callback(false);
    return instance;
  };

  exports.getMsgs = function(msgIds, callback) {
    return Msg.find({
      _id: {
        $in: msgIds
      }
    }, callback);
  };

  exports.delMsg = function(fid, toid, callback) {
    return Msg.find({
      'from._id': fid,
      to: toid
    }, function(err, docs) {
      var doc1, _i, _len;
      if (!err) {
        for (_i = 0, _len = docs.length; _i < _len; _i++) {
          doc1 = docs[_i];
          doc1.count -= 1;
          Account.findOne({
            _id: toid
          }, function(err, doc2) {
            var index;
            index = doc2.msgs.indexOf(doc1._id);
            doc2.msgs.splice(index, 1);
            doc2.save();
            return callback(true);
          });
          if (doc1.count === 0) {
            doc1.remove();
          }
          doc1.save();
        }
      }
      return callback(false);
    });
  };

}).call(this);
