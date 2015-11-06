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

  server.get "/api/places", (request, response) ->
    Hope.shield([ ->
      Auth request, response
    , (error, session) ->
      Place.search user: session._id, limit = 0, populate = "user"
    ]).then (error, result) ->
      if error
        response.json response.json message: error.message, error.code
      else
        places = []
        for place in result
          places.push place.parse()
        response.json places
