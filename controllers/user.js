'use strict';

var User = require('../models/user');

exports.signup = function signup (request, response) {
  User.signup(request.body).then(function signup (error, result) {
    if (error) {
      response.status(error.code).send(error.message);
    } else {
      response.json(result.parse());
    }
  });
};

exports.login = function login (request, response) {
  User.login(request.body).then(function login (error, result) {
    if (error) {
      response.status(error.code).send(error.message);
    } else {
      response.json(result.parse());
    }
  });
};
