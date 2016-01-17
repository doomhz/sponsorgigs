fs          = require "fs"
environment = process.env.NODE_ENV or "development"
config      = JSON.parse(fs.readFileSync(process.cwd() + "/config.json", "utf8"))[environment]

exports = module.exports = ()->
  config