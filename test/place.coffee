"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  for place in ZENrequest.PLACES
    tasks.push _register ZENrequest.USERS[2], place
  tasks.push _myPlaces ZENrequest.USERS[2]
  tasks

# PROMISES ---------------------------------------------------------------------
_register = (user, place) -> ->
  place.user = user.id
  message = "[PLACE] REGISTER - #{user.mail} creates #{place.name}"
  Test "POST", "api/place", place, authorization: user.token, message, 200

_myPlaces = (user) -> ->
  message = "[PLACES] GET - #{user.mail} get all places"
  Test "GET", "api/places", null, authorization: user.token, message, 200
