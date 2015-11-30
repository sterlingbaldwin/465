// Generated by CoffeeScript 1.4.0
(function() {
  var express, fs, passport, router;

  express = require('express');

  fs = require('fs');

  router = express.Router();

  passport = require('passport');

  router.get('/', function(req, res, next) {
    return res.render('index', {
      title: 'CYC'
    });
  });

  router.get('/about', function(req, res, next) {
    var response;
    response = {
      'text': ''
    };
    fs.readFile('./public/strings/about.txt', 'utf8', function(err, data) {
      if (err) {
        console.log(err);
        throw err;
      }
      response['text'] = data;
      console.log(response);
      res.json(response);
    });
  });

  router.get('/history', function(req, res, next) {
    var response;
    response = {
      'text': ''
    };
    fs.readFile('./public/strings/history.txt', 'utf8', function(err, data) {
      if (err) {
        console.log(err);
        throw err;
      }
      response['text'] = data;
      res.json(response);
    });
  });

  router.get('/volunteer', function(req, res, next) {
    return res.json({
      blarg: 'blarg'
    });
  });

  router.post('/reg', passport.authenticate('local-signup', {
    successRedirect: '/',
    failureRedirect: '/signin'
  }));

  router.post('/login', passport.authenticate('local-signin', {
    successRedirect: '/',
    failureRedirect: '/signin'
  }));

  router.get('/logout', function(req, res) {
    var name;
    name = req.user.username;
    console.log("LOGGIN OUT " + req.user.username);
    req.logout();
    res.redirect('/');
    return req.session.notice = "You have successfully been logged out " + name + "!";
  });

  module.exports = router;

}).call(this);
