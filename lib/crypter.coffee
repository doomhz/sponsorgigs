crypto = require "crypto"

class Crypter

  algorithm: null

  key: null

  constructor: (options)->
    options = GLOBAL.appConfig().crypter if not options and GLOBAL.appConfig()
    throw new Error "Crypter config options missing."  if not options
    @setupOptions options

  setupOptions: (options)->
    @algorithm = options.algorithm
    @key       = options.key

  encode: (value)->
    cipher = crypto.createCipher @algorithm, @key
    enc    = cipher.update value, "utf8", "hex"
    enc    += cipher.final "hex"

  decode: (value)->
    decipher = crypto.createDecipher @algorithm, @key
    enc      = decipher.update value, "hex", "utf8"
    enc      += decipher.final "utf8"

  md5: (value)->
    crypto.createHash("md5").update("#{value}#{@key}", "utf8").digest("hex")

exports = module.exports = Crypter