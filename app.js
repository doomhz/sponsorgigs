require('coffee-script').register();

var express           = require('express');
var bodyParser        = require('body-parser');
var methodOverride    = require('method-override');
var session           = require('express-session');
// var MySQLSessionStore = require('express-mysql-session');
var cookieParser      = require('cookie-parser');
var compression       = require('compression');
var errorhandler      = require('errorhandler');
var http              = require('http');
var environment       = process.env.NODE_ENV || 'development';


// Configure globals
GLOBAL.appConfig = require("./config/config");

require('date-utils');

// GLOBAL.db       = require('./models/mysql/index');

// Setup express
var app = express();
var cookieParser  = cookieParser(GLOBAL.appConfig().session.cookie_secret);
// var sessionStore = new MySQLSessionStore(GLOBAL.appConfig().mysql)

app.enable("trust proxy");
app.disable('x-powered-by');
app.set('port', process.env.PORT || 5000);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use(compression());
app.use(bodyParser());
app.use(methodOverride());
app.use(cookieParser);
app.use(session({
  name:              GLOBAL.appConfig().session.session_key,
  secret:            GLOBAL.appConfig().session.cookie_secret,
  // store:             sessionStore,
  proxy:             true,
  cookie:            GLOBAL.appConfig().session.cookie,
  saveUninitialized: true,
  resave:            true
}));
app.use(express.static(__dirname + '/public'), {maxAge: 2592000000}); // 30 days
app.use(function(err, req, res, next) {
  if (err.status === 400) {
    res.statusCode = 404;
    res.render("errors/404");
  } else {
    console.error("503 - [" + req.method + "] " + req.originalUrl + " - ", err, " - ", JSON.stringify(req.headers), JSON.stringify(req.body));
    res.statusCode = 503;
    res.render("errors/500");
  }
});


// Routes
require('./routes/site')(app);
require('./routes/errors')(app);


// Configuration
if (environment === "dev") {
  app.use(errorhandler({ dumpExceptions: true, showStack: true }));
};
if (environment === "production") {
  app.use(errorhandler());
}

var server = http.createServer(app);

server.listen(app.get('port'), function(){
  console.log("Sponsorgigs is running on port %d in %s mode", app.get("port"), app.settings.env);
});
