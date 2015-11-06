"use strict"

Auth  = require "../common/helpers/auth"
Hope  = require("zenserver").Hope
Place = require "../common/models/place"

module.exports = (server) ->
  server.post "/api/place", (request, response) ->
    if request.required ["user", "name"]
      Place.register(request.parameters).then (error, result) ->
        if error
          response.json response.json message: error.message, error.code
        else
          response.json result.parse()

