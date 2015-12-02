bcrypt = require 'bcryptjs'
crypto = require 'crypto'
Q = require 'q'
mongo = require 'mongodb'
monk = require 'monk'
db = monk 'localhost:27017/cyc'

exports = module.exports = {}

#signs in a user into the database
#matches the username and hash to the stored value
#returns an authentication token if successful, false otherwise
exports.signin = (username, passhash) ->
  users = db.get('users')
  stored_hash = users.find {username: username}, {}, (e, docs) ->
    docs.passhash
  if bcrypt.compareSync stored_hash, passhash
    #stored hash matches the hash they sent
    token = crypto.randomBytes(16).toString('hex')
    users.update {username: username}, {$set: {loggedin: true, token: token}}
    return token
  else
    users.update {username: username}, {$set: {loggedin: false}}
    return false

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
