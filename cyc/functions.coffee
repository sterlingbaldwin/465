bcrypt = require 'bcryptjs'
crypto = require 'crypto'
Q = require 'q'
mongo = require 'mongodb'
monk = require 'monk'
db = monk 'localhost:27017/cyc'

exports = module.exports = {}


#signes a user out of the database
#matches a user to their authenication token
#returns true if successful logout,
#false for token mismatch or if their already logged out
exports.signout = (username, token) ->
  users = db.get('users')
  stored_token = ''
  loggedin = false
  users.find {username: username}, {}, (e, docs) ->
    stored_token = docs.token
    loggedin = docs.loggedin
    return

  if loggedin && stored_token == token
    users.update {username: username}, {$set: {loggedin: false}}
    true
  else
    console.log 'Attempted illegal logout from {username}'
    false
