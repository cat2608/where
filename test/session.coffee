"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _signup user for user in ZENrequest.USERS
  tasks.push _login user for user in ZENrequest.USERS
  tasks

# PROMISES ---------------------------------------------------------------------
_signup = (user) -> ->
  Test "POST", "api/signup", user, null, "[SIGNUP] #{user.mail}", 200

_login = (user, bad_credentials) -> ->
  Test "POST", "api/login", user, null, "[LOGIN] #{user.mail}", 200
