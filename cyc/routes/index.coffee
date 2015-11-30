express = require('express')
fs = require('fs')
router = express.Router()
passport = require('passport')

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

router.post '/reg', passport.authenticate('local-signup', {
  successRedirect: '/',
  failureRedirect: '/signin'
  })

router.post('/login', passport.authenticate('local-signin', {
  successRedirect: '/',
  failureRedirect: '/signin'
  })
)

router.get '/logout', (req, res) ->
  name = req.user.username
  console.log("LOGGIN OUT " + req.user.username)
  req.logout()
  res.redirect('/')
  req.session.notice = "You have successfully been logged out " + name + "!"


module.exports = router
