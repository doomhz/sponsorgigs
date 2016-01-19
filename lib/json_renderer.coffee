AppHelper = require "./app_helper"
_         = require "underscore"
_str      = require "underscore.string"

JsonRenderer =
  
  error: (err, res, code = 409, log = false)->
    res.statusCode = code
    message = ""
    if _.isString err
      message = err
    else if _.isObject(err) and err.name is "ValidationError"
      for key, val of err.errors
        if val.path is "email" and val.message is "unique"
          message += "E-mail is already taken. "
        else
          message += "#{val.message} "
    message = res.__ message  if res.__
    res.json {error: message}
    console.error message  if log

  sqlError: (err, res, code = 409, log = true)->
    console.error err  if log
    res.statusCode = code  if res
    if _.isObject(err)
      delete err.sql
      return res.json {error: @formatError("#{err}")}  if res and err.code is "ER_DUP_ENTRY"
    message = ""
    if _.isString err
      message = err
    else if _.isObject(err)
      for key, val of err
        if _.isArray val
          message += "#{val.join(' ')} "
        else
          message += "#{val} "
    return res.json {error: @formatError(message)}  if res
    @formatError(message)

  formatError: (message)->
    message = message.replace "Error: ER_DUP_ENTRY: ", ""
    message = message.replace /for key.*$/, ""
    message = message.replace /Duplicate entry/, "Value already taken"
    message = message.replace "ConflictError ", ""
    _str.trim message

exports = module.exports = JsonRenderer