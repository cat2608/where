'use strict';

var Test = require('zenrequest').Test;

module.exports = function() {
  var tasks = [];
  for (var i in ZENrequest.USERS) {
    tasks.push(_signup(ZENrequest.USERS[i]))
    tasks.push(_login(ZENrequest.USERS[i]))
  }
  return tasks;
};

// -- Tasks --------------------------------------------------------------------
var _signup = function(user) {
  return function() {
    return Test('POST', 'api/signup', user, null, '[SIGNUP] ' + user.mail, 200, function(response) {
    });
  };
};

var _login = function(user) {
  return function() {
    return Test('POST', 'api/login', user, null, '[LOGIN]  ' + user.mail, 200, function(response) {
      user.id = response.id;
      user.token = response.token;
    });
  };
};
