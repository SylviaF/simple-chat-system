express = require('express')
router = express.Router()
db = require('../db')

router.get '/', (req, res, next)->
  console.log __dirname
  res.render 'index'
  null
router.get '/reg', (req, res, next)->
  res.render 'reg'
  null

router.post '/api/checkEmailExist', (req, res, next)->
  db.checkEmailExist req.body.email, (err, result)->
    if err
      res.json {'flag':false,'err': err}
    else if result
      console.log 'result:', result
      res.json {'flag': false, 'err': '邮箱已注册过，您可以直接登录或者换邮箱注册'}
    else
      newAccount = db.addAcounts req.body, (err)->
        if err
          console.log '增加用户不成功'
          res.json {'flag':false,'err':err}
        else
          console.log '增加用户 ' + newAccount + ' 成功'
          res.json {'flag':true}
  null
router.post '/api/login', (req, res, next)->
  db.getPwByEmail req.body.email, (err, result)->
    if err 
      res.json {'flag': false, 'err': err}
    else if !result
      res.json {'flag': false, 'err': '用户名不存在'}
    else if req.body.pw isnt result.pw
      res.json {'flag': false, 'err': '用户名和密码不匹配'}
    else
      # res.json {'flag': true, 'result': '用户名和密码匹配'}
      db.getAccountByEmail req.body.email, (err, result)->
        if err 
          res.json {'flag': false, 'err': err}
        else if !result
          res.json {'flag': false, 'err': '出错啦'}
        else
          res.json {'flag': true, 'result': result}

router.post '/api/getAccouts', (req, res, next)->
  if req.body.method == '0'
    db.getAccountsByEmailAndNick req.body.email, req.body.nick, (err, result)->
      if err 
        res.json {'flag': false, 'err': err}
      else
        res.json {'flag': true, 'result': result}
  else
    db.getAllAccouts (err, result)->
      if err 
        res.json {'flag': false, 'err': err}
      else
        res.json {'flag': true, 'result': result}

# 用于appMain拿到好友信息
router.post '/api/getFriends', (req, res, next)->
  db.getFriends req.body.ids.split('&'), (err, result)->
    if err 
      res.json {'flag': false, 'err': err}
    else if !result
      res.json {'flag': true, 'result': []}
    else
      res.json {'flag': true, 'result': result}
      # db.getAccountsByEmails result.friends, (err, _result)->
      #   if err 
      #     res.json {'flag': false, 'err': err}
      #   else
      #     res.json {'flag': true, 'result': result}

router.post '/api/isFriend', (req, res, next)->
  db.getFriendsId req.body.myid, (err, result)->
    if err 
      res.json {'flag': false, 'err': err}
    else 
      index = result.friends.indexOf req.body.fid
      if index == -1
        res.json {'flag': true, 'result': false}
      else
        res.json {'flag': true, 'result': true}
# router.post '/api/addFriend', (req, res, next)->
#   db.addFriend req.body.myid, req.body.fid, (err, result)->
#     if err 
#       res.json {'flag': false, 'err': err}
#     else
#       db.getAccountById req.body.fid, (err, result)->
#         if err
#           res.json {'flag': false, 'err': err}
#         else
#           res.json {'flag': true,  'result': result}

module.exports = router