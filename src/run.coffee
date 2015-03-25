# 依赖加载
app = require('./server')
debug = require('debug')('nodejs-demo:server')
http = require('http')

# 端口标准化函数
normalizePort = (val)->
  port = parseInt(val, 10)
  if isNaN(port)
    return val
  if port >= 0
    return port
  return false

# 事件绑定函数
onListening = ()->
  addr = server.address()
  bind = if typeof addr is 'string' then 'pipe ' + addr else 'port ' + addr.port
  debug('Listening on ' + bind)

onError = (error)->
  if error.syscall isnt 'listen'
    throw error

  bind = if typeof port is 'string' then 'Pipe ' + port else 'Port ' + port

  switch error.code
    when 'EACCES' 
      console.error(bind + ' requires elevated privileges')
      process.exit(1)
      break
    when 'EADDRINUSE'
      console.error(bind + ' is already in use')
      process.exit(1)
      break
    else
      throw error

# 定义启动端口
port = normalizePort(process.env.PORT || '3000')
app.set('port', port)

# 创建HTTP服务器实例
server = http.createServer(app)

# 启动网络服务监听端口
server.listen(port)
# server.on('error', onError)
# server.on('listening', onListening)