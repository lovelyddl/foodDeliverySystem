var express = require('express');
var router = express.Router();
const querySql = require('../routes/sqlQuery');

const checkNames = {
  customer: { userId: 'cid', userName: 'cname', phone: 'cphone', email: 'cemail', table: 'Customers', pass: 'cpassword' },
  deliveryMan: { userId: 'did', userName: 'dname', phone: 'dphone', email: 'demail', table: 'Deliverymen', pass: 'dpassword' },
  manager: { userId: 'mid', userName: 'mname', phone: 'mphone', email: 'memail', table: 'Managers', pass: 'mpassword' },
  admin: { userId: 'aid', userName: 'aname', phone: 'aphone', email: 'aemail', table: 'Admins', pass: 'apassword' }
}

/* GET users listing. */
router.post('/login', async function(req, res, next) {
  let data = req.body;
  // console.log(data)
  if (data.userId && data.password && data.type && data.role) {
    let userType = checkNames[data.role];
    let findPassSql = `select ${userType.pass}, ${userType['userName']} from ${userType.table} where ${userType[data.type]} = '${data.userId}'`;
    try {
      console.log(findPassSql);
      let sqlResult = await querySql(findPassSql);
      let sqlValue = JSON.parse(JSON.stringify(sqlResult.data));
      console.log(sqlValue[0])
      if (sqlResult.code === 0 && sqlValue[0][userType.pass] !== undefined && sqlValue[0][userType.pass] === data.password && sqlValue[0][userType['userName']] !== undefined) {
        req.session.userInfo = {
          userName: sqlValue[0][userType['userName']],
          password: data.password,
          role: data.role
        }
        res.status(200).json({code: 0, userInfo: req.session.userInfo});
      } else {
        res.status(200).send({code: 1, error: 'Please input correct userID or password' });
      }
    } catch (error) {
      console.log(error)
      if (error.code === 1) {
        res.status(200).send({code: 1, error: error.message });
      } else {
        res.status(200).send({code: 1, error: 'Please select correct user role' });
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

router.get('/detail', async function(req, res, next) {
  // console.log(req.session.userInfo)
  let getParams = req.query;
  if (getParams.userName !== undefined && getParams.role !== undefined) {
    let user = checkNames[getParams.role];
    try {
      let sqlResult = await querySql(`select * from ${user.table} where ${user.userName} = '${getParams.userName}';`);
      if (sqlResult.code === 0) {
        let sqlValue = JSON.parse(JSON.stringify(sqlResult.data))
        console.log(sqlValue[0])
        let userData = sqlValue[0];
        res.status(200).json({code: 0, userInfo: {
            userName: userData[user.userName],
            phone: userData[user.phone],
            email: userData[user.email],
            password: userData[user.pass],
            userId: userData[user.userId]
          }
        });
      }
    } catch (error) {
      console.log(error)
      res.status(200).send({code: 1, error: error.message });
    }
  } else {
    res.status(200).send({code: 1, error: 'Please provide userName and role' });
  }

})

const isValidRegister = async function(data, isEdit = false) {
  let user = checkNames[data.role];
  let checkNameSql = `select * from ${user.table} where ${user.userName} = '${data.userName}';`;
  let checkPhoneSql = `select * from ${user.table} where ${user.phone} = ${data.phone};`;
  let checkEmailSql = `select * from ${user.table} where ${user.email} = '${data.email}';`;
  let checkArraySql = [checkNameSql, checkPhoneSql, checkEmailSql];
  let checksSql = ['userName', 'phone', 'email'];
  let messageList = [];
  let messsage = '';
  for (let i = 0; i < 3; i++) {
    try {
      let sqlResult = await querySql(checkArraySql[i]);
      if (sqlResult.code === 0) {
        let sqlValue = JSON.parse(JSON.stringify(sqlResult.data))
        if (isEdit) {
          if (sqlValue.length === 0 || (sqlValue.length === 1 && data.userId !== undefined && sqlValue[0][user['userId']] === data.userId)) {
            // valid edit information
          } else {
            messageList.push(`repeating ${checksSql[i]}`);
          }
        } else {
          if (sqlValue.length > 0) {
            messageList.push(`repeating ${checksSql[i]}`);
          }
        }
      }
    } catch (error) {
      console.log(error);
    }
  }
  messsage = messageList.join(", ");
  return messsage;
}

router.post('/editUser', async function(req, res, next) {
  let data = req.body
  if (data.userId && data.userName && data.phone && data.email && data.password) {
    let user = checkNames[data.role];
    let sql = `update ${user.table} set ${user.userName} = '${data.userName}', ${user.phone} = '${data.phone}', ${user.email} = '${data.email}', ${user.pass} = '${data.password}' where ${user.userId} = '${data.userId}'`;
    let errorMessage = await isValidRegister(data, true);
    console.log(sql)
    if (errorMessage === '') {
      try {
        let sqlResult = await querySql(sql);
        if (sqlResult.code === 0) {
          console.log('用户信息修改成功');
          res.status(200).json({code: 0});
        }
      } catch (error) {
        console.log(error)
        if (error === 'failed to connect') {
          res.status(200).send({code: 1, error: 'fail to connect database' });
        } else if (error === 'failed to operate database') {
          console.log('用户修改信息失败');
          res.status(200).send({code: 1, error: 'failed to edit user information' });
        }
      }
    } else {
      res.status(200).json({code: 1, error: errorMessage});
    }
  } else {
    res.status(200).send({code: 1, error: 'Please input correct register information' });
  }
})

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
        if (error === 'failed to connect database: ') {
          res.status(200).send({code: 1, error: 'fail to connect database !!!' });
        } else if (error === 'failed to operate database') {
          console.log('用户注册失败');
          res.status(200).send({code: 1, error: 'failed to register !!!' });
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
