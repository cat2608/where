'use strict';

var Hope  = require('Hope');
var jwt   = require('jwt-simple');
var User  = require('../models/user');
var C     = require('../config');

module.exports = function(request, response) {
  var limit = 0;
  var promise = new Hope.Promise();
  if (request.headers['x-access-token']) {
    var session = jwt.decode(request.headers['x-access-token'], C.SECRET);
    if (session.expire > new Date()) {
      var filter = { _id: session.id };
      User.search(filter, limit = 1).then(function(error, user) {
        if (user === null) {
          response.status(400).json({message: 'User not found.'});
        } else {
          return promise.done(error, user);
        }
      });
    } else {
      response.status(401).json({message:'Session expired. Please log in again.'});
    }
  }
  return promise;
};
