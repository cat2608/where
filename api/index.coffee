"use strict"

module.exports = (zen) ->
  zen.get "/hello", (request, response) ->
    response.json hello: "world"
