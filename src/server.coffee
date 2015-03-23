express = require('express')
app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

app.get('/index', (req, res)->
  res.sendFile __dirname + '/indexPage/index.html'
)
app.use(express['static'](__dirname + '/indexPage'))
app.use(express['static'](__dirname))
app.listen 3000, ()->
  console.log 'server listening on :3000'
  null