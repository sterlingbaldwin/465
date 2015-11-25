express = require('express')
fs = require('fs')
router = express.Router()

readFileData = (filename, callback) ->
  fs.readFile filename, 'utf8', (err, data, callback) ->
    if(err)
      console.log err
      throw err
    console.log data
    callback(data)
    return
  return

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


module.exports = router
