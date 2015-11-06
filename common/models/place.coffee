"use strict"

Hope      = require("zenserver").Hope
Schema    = require("zenserver").Mongoose.Schema
db        = require("zenserver").Mongo.connections.primary

Place = new Schema
  user      : type: Schema.ObjectId, ref: "User"
  name      : type: String
  address   : type: String
  phone     : type: Number
  created_at: type: Date, default: Date.now
  updated_at: type: Date

# -- Static methods ------------------------------------------------------------
Place.statics.register = (values) ->
  promise = new Hope.Promise()
  place = db.model "Place", Place
  new place(values).save (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Place.methods.parse = ->
  id      : @_id
  user      : @user
  name      : @name
  address   : @address
  phone     : @phone
  created_at: @created_at
  updated_at: @updated_at

exports = module.exports = db.model "Place", Place
