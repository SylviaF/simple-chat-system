express = require('express')
path = require('path')
# favicon = require('serve-favicon')
# logger = require('morgan')
# cookieParser = require('cookie-parser')
bodyParser = require('body-parser')

# 路由
routes = require('./routes/index')

# 项目实例
app = express()
# app.set('view engine', 'html');
# app.engine('html', hbs.__express);
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'jade')

# 定义icon图标
# app.use(favicon(__dirname + '/public/favicon.ico'));
# 定义日志和输出级别
# app.use(logger('dev'))
# 定义数据解析器
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: false }))
# 定义cookie解析器
# app.use(cookieParser());

# 定义静态文件目录
app.use(express['static'](__dirname + '/regPage'))
app.use(express['static'](__dirname + '/indexPage'))
app.use(express['static'](__dirname))

# 匹配路径和路由
app.use('/', routes)

# # 404错误处理
# app.use (req, res, next)->
#   err = new Error('Not Found');
#   err.status = 404;
#   next(err);


# 输出模型app
module.exports = app;