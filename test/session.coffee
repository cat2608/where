"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  tasks.push _signup user for user in ZENrequest.USERS
  tasks.push _login user for user in ZENrequest.USERS
  tasks.push _profile ZENrequest.USERS[0]
  tasks.push _update ZENrequest.USERS[0]
  tasks

# PROMISES ---------------------------------------------------------------------
_signup = (user) -> ->
  Test "POST", "api/signup", user, null, "[SIGNUP] #{user.mail}", 409

_login = (user) -> ->
  message = "[LOGIN] #{user.mail}"
  Test "POST", "api/login", user, null, message, 200, (response) ->
    user.token = response.token

_profile = (user) -> ->
  message = "[PROFILE] #{user.mail} checks profile data"
  Test "GET", "api/profile", null, _session(user), message, 200

_update = (user) -> ->
  data =
    username: "Nico Rosberg"
  message = "[PROFILE] #{user.mail} update profile"
  Test "PUT", "api/profile", data, _session(user), message, 200

# -- Private methods -----------------------------------------------------------
_session = (user = null) ->
  if user?.token? then authorization: user.token else null
