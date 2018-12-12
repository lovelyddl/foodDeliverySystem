var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var pool = mysql.createPool({  
  host     : 'localhost',  // 主机名  
  port     : 3306, // 数据库连接的端口号 默认是3306  
  database : 'fooddelivery', // 需要查询的数据库  
  user     : 'root', // 用户名  
  password : '85622607zxc' // 密码
});

/* GET users listing. */
router.post('/login', function(req, res, next) {
  let data = req.body
  // console.log(data)
  if (data.userId && data.password && data.type) {
    // 使用连接池  
    pool.getConnection(function (err,connection) {
      if(err){  
          console.log('与MySQL数据库建立连接失败！');  
          console.log('错误信息为：' + err);
          res.status(500).send({ error: 'fail to connect database' });
      }  
      else {  
          console.log('与MsSQL数据库建立连接成功！');
          let sql = ''
          if (data.type === 'userName') {
            sql = `select logInCheckName('${data.userId}', ${data.password});`
          } else if (data.type === 'phone') {
            sql = `select logInCheckPhone('${data.userId}', ${data.password});`
          } else if (data.type === 'email') {
            sql = `select logInCheckEmail('${data.userId}', ${data.password});`
          }
          connection.query(sql, function(err, result) {
          if(err){  
              console.log('用户登录失败'); 
              res.status(200).send({code: 1, error: 'Please input correct userID or password' });
              connection.release(); // 释放连接池的连接
          }  
          else{  
              console.log('用户登录成功成功');
              let saveAccount = {
                userId: data.userId,
                password: data.password
              }
              req.session.userInfo = saveAccount
              res.status(200).json({code: 0});
              connection.release();
              // console.log(req.session.userInfo)
          }
        })
      }
    })
  } else {
    res.status(200).send({code: 1, error: 'Please input correct userID or password' });
  }
});

router.get('/checkLog', function(req, res, next) {
  // console.log(req.session.userInfo)
  if (req.session.userInfo) {
    res.status(200).json({code: 0, userInfo: req.session.userInfo});
  } else {
    res.status(200).json({code: 1, error: 'Please log in'});
  }
})

router.post('/logout', function(req, res, next) {
  req.session.userInfo = undefined
  res.status(200).json({code: 0});
})

module.exports = router;
