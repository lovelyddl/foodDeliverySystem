var express = require('express');
var router = express.Router();
const querySql = require('../routes/sqlQuery');


router.get('/queryRestList', async function(req, res, next) {
  let getParams = req.query;
  let seachTypes = {
    restName: 'rname',
    restAddr: 'address',
    zipcode: 'zipcode',
    restType: 'restype',
    '': '*'
  };
  let searchType = seachTypes[getParams.listType];
  let searchWhere = getParams.searchKey === '' ? '' : `where ${searchType} like '%${getParams.searchKey}%'`;
  try {
    let sqlResult = await querySql(`select * from Restaurants ${seachWhere};`);
    console.log(`select * from Restaurants ${seachWhere};`)
    let sqlValue = JSON.parse(JSON.stringify(sqlResult.data))
    if (sqlResult.code === 0) {
      res.status(200).json({code: 0, data: sqlValue});
    }
  } catch (error) {
    console.log(error)
    if (error.code === 1) {
      res.status(200).send({code: 1, error: error.message });
    } else if (error.code === 2) {
      res.status(200).send({code: 1, error: 'fail to query data' });
    }
  }
})

router.get('/detail', async function(req, res, next) {
  let rid = req.query.resid;
  try {
    let resResult = await querySql(`select * from Food where menuid =  (select menuid from Menus where rid = ${rid});`);
    let resValue = JSON.parse(JSON.stringify(resResult.data))
    if (resResult.code === 0) {
      res.status(200).json({code: 0, data: resValue}); //get all food of this restaurant
    }
  } catch (error) {
    console.log(error)
    if (error.code === 1) {
      res.status(200).send({code: 1, error: error.message });
    } else if (error.code === 2) {
      res.status(200).send({code: 1, error: 'fail to query data' });
    }
  }
})

module.exports = router;