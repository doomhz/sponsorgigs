fs           = require "fs"
touch        = require "touch"
simpleCdn    = require "express-simple-cdn"
environment  = process.env.NODE_ENV or 'development'

touch.sync process.cwd() + "/css.digest"
touch.sync process.cwd() + "/js.digest"
touch.sync process.cwd() + "/img.digest"
cssDigestKey = fs.readFileSync(process.cwd() + "/css.digest", "utf8")
jsDigestKey  = fs.readFileSync(process.cwd() + "/js.digest", "utf8")
imgDigestKey = fs.readFileSync(process.cwd() + "/img.digest", "utf8")
assetsHost   = GLOBAL.appConfig().assets_host or ""

initAssets = (app)->
  app.locals.AppHelper      = require("./app_helper")
  # app.locals.JsonBeautifier = require("./json_beautifier")
  app.locals._              = require("underscore")
  # app.locals._str           = require("./underscore_string")
  app.locals.cssDigestKey   = cssDigestKey
  app.locals.jsDigestKey    = jsDigestKey
  app.locals.scriptsPath    = assetsHost + "/js/"
  app.locals.CDN            = (path, noKey)->
    glueSign  = if path.indexOf("?") > -1 then "&" else "?"
    assetsKey = "#{glueSign}_=#{imgDigestKey}" or ""
    assetsKey = ""  if noKey
    simpleCdn(path, assetsHost) + assetsKey;
  app.locals.CSS            = (path)->
    extension = if environment is "production" and not /\.min$/.test(path) then ".min.css" else ".css"
    assetsKey = "?_=#{cssDigestKey}" or ""
    simpleCdn(path, assetsHost + "/css/") + extension + assetsKey;
  app.locals.THEMECSS       = (path)->
    # extension = if environment is "production" and not /\.min$/.test(path) then ".min.css" else ".css"
    extension = ".css"
    assetsKey = "?_=#{cssDigestKey}" or ""
    simpleCdn(path, assetsHost + "/theme/") + extension + assetsKey;
  app.locals.JS             = (path)->
    extension = if environment is "production" and not /\.min$/.test(path) then ".min.js" else ".js"
    assetsKey = "?_=#{jsDigestKey}" or ""
    simpleCdn(path, assetsHost + "/js/") + extension + assetsKey;
  app.locals.THEMEJS        = (path)->
    # extension = if environment is "production" and not /\.min$/.test(path) then ".min.js" else ".js"
    extension = ".js"
    assetsKey = "?_=#{jsDigestKey}" or ""
    simpleCdn(path, assetsHost + "/theme/") + extension + assetsKey;
  app

exports = module.exports = initAssets