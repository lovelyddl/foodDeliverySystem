var express = require('express');
var router = express.Router();
const querySql = require('../routes/sqlQuery');

/* GET users listing. */
router.post('/login', async function(req, res, next) {
  let data = req.body;
  // let sql = `select cpassword from Customers where cname = userName`;
  // console.log(data)
  if (data.userId && data.password && data.type && data.role) {
    let checkNames = {
      customer: { userName: 'cname', phone: 'cphone', email: 'cemail', table: 'Customers', pass: 'cpassword' },
      deliveryMan: { userName: 'cname', phone: 'cphone', email: 'cemail', table: 'Deliverymen', pass: 'dpassword' }
    }
    let userType = checkNames[data.role];
    let findPassSql = `select ${userType.pass} from ${userType.table} where ${userType[data.type]} = '${data.userId}'`;
    try {
      console.log(findPassSql);
      let sqlResult = await querySql(findPassSql);
      let sqlValue = JSON.parse(JSON.stringify(sqlResult.data));
      console.log(sqlValue[0][userType.pass])
      if (sqlResult.code === 0 && sqlValue[0][userType.pass] === data.password) {
        req.session.userInfo = {
          userId: data.userId,
          password: data.password,
          role: data.role
        }
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
  req.session.userInfo = undefined;
  res.status(200).json({code: 0});
})

const isValidRegister = async function(data) {
  let table = data.role === 'customer' ? 'Customers' : 'Deliverymen';
  let checkNameSql = `select * from ${table} where cname = '${data.userName}';`;
  let checkPhoneSql = `select * from ${table} where cphone = ${data.phone};`;
  let checkEmailSql = `select * from ${table} where cemail = '${data.email}';`;
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
      console.log(error);
    }
  }
  messsage = messageList.join(", ");
  return messsage;
}

router.post('/signup', async function(req, res, next) {
  let data = req.body
  if (data.userName && data.phone && data.email && data.password, data.role) {
    let sql = '';
    if (data.role === 'customer') {
      sql = `call create_customer('${data.userName}', ${data.phone}, '${data.email}', '${data.password}');`
    } else if (data.role === 'deliveryMan') {
      sql = `call create_deliverymen('${data.userName}', ${data.phone}, '${data.email}', '${data.password}');`
    }
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
