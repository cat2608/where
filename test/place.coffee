"use strict"

Test = require("zenrequest").Test

module.exports = ->
  tasks = []
  for place in ZENrequest.PLACES
    tasks.push _register ZENrequest.USERS[2], place
  tasks

# PROMISES ---------------------------------------------------------------------
_register = (user, place) -> ->
  place.user = user.id
  message = "[PLACE] REGISTER -  #{user.mail} creates #{place.name}"
  Test "POST", "api/place", place, authorization: user.token, message, 200
