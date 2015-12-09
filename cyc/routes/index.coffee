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

router.get '/blog', (req, res, next) ->
  blogs = db.get('blogs')
  blogs.find({},{
    date: 1
  }, (e, docs) ->
    data = docs
    console.log '[+] Sending back blogs'
    #console.log docs
    res.json data
  )

router.post '/user_type', (req, res, next) ->
  users = db.get('users')
  console.log 'user_type request for ' + req.body.username
  console.log req.body
  users.find {
    username: req.body.username
  }, {}, (e, docs) ->
    if docs.length == 0
      console.log 'couldnt find user_type'
      res.status(500).send 'Invalid user'
    else
      console.log 'returning #{docs[0].user_type} type for #{req.body.username}'
      res.json {user_type: docs[0].user_type}
    return
  return

router.post '/blog', (req, res, next) ->
  users = db.get('users')
  users.find {
    username: req.body.author
    user_type: "admin"
    token: req.body.token
  },{},(e, docs) ->
    if docs.length == 0
      console.log 'username or token or user_type mismatch'
      console.log req.body.author
      console.log req.body.token
      res.json {success: false}
    else
      blogs = db.get('blogs')
      currentdate = new Date()
      datetime = currentdate.getDate() + "/" \
        + (currentdate.getMonth() + 1)  + "/"\
        + currentdate.getFullYear() + " @ "  \
        + currentdate.getHours() + ":"       \
        + currentdate.getMinutes() + ":"     \
        + currentdate.getSeconds()
      if req.body.id.length == 0
        new_post = {
          title: req.body.title,
          author: req.body.author,
          date: datetime,
          text: req.body.text
        }
        console.log '[+] Saving new blog'
        console.log new_post
        blogs.insert new_post
      else
        console.log 'Got a blog update for _id:' + req.body.id
        blogs.update {
          _id: req.body.id
        }, {
          $set: {
            date: datetime
            text: req.body.text
          }
        }
      res.json {success: true}
      return
    return
  return

router.post '/get_members', (req, res, next) ->
  console.log '[+] got get_members request'
  console.log req.body
  users = db.get 'users'
  users.find {
    username: req.body.username
    token: req.body.token
  }, {}, (e, docs) ->
    return
  return

router.post '/profile_items', (req, res, next) ->
  console.log '[+] profile_items request'
  console.log req.body
  users = db.get 'users'
  users.find {
    username: req.body.username
    token: req.body.token
  }, {}, (e, docs) ->
    if docs.length == 0
      res.status(500).send 'No items found'
    else
      user_type = docs[0].user_type
      profiles = db.get 'profiles'
      profiles.find {
        username: req.body.username
      }, {}, (e, docs) ->
        if docs.length == 0
          res.status(500).send 'profile not found'
        else
          profile = {}
          if user_type == 'admin'
            profile_filters = {
              'username'
            }
          else
            profile_filters = {
              'username'
              'notes'
              ''
            }
            #TODO: finish the filter for outgoing profile items
          res.json {profile: docs[0]}
        return
      return
    return
  return

router.post '/profile_items_edit', (req, res, next) ->
  users = db.get 'users'
  console.log '[+] profile_items_edit request'
  console.log req.body
  required_list = [
    'security_status'
    'forms_required'
    'forms_completed'
    'notes'
    'type'
    'position'
    'username'
  ]
  queryobj = {
    username: req.body.username
    token: req.body.token
  }
  if required_list in req.body.profile_items
    queryobj['type'] = 'admin'
  users.find queryobj, {}, (e, docs) ->
    if docs.length == 0
      res.status(500).send 'No items found'
    else
      profiles = db.get 'profiles'
      profiles.update {
        username: req.body.username
      }, {
        $set: req.body.profile_items
      }
      res.json {success: true}
    return
  return

router.post '/edit_submit', (req, res, next) ->
  console.log 'got an edit_submit request'
  console.log req.body
  users = db.get 'users'
  users.find {
    username: req.body.username
    token: req.body.token
  }, {}, (e, docs) ->
    if docs.length == 0
      res.status(500).send 'error updating profile'
    else
      profile_item = {}
      profile_item[req.body.key] = req.body.value
      console.log 'setting profile_item'
      console.log profile_item
      profiles = db.get 'profiles'
      profiles.update {
        username: req.body.username
      }, {
        $set: profile_item
      }
      res.json {success: true}
    return
  return

router.post '/blog_delete', (req, res, next) ->
  console.log 'Got a blog delete'
  users = db.get 'users'
  users.find {
    username: req.body.username
    user_type: "admin"
    token: req.body.token
  },{},(e, docs) ->
    if docs.length == 0
      res.status(500).send 'blog delete error'
    else
      blogs = db.get 'blogs'
      blogs.remove {
        _id: req.body.id
      }
      res.json {success: true}
    return
  return


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
  users.find {
    username: req.body.username
  }, {}, (e, docs) ->
    console.log 'DOCS'
    console.log docs
    if docs.length > 0
      console.log 'user ' + req.body.username + ' exists'
      res.json {loggedin: false}
      return
    else
      console.log 'creating new user'
      #passhash = bcrypt.hashSync req.body.passhash.toString()
      #console.log 'posthash: ' + passhash
      console.log 'passedhash__' + req.body.passhash + '__'
      token = crypto.randomBytes(16).toString 'hex'
      users.insert {
        username: req.body.username
        passhash: req.body.passhash
        token: token
      }
      profiles = db.get 'profiles'
      default_profile = {
        username: req.body.username
        email: req.body.email
        address: ''
        forms_required: ''
        age: ''
        security_status: ''
        type: ''
        forms_completed: ''
        notes: ''
        position: ''
      }
      profiles.insert default_profile
      res.json {
        loggedin: true
        token: token
      }
      return
  return

router.post '/login', (req, res, next) ->
  console.log 'login request from ' + req.body.username
  console.log 'with passhash:__' + req.body.passhash + '__'

  users = db.get 'users'
  response_data = {}
  users.find {
    username: req.body.username
  }, {}, (e, docs) ->
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
        response_data['user_type'] = docs[0].user_type
        console.log 'sending response ' + response_data
        res.json {response_data: response_data}
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
        res.status(500).send 'Incorrect username or password'
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
      return
    else
      console.log 'Attempted illegal logout for #{req.body.username}'
      res.status(500).send 'logout failure'


module.exports = router
