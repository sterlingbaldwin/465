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
sha = require '../sha256.js'

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
  users.find {username: req.body.username}, {}, (e, docs) ->
    console.log 'DOCS'
    console.log docs
    if docs.length > 0
      console.log 'user #{docs[0].username} exists'
      res.json {loggedin: false}
      return
    else
      console.log 'creating new user'
      #passhash = bcrypt.hashSync req.body.passhash.toString()
      #console.log 'posthash: ' + passhash
      console.log 'passedhash__' + req.body.passhash + '__'
      token = crypto.randomBytes(16).toString('hex')
      users.insert {
        username: req.body.username,
        passhash: req.body.passhash,
        email: req.body.email,
        token: token
      }
      res.json {loggedin: true, token: token}
      return
  return

router.post '/login', (req, res, next) ->
  console.log 'login request from ' + req.body.username
  console.log 'with passhash:__' + req.body.passhash + '__'

  users = db.get('users')
  response_data = {}
  users.find {username: req.body.username}, {}, (e, docs) ->
    console.log docs
    if docs.length > 0
      #the user exists
      console.log '[+] found user: ' + docs[0].username
      # stored_hash = docs[0].passhash.toString()
      # passed_hash = bcrypt.hashSync req.body.passhash.toString()
      # console.log 'storedhash: ' + stored_hash
      # console.log 'passedhash: ' + passed_hash
      #if bcrypt.compareSync stored_hash, passed_hash
      if docs[0].passhash == req.body.passhash
        #stored hash matches the hash they sent
        console.log '[+] correct password'
        token = crypto.randomBytes(16).toString('hex')
        users.update {
          username: req.body.username
        },{
          $set: {
            loggedin: true,
            token: token
          }
        }
        response_data['token'] = token
      else
        console.log '[-] incorrect password'
        users.update {
          username: req.body.username
        },{
          $set: {
            loggedin: false,
            token: ''
          }
        }
        response_data['token'] = false
      console.log 'sending response ' + response_data
      res.json {response_data: response_data}
      return
    else
      console.log 'User not found'
      res.status(500).send 'User not found'
  console.log 'exiting login'
  return

router.post '/logout', (req, res, next) ->
  users = db.get('users')
  console.log req.body
  users.find {
    username: req.body.username,
    token: req.body.token
  }, {}, (e, docs) ->
    console.log docs
    if docs.length > 0
      if docs[0].loggedin
        users.update {
          username: req.body.username
        }, {
          $set: {
            loggedin: false,
            token: ''
          }
        }
        res.json {success: true}
    else
      console.log 'Attempted illegal logout for #{req.body.username}'
      res.status(500).send 'logout failure'


module.exports = router
