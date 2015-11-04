"use strict"
jwt = require "jwt-simple"

module.exports = (parameters) ->
  date = new Date()
  payload =
    id    : parameters._id
    expire: date.setSeconds date.getSeconds() + ZEN.session.expire
  return jwt.encode payload, ZEN.token, ZEN.encoding
