"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  for user in ZENrequest.USERS
    tasks.push _signup user
    tasks.push _login user
  tasks.push _profile ZENrequest.USERS[1]
  tasks.push _update ZENrequest.USERS[2]
  tasks

# PROMISES ---------------------------------------------------------------------
_signup = (user) -> ->
  Test "POST", "api/signup", user, null, "[SIGNUP] #{user.mail}", 409

_login = (user) -> ->
  message = "[LOGIN] #{user.mail}"
  Test "POST", "api/login", user, null, message, 200, (response) ->
    user.token = response.token
    user.id = response.id

_profile = (user) -> ->
  message = "[PROFILE] GET - #{user.mail}"
  Test "GET", "api/profile", null, authorization: user.token, message, 200

_update = (user) -> ->
  data =
    name: "yisus"
    bio: """Nasí katólico xk judíos habia muxos. maria mahdalena tkm (L)
        shavales, ai k repetir santa sena cabrones."""
  message = "[PROFILE] UPDATE -  #{user.mail}"
  Test "PUT", "api/profile", data, authorization: user.token, message, 200
