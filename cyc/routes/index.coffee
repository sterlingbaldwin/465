express = require('express')
fs = require('fs')
router = express.Router()
passport = require('passport')
bcrypt = require 'bcryptjs'
crypto = require 'crypto'
Q = require 'q'
mongo = require 'mongodb'
monk = require 'monk'
db = monk 'localhost:27017/cyc'

# GET home page.
router.get '/', (req, res, next) ->
  res.render 'index', title: 'CYC'

router.get '/about', (req, res, next) ->
  response = {
    'text': ''
  }
  fs.readFile './public/strings/about.txt', 'utf8', (err, data) ->
    if(err)
      console.log err
      throw err
    response['text'] = data
    console.log response
    res.json response
    return
  return

router.get '/history', (req, res, next) ->
  response = {
    'text': ''
  }
  fs.readFile './public/strings/history.txt', 'utf8', (err, data) ->
    if(err)
      console.log err
      throw err
    response['text'] = data
    res.json response
    return
  return

router.get '/volunteer', (req, res, next) ->
  res.json {blarg: 'blarg'}

router.post '/register', (req, res, next) ->
  console.log req.body
  users = db.get('users')
  users.find {username: req.username}, {}, (e, docs) ->
    console.log 'DOCS'
    console.log docs
    if docs.length > 0
      console.log 'user exists'
      res.json {loggedin: false}
      return
    else
      console.log 'creating new user'
      token = crypto.randomBytes(16).toString('hex')
      users.insert {
        username: req.username,
        passhash: bcrypt.hashSync(req.passhash, 10),
        email: req.email,
        token: token
      }
      res.json {loggedin: true, token: token}
      return
  return

router.post '/login', (req, res, next) ->
  token = functions.signin res.params.username, res.params.token
  if token #successfully logged in
    res.json {loggedin: true, token: token}
  else
    res.json {loggedin: false}

router.get '/logout', (req, res) ->
  users = db.get('users')
  users.find {username: req.username}, {}, (e, docs) ->

    if docs.length > 0 && docs.loggedin && docs.token == req.token
      users.update {username: username}, {$set: {loggedin: false}}
      res.json {success: true}
    else
      console.log 'Attempted illegal logout from {username}'
      res.status(500).send('logout failure')


module.exports = router
