var express = require('express');
var router = express.Router();
const querySql = require('../routes/sqlQuery');

/* GET users listing. */
router.post('/login', async function(req, res, next) {
  let data = req.body
  // console.log(data)
  if (data.userId && data.password && data.type) {
    let sql = ''
    if (data.type === 'userName') {
      sql = `select logInCheckName('${data.userId}', ${data.password}, 'customer');`
    } else if (data.type === 'phone') {
      sql = `select logInCheckPhone('${data.userId}', ${data.password}, 'customer');`
    } else if (data.type === 'email') {
      sql = `select logInCheckEmail('${data.userId}', ${data.password}, 'customer');`
    }
    try {
      let sqlResult = await querySql(sql);
      console.log(sqlResult)
      if (sqlResult.code === 0) {
        res.status(200).json({code: 0});
      }
    } catch (error) {
      console.log(error)
      if (error.code === 1) {
        res.status(200).send({code: 1, error: error.message });
      } else if (error.code === 2) {
        res.status(200).send({code: 1, error: 'Please input correct userID or password' });
      }
    }
  } else {
    res.status(200).send({code: 1, error: 'Please do not input empty information' });
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

const isValidRegister = async function(data) {
  let checkNameSql = `select * from Customers where cname = '${data.userName}';`;
  let checkPhoneSql = `select * from Customers where cphone = ${data.phone};`;
  let checkEmailSql = `select * from Customers where cemail = '${data.email}';`;
  let checkArraySql = [checkNameSql, checkPhoneSql, checkEmailSql];
  let checksSql = ['userName', 'phone', 'email'];
  let messageList = [];
  let messsage = '';
  for (let i = 0; i < 3; i++) {
    try {
      let sqlResult = await querySql(checkArraySql[i]);
      if (sqlResult.code === 0) {
        let sqlValue = JSON.parse(JSON.stringify(sqlResult.data))
        if (sqlValue.length > 0) {
          messageList.push(`repeating ${checksSql[i]}`);
        }
      }
    } catch (error) {
      console.log(error)
    }
  }
  messsage = messageList.join(", ");
  return messsage;
}

router.post('/signup', async function(req, res, next) {
  let data = req.body
  if (data.userName && data.phone && data.email && data.password) {
    let sql = `call create_customer('${data.userName}', ${data.phone}, '${data.email}', '${data.password}');`
    let errorMessage = await isValidRegister(data);
    if (errorMessage === '') {
      try {
        let sqlResult = await querySql(sql);
        if (sqlResult.code === 0) {
          console.log('用户注册成功');
          res.status(200).json({code: 0});
        }
      } catch (error) {
        console.log(error)
        if (error === 'failed to connect') {
          res.status(200).send({code: 1, error: 'fail to connect database' });
        } else if (error === 'failed to operate database') {
          console.log('用户注册失败');
          res.status(200).send({code: 1, error: 'failed to register' });
        }
      }
    } else {
      res.status(200).json({code: 1, error: errorMessage});
    }
  } else {
    res.status(200).send({code: 1, error: 'Please input correct register information' });
  }
})

module.exports = router;
