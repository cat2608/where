"use strict"

User  = require "../common/models/user"

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
          response.json user
