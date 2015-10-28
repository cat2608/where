'use strict';

var Hope      = require('hope');
var mongoose  = require('mongoose');
var Schema    = mongoose.Schema;
var bcrypt    = require('bcrypt');

var UserSchema = new Schema({
  username  : String,
  mail      : {
    type  : String,
    unique: true
  },
  password  : String,
  avatar    : String,
  created_at: {
    type   : Date,
    default: Date.now
  }
});

// -- Mongoose middleware -------------------------------------------------------------------------------
UserSchema.pre('save', function (next) {
  var user = this;
  if (!user.isModified('password')) return next();
  bcrypt.genSalt(5, function(error, salt) {
    if (error) return next(error);
    bcrypt.hash(user.password, salt, function(error, hash) {
      user.password = hash;
      next();
    });
  });
});

// -- Static methods -------------------------------------------------------------------------------
UserSchema.statics.signup = function signup (attributes) {
  var promise = new Hope.Promise();
  this.findOne({
    mail: attributes.mail
  }, function (error, user) {
    if (user) {
      error = { code: 409, message: 'Mail already registered.' };
      return promise.done(error, null);
    } else {
      var User = mongoose.model('User', UserSchema);
      return new User(attributes).save(function (error, result) {
        return promise.done(error, result);
      });
    }
  });
  return promise;
};

UserSchema.statics.login = function login (attributes) {
  var promise = new Hope.Promise();
  var user = this;
  user.findOne({
    mail: attributes.mail
  }, function(error, user) {
    if (user && bcrypt.compareSync(attributes.password, user.password)) {
      return promise.done(null, user);
    } else {
      error = {
        code: 403,
        message: "Incorrect credentials."
      };
      return promise.done(error, null);
    }
  });
  return promise;
};

UserSchema.statics.search = function search (query, limit) {
  var promise = new Hope.Promise();
  this.find(query).limit(limit).exec(function(error, value) {
    if (limit === 1 && !error) {
      if (value.length === 0) {
        error = {
          code: 402,
          message: "User not found."
        };
      }
      value = value[0];
    }
    return promise.done(error, value);
  });
  return promise;
};

// -- Instance methods -----------------------------------------------------------------------------
UserSchema.methods.parse = function parse () {
  var user = this;
  return {
    id        : user._id,
    username  : user.username,
    mail      : user.mail,
    avatar    : user.avatar,
    created_at: user.created_at
  };
};

module.exports = mongoose.model('User', UserSchema);
