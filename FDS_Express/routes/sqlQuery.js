// execute the sql for operating mysql database
// given sql string and return the data or error
// this is one promise -- async operation
var mysql = require('mysql');
var pool = mysql.createPool({  
  host     : 'localhost',  // 主机名  
  port     : 3306, // 数据库连接的端口号 默认是3306  
  database : 'fooddelivery', // 需要查询的数据库  
  user     : 'root', // 用户名  
  password : '19630920' // 密码 // 19630920 85622607zxc
});

const querySql = (sql) => {
  return new Promise(( resolve, reject) => {
    pool.getConnection(function (err,connection) {
      if (err) {  
        console.log('与MySQL数据库建立连接失败！');
        console.log('错误信息为：' + err);
        reject({
          code: 1,
          message: 'failed to connect database: ' + err 
        });
      } else {
        connection.query(sql, function(err, result) {
          if (err) {
            console.log('操作数据库失败');
            reject({
              code: 2,
              message: 'failed to operate database: ' + err 
            });
          }  else {
            console.log('操作数据库成功');
            resolve({
              code: 0,
              data: result
            });
          }
          connection.release(); // 释放连接池的连接
        })
      }
    })
  })
}

module.exports = querySql;