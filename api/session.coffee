"use strict"

Auth  = require "../common/helpers/auth"
Hope  = require("zenserver").Hope
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
          response.json user.parse()

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
          response.json user.parse()

  ###
   * Get user profile
   * @method  GET
   * @return {Object} User profile details
  ###
  server.get "/api/profile", (request, response) ->
    Auth(request, response).then (error, result) ->
      if error
        response.json message: error.message, error.code
      else
        response.json result.parse()

  ###
   * Update user profile
   * @method  PUT
   * @param  {String} mail: user e-mail
   * @param  {String} mail: user e-mail
   * @return {Object} User profile details
  ###
  server.put "/api/profile", (request, response) ->
    Hope.shield([ ->
      Auth request, response
    , (error, session) ->
      parameters = {}
      attributes = ["username", "name", "avatar", "bio"]
      for key in attributes when request.parameters[key]?
        parameters[key] = request.parameters[key]
      session.updateAttributes parameters
    ]).then (error, result) ->
      if error
        response.json message: error.message, error.code
      else
        response.json result.parse()
