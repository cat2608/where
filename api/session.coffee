"use strict"

User  = require "../common/models/user"
Token = require "../common/helpers/token"

module.exports = (server) ->
  ###
   * Register user
   * @method  POST
   * @param  {String} mail: user e-mail
   * @param  {String} password: user password
   * @return {Object} User profile details
  ###
  server.post "/api/signup", (request, response) ->
    if request.required ["mail", "password"]
      User.signup(request.parameters).then (error, user) ->
        if error
          response.json message: error.message, error.code
        else
          user.token = Token user
          user.save()
          response.session user.token
          response.json user

  ###
   * Login user
   * @method  POST
   * @param  {String} mail: user e-mail
   * @param  {String} password: user password
   * @return {Object} User profile details
  ###
  server.post "/api/login", (request, response) ->
    if request.required ["mail", "password"]
      User.login(request.parameters).then (error, user) ->
        if error
          response.json message: error.message, error.code
        else
          user.token = Token user
          user.save()
          response.session user.token
          response.json user
