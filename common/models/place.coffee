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

Place.statics.search = (query, limit = 0, populate = null) ->
  promise = new Hope.Promise()
  @find(query).limit(limit).populate(populate).exec (error, values) ->
    if limit is 1
      values = values[0]
    promise.done error, values
  promise
# -- Instance methods ----------------------------------------------------------
Place.methods.parse = ->
  data =
    id        : @_id
    name      : @name
    address   : @address
    phone     : @phone
    created_at: @created_at
    updated_at: @updated_at
  if @user.parse?()
    data.user = @user.parse()
  else
    data.user = @user
  data

exports = module.exports = db.model "Place", Place
