"use strict"

Hope = require("zenserver").Hope
jwt  = require "jwt-simple"
User = require "../models/user"

module.exports = (request, response, query = null) ->
  promise = new Hope.Promise()
  if request.session
    session = jwt.decode request.session, ZEN.token
    if session.expire > new Date()
      filter = query or {}
      filter["_id"] = session.id
      User.search(filter, limit = 1).then (error, user) ->
        unless user?
          do response.unauthorized
        else
          promise.done error, user
    else
      response.json message: "Session expired. Please log in again", 401
  promise



