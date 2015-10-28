'use strict';

var Test = require('zenrequest').Test;

module.exports = function() {
  var tasks = [];
  for (var i in ZENrequest.USERS) {
    tasks.push(_signup(ZENrequest.USERS[i]))
    tasks.push(_login(ZENrequest.USERS[i]))
  }
  tasks.push(_profile(ZENrequest.USERS[0]));
  return tasks;
};

// -- Tasks --------------------------------------------------------------------
var _signup = function(user) {
  return function() {
    var message = '[SIGNUP] ' + user.mail;
    return Test('POST', 'api/signup', user, null, message, 200);
  };
};

var _login = function(user) {
  return function() {
    var message = '[LOGIN]  ' + user.mail;
    return Test('POST', 'api/login', user, null, message, 200, function(response) {
      user.id = response.id;
      user.token = response.token;
    });
  };
};

var _profile = function(session) {
  return function() {
    var message = "[PROFILE]  " + session.mail + " checks profile";
    return Test("GET", "api/profile", null, _session(session), message, 200);
  };
};

// -- Private methods ----------------------------------------------------------
var _session = function(user) {
  if (user && user.token) {
    return {'x-access-token': user.token};
  } else {
    return null;
  }
}
