'use-strict';

var jwt = require('jwt-simple');
var C   = require('../config');

module.exports = function (parameters) {
  var date = new Date();
  var payload = {
    id    : parameters._id,
    expire: date.setSeconds(date.getSeconds() + C.EXPIRE)
  };
  return jwt.encode(payload, C.SECRET, C.ENCODING);
};
