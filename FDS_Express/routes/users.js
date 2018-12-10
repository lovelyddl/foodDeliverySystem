var express = require('express');
var router = express.Router();
var qs = require("querystring");
var mysql = require('mysql');

var pool = mysql.createPool({  
  host     : 'localhost',  // 主机名  
  port     : 3306, // 数据库连接的端口号 默认是3306  
  database : 'fooddelivery', // 需要查询的数据库  
  user     : 'root', // 用户名  
  password : '85622607zxc' // 密码，我的密码是空。所以是空字符串  
});

/* GET users listing. */
router.get('/login/', function(req, res, next) {
  let data = req.query
  // console.log(req.query)
  res.writeHead(200, {  
    'Content-Type': 'text/html;charset=utf8',  
    "Access-Control-Allow-Origin":"http://localhost:3000" //*表示允许的域名地址，本地则为'http://localhost' 不添加此参数 会被认为是跨域  
  });
  if (data.userId) {
    pool.getConnection(function (err,connection) { // 使用连接池  
      if(err){  
          console.log('与MySQL数据库建立连接失败！');  
          console.log('错误信息为：' + err);  
      }  
      else {  
          console.log('与MsSQL数据库建立连接成功！');
          let sql = `select loginCheck('${data.userId}', ${data.password});`
          connection.query(sql, function(err, result) {
          console.log(result)
          if(err){  
              console.log('插入数据失败'); 
              res.end('{code: 2}');
              connection.release(); // 释放连接池的连接，因为连接池默认最大
          }  
          else{  
              console.log('操作数据成功');
              res.end('{code: 1}'); 
              connection.release();
          }
        })
      }
    })
  } else {
    res.end('{code: 0}');
  }
});

module.exports = router;
