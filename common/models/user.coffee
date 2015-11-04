"use strict"

Hope      = require("zenserver").Hope
Schema    = require("zenserver").Mongoose.Schema
db        = require("zenserver").Mongo.connections.primary

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
    user = db.model "User", User
    new user(values).save (error, value) -> promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------

exports = module.exports = db.model "User", User
