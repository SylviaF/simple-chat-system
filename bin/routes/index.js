(function() {
  var db, express, router;

  express = require('express');

  router = express.Router();

  db = require('../db');

  router.get('/', function(req, res, next) {
    console.log(__dirname);
    res.render('index');
    return null;
  });

  router.get('/reg', function(req, res, next) {
    res.render('reg');
    return null;
  });

  router.post('/api/checkEmailExist', function(req, res, next) {
    db.checkEmailExist(req.body.email, function(err, result) {
      var newAccount;
      if (err) {
        return res.json({
          'flag': false,
          'err': err
        });
      } else if (result.length) {
        console.log('result:', result.length);
        return res.json({
          'flag': false,
          'err': '邮箱已注册过，您可以直接登录或者换邮箱注册'
        });
      } else {
        return newAccount = db.addAcounts(req.body, function(err) {
          if (err) {
            console.log('增加用户不成功');
            return res.json({
              'flag': false,
              'err': err
            });
          } else {
            console.log('增加用户 ' + newAccount + ' 成功');
            return res.json({
              'flag': true
            });
          }
        });
      }
    });
    return null;
  });

  router.post('/api/login', function(req, res, next) {
    return db.getPwByEmail(req.body.email, function(err, result) {
      if (err) {
        return res.json({
          'flag': false,
          'err': err
        });
      } else if (!result) {
        return res.json({
          'flag': false,
          'err': '用户名不存在'
        });
      } else if (req.body.pw !== result.pw) {
        return res.json({
          'flag': false,
          'err': '用户名和密码不匹配'
        });
      } else {
        return db.getAccountByEmail(req.body.email, function(err, result) {
          if (err) {
            return res.json({
              'flag': false,
              'err': err
            });
          } else if (!result) {
            return res.json({
              'flag': false,
              'err': '出错啦'
            });
          } else {
            return res.json({
              'flag': true,
              'result': result
            });
          }
        });
      }
    });
  });

  router.post('/api/getAccouts', function(req, res, next) {
    if (req.body.method === '0') {
      return db.getAccountsByEmailAndNick(req.body.email, req.body.nick, function(err, result) {
        if (err) {
          return res.json({
            'flag': false,
            'err': err
          });
        } else {
          return res.json({
            'flag': true,
            'result': result
          });
        }
      });
    } else {
      return db.getAllAccouts(function(err, result) {
        if (err) {
          return res.json({
            'flag': false,
            'err': err
          });
        } else {
          return res.json({
            'flag': true,
            'result': result
          });
        }
      });
    }
  });

  router.post('/api/getFriends', function(req, res, next) {
    console.log("req.body.ids: ", req.body.ids);
    return db.getFriends(req.body.ids.split('&'), function(err, result) {
      if (err) {
        return res.json({
          'flag': false,
          'err': err
        });
      } else if (!result) {
        return res.json({
          'flag': true,
          'result': []
        });
      } else {
        return res.json({
          'flag': true,
          'result': result
        });
      }
    });
  });

  router.post('/api/isFriend', function(req, res, next) {
    return db.getFriendsId(req.body.myid, function(err, result) {
      var index;
      if (err) {
        return res.json({
          'flag': false,
          'err': err
        });
      } else {
        index = result.friends.indexOf(req.body.fid);
        if (index === -1) {
          return res.json({
            'flag': true,
            'result': false
          });
        } else {
          return res.json({
            'flag': true,
            'result': true
          });
        }
      }
    });
  });

  module.exports = router;

}).call(this);
