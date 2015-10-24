'use strict';

var User = require('../models/user');

exports.signup = function(request, response) {
  User.signup(request.body).then(function signup (error, result) {
    if (error) {response.status(error.code);}
    response.json(result.parse());
  });
};
