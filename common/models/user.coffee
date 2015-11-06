"use strict"

Hope      = require("zenserver").Hope
Schema    = require("zenserver").Mongoose.Schema
db        = require("zenserver").Mongo.connections.primary
bcrypt    = require "bcrypt"

User = new Schema
  username  : type: String, trim  : true
  name      : type: String
  mail      : type: String, unique: true
  avatar    : type: String, default: "image.png"
  bio       : type: String
  token     : type: String
  twitter   :
    access_token: type: String
    oauth_secret: type: String
  password  : type: String
  created_at: type: Date, default: Date.now
  updated_at: type: Date

# -- Static methods ------------------------------------------------------------
User.statics.signup = (values) ->
  promise = new Hope.Promise()
  @findOne(mail: values.mail).exec (error, value) ->
    return promise.done code: 409, message: "Mail already in use" if value?
    if not values.twitter
      salt = bcrypt.genSaltSync 10
      values.password = bcrypt.hashSync values.password, salt
    user = db.model "User", User
    new user(values).save (error, value) ->
      promise.done error, value
  promise

User.statics.login = (values) ->
  promise = new Hope.Promise()
  @findOne mail: values.mail, (error, value) ->
    if value is null or not bcrypt.compareSync values.password, value.password
      error = code: 401, message: "The username and password do not match."
      promise.done error
    else
      promise.done error, value
  promise

User.statics.search = (query, limit = 0) ->
  promise = new Hope.Promise()
  @find(query).limit(limit).exec (error, value) ->
    if limit is 1 and not error
      if value.length is 0
        error = code: 402, message: "User not found."
      value = value[0]
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
User.methods.updateAttributes = (attributes) ->
  promise = new Hope.Promise()
  for key, value of attributes
    @[key] = value
  @save (error, result) ->
    if error?.code is 11000
      error = code: 400, message: "Username has already been taken"
    promise.done error, result
  promise

User.methods.parse = ->
  id          : @_id
  username    : @username
  mail        : @mail
  avatar      : @avatar
  token       : @token
  created_at  : @created_at


exports = module.exports = db.model "User", User
