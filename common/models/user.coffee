"use strict"

Hope      = require("zenserver").Hope
Schema    = require("zenserver").Mongoose.Schema
db        = require("zenserver").Mongo.connections.primary
bcrypt    = require "bcrypt"

User = new Schema
  username  : type: String, trim  : true
  mail      : type: String, unique: true
  avatar    : type: String, default: "image.png"
  token     : type: String
  password  : type: String
  location  : type: String
  created_at: type: Date, default: Date.now
  updated_at: type: Date

# -- Static methods ------------------------------------------------------------
User.statics.signup = (values) ->
  promise = new Hope.Promise()
  @findOne(mail: values.mail).exec (error, value) ->
    return promise.done code: 409, message: "Mail already in use" if value?
    salt = bcrypt.genSaltSync 10
    values.password = bcrypt.hashSync values.password, salt
    user = db.model "User", User
    new user(values).save (error, value) -> promise.done error, value
  promise

User.statics.login = (values) ->
  promise = new Hope.Promise()
  @findOne mail: values.mail, (error, user) ->
    valid = bcrypt.compareSync values.password, user.password
    if user is null or not valid
      error = code: 401, message: "Incorrect username or password."
      promise.done error
    else
      promise.done error, user
  promise

# -- Instance methods ----------------------------------------------------------

exports = module.exports = db.model "User", User
