// Generated by CoffeeScript 1.3.3
(function() {
  var Q, bcrypt, crypto, db, express, fs, mongo, monk, passport, router, sha,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  express = require('express');

  fs = require('fs');

  router = express.Router();

  passport = require('passport');

  bcrypt = require('bcryptjs');

  crypto = require('crypto');

  Q = require('q');

  mongo = require('mongodb');

  monk = require('monk');

  db = monk('localhost:27017/cyc');

  sha = require('../sha256.js');

  router.get('/', function(req, res, next) {
    return res.render('index', {
      title: 'CYC'
    });
  });

  router.post('/upload', function(req, res, next) {
    var users;
    console.log('new member submit');
    console.log(req.file);
    console.log(req.body);
    users = db.get('users');
    res.json({
      path: req.file.path
    });
  });

  router.get('/blog', function(req, res, next) {
    var blogs;
    blogs = db.get('blogs');
    return blogs.find({}, {
      date: 1
    }, function(e, docs) {
      var data;
      data = docs;
      console.log('[+] Sending back blogs');
      return res.json(data);
    });
  });

  router.post('/user_type', function(req, res, next) {
    var users;
    users = db.get('users');
    console.log('user_type request for ' + req.body.username);
    console.log(req.body);
    users.find({
      username: req.body.username
    }, {}, function(e, docs) {
      if (docs.length === 0) {
        console.log('couldnt find user_type');
        res.status(500).send('Invalid user');
      } else {
        console.log('returning #{docs[0].user_type} type for #{req.body.username}');
        res.json({
          user_type: docs[0].user_type
        });
      }
    });
  });

  router.post('/blog', function(req, res, next) {
    var users;
    users = db.get('users');
    users.find({
      username: req.body.author,
      user_type: "admin",
      token: req.body.token
    }, {}, function(e, docs) {
      var blogs, currentdate, datetime, new_post;
      if (docs.length === 0) {
        console.log('username or token or user_type mismatch');
        console.log(req.body.author);
        console.log(req.body.token);
        res.json({
          success: false
        });
      } else {
        blogs = db.get('blogs');
        currentdate = new Date();
        datetime = currentdate.getDate() + "/" + (currentdate.getMonth() + 1) + "/" + currentdate.getFullYear() + " @ " + currentdate.getHours() + ":" + currentdate.getMinutes() + ":" + currentdate.getSeconds();
        if (req.body.id.length === 0) {
          new_post = {
            title: req.body.title,
            author: req.body.author,
            date: datetime,
            text: req.body.text
          };
          console.log('[+] Saving new blog');
          console.log(new_post);
          blogs.insert(new_post);
        } else {
          console.log('Got a blog update for _id:' + req.body.id);
          blogs.update({
            _id: req.body.id
          }, {
            $set: {
              date: datetime,
              text: req.body.text
            }
          });
        }
        res.json({
          success: true
        });
        return;
      }
    });
  });

  router.post('/get_members', function(req, res, next) {
    var profiles, users;
    console.log('[+] got get_members request');
    console.log(req.body);
    if (!req.body.username) {
      profiles = db.get('profiles');
      profiles.find({
        user_type: 'admin'
      }, {}, function(e, docs) {
        var profile, response_data, _i, _len;
        response_data = {};
        for (_i = 0, _len = docs.length; _i < _len; _i++) {
          profile = docs[_i];
          console.log(docs);
          response_data[profile.name] = {};
          response_data[profile.name]['text'] = docs.about_text;
          response_data[profile.name]['img'] = docs.img;
        }
        res.json({
          response_data: response_data
        });
      });
    } else {
      users = db.get('users');
      users.find({
        username: req.body.username
      }, {}, function(e, docs) {
        if (docs.length === 0 || docs[0].user_type !== 'admin') {
          send_admin_profiles();
        } else {
          if (docs[0].token === req.body.token) {
            profiles = db.get('profiles');
            profiles.find({
              type: 'user'
            }, {}, function(e, docs) {
              return res.json({
                profiles: docs
              });
            });
          } else {
            res.status(500).send('Error finding members');
          }
        }
      });
    }
  });

  router.post('/profile_items', function(req, res, next) {
    var users;
    console.log('[+] profile_items request');
    console.log(req.body);
    users = db.get('users');
    users.find({
      username: req.body.username,
      token: req.body.token
    }, {}, function(e, docs) {
      var profiles, user_type;
      if (docs.length === 0) {
        res.status(500).send('No items found');
      } else {
        user_type = docs[0].user_type;
        profiles = db.get('profiles');
        profiles.find({
          username: req.body.username
        }, {}, function(e, docs) {
          var profile, profile_filters;
          if (docs.length === 0) {
            res.status(500).send('profile not found');
          } else {
            profile = {};
            if (user_type === 'admin') {
              profile_filters = {
                'username': 'username'
              };
            } else {
              profile_filters = {
                'username': 'username',
                'notes': 'notes',
                '': ''
              };
            }
            res.json({
              profile: docs[0]
            });
          }
        });
        return;
      }
    });
  });

  router.post('/profile_items_edit', function(req, res, next) {
    var queryobj, required_list, users;
    users = db.get('users');
    console.log('[+] profile_items_edit request');
    console.log(req.body);
    required_list = ['security_status', 'forms_required', 'forms_completed', 'notes', 'type', 'position', 'username'];
    queryobj = {
      username: req.body.username,
      token: req.body.token
    };
    if (__indexOf.call(req.body.profile_items, required_list) >= 0) {
      queryobj['type'] = 'admin';
    }
    users.find(queryobj, {}, function(e, docs) {
      var profiles;
      if (docs.length === 0) {
        res.status(500).send('No items found');
      } else {
        profiles = db.get('profiles');
        profiles.update({
          username: req.body.username
        }, {
          $set: req.body.profile_items
        });
        res.json({
          success: true
        });
      }
    });
  });

  router.post('/edit_submit', function(req, res, next) {
    var users;
    console.log('got an edit_submit request');
    console.log(req.body);
    users = db.get('users');
    users.find({
      username: req.body.username,
      token: req.body.token
    }, {}, function(e, docs) {
      var profile_item, profiles;
      if (docs.length === 0) {
        res.status(500).send('error updating profile');
      } else {
        profile_item = {};
        profile_item[req.body.key] = req.body.value;
        console.log('setting profile_item');
        console.log(profile_item);
        profiles = db.get('profiles');
        profiles.update({
          username: req.body.username
        }, {
          $set: profile_item
        });
        res.json({
          success: true
        });
      }
    });
  });

  router.post('/blog_delete', function(req, res, next) {
    var users;
    console.log('Got a blog delete');
    users = db.get('users');
    users.find({
      username: req.body.username,
      user_type: "admin",
      token: req.body.token
    }, {}, function(e, docs) {
      var blogs;
      if (docs.length === 0) {
        res.status(500).send('blog delete error');
      } else {
        blogs = db.get('blogs');
        blogs.remove({
          _id: req.body.id
        });
        res.json({
          success: true
        });
      }
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

  router.post('/register', function(req, res, next) {
    var users;
    console.log(req.body);
    users = db.get('users');
    users.find({
      username: req.body.username
    }, {}, function(e, docs) {
      var default_profile, profiles, token;
      console.log('DOCS');
      console.log(docs);
      if (docs.length > 0) {
        console.log('user ' + req.body.username + ' exists');
        res.status(500).send('Error registering user');
      } else {
        console.log('creating new user');
        console.log('passedhash__' + req.body.passhash + '__');
        token = crypto.randomBytes(16).toString('hex');
        users.insert({
          username: req.body.username,
          passhash: req.body.passhash,
          token: token,
          loggedin: true,
          user_type: 'user'
        });
        profiles = db.get('profiles');
        default_profile = {
          username: req.body.username,
          email: req.body.email,
          address: '',
          forms_required: '',
          age: '',
          security_status: '',
          type: 'user',
          forms_completed: '',
          notes: '',
          position: '',
          name: '',
          img: ''
        };
        profiles.insert(default_profile);
        res.json({
          loggedin: true,
          token: token
        });
      }
    });
  });

  router.post('/login', function(req, res, next) {
    var response_data, users;
    console.log('login request from ' + req.body.username);
    console.log('with passhash:__' + req.body.passhash + '__');
    users = db.get('users');
    response_data = {};
    users.find({
      username: req.body.username
    }, {}, function(e, docs) {
      var token;
      console.log(docs);
      if (docs.length > 0) {
        console.log('[+] found user: ' + docs[0].username);
        if (docs[0].passhash === req.body.passhash) {
          console.log('[+] correct password');
          token = crypto.randomBytes(16).toString('hex');
          users.update({
            username: req.body.username
          }, {
            $set: {
              loggedin: true,
              token: token
            }
          });
          response_data['token'] = token;
          response_data['user_type'] = docs[0].user_type;
          console.log('sending response ' + response_data);
          res.json({
            response_data: response_data
          });
        } else {
          console.log('[-] incorrect password');
          users.update({
            username: req.body.username
          }, {
            $set: {
              loggedin: false,
              token: ''
            }
          });
          response_data['token'] = false;
          res.status(500).send('Incorrect username or password');
        }
      } else {
        console.log('User not found');
        return res.status(500).send('User not found');
      }
    });
    console.log('exiting login');
  });

  router.post('/logout', function(req, res, next) {
    var users;
    users = db.get('users');
    console.log(req.body);
    return users.find({
      username: req.body.username,
      token: req.body.token
    }, {}, function(e, docs) {
      console.log(docs);
      if (docs.length > 0) {
        if (docs[0].loggedin) {
          users.update({
            username: req.body.username
          }, {
            $set: {
              loggedin: false,
              token: ''
            }
          });
          res.json({
            success: true
          });
        } else {
          console.log('Attempted illegal logout for #{req.body.username}');
          res.status(500).send('logout failure');
        }
      } else {
        console.log('Attempted illegal logout for #{req.body.username}');
        return res.status(500).send('logout failure');
      }
    });
  });

  module.exports = router;

}).call(this);
