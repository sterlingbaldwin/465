// functions.js/
var bcrypt = require('bcryptjs'),
    Q = require('q'),
    mongo = require('mongodb'),
    monk = require('monk'),
    db = monk('localhost:27017/cyc');
