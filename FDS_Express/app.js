var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var session = require('express-session')
var bodyParser = require('body-parser');
var logger = require('morgan');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');
var restRouter = require('./routes/restaurants');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// 添加json解析
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser('express_react_cookie'));
app.use(express.static(path.join(__dirname, 'public')));

// 统一设置返回请求头，返回的Header中设置 Access-Control-Allow-Origin 这个信息
app.use("*", function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', "http://localhost:3000");
  // http://www.bowenfirstweb.xyz http://localhost:3000
  //告诉客户端可以在HTTP请求中带上Cookie
  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Content-Length, Authorization, Accept, X-Requested-With");
  res.setHeader("Access-Control-Allow-Methods","PUT, POST, GET, DELETE, OPTIONS");
  if (req.method === 'OPTIONS') {
    res.send(200)
  } else {
    next()
  }
});

app.use(session({
  secret:'express_react_cookie',
  resave: true,
  saveUninitialized: true,
  cookie: {maxAge: 60 * 1000 * 20} // session expired time
}))
// first class router
app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/rest', restRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});

module.exports = app;
