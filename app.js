'use strict';

var express         = require('express');
var mongoose        = require('mongoose');
var bodyParser      = require('body-parser')
var userController  = require('./controllers/user');

// Driver MongoDB
mongoose.connect('mongodb://localhost:27017/where');

var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// Express router
var router = express.Router();

// Endpoints
router.route('/signup')
  .post(userController.signup);

router.route('/login')
  .post(userController.login);

app.use('/api', router);

app.listen(3000);
console.log('Server running on port 3000');
