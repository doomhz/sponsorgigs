fs        = require("fs")
path      = require("path")
Sequelize = require("sequelize")
lodash    = require("lodash")
db        = {}
authData  = GLOBAL.appConfig().mysql

sequelize = new Sequelize authData.db, authData.user, authData.password,
  port: authData.port
  host: authData.host
  logging: authData.logging
  maxConcurrentQueries: 100
  define:
    underscored: true
    freezeTableName: false
    syncOnAssociation: true
    charset: "utf8"
    collate: "utf8_general_ci"
    timestamps: true
  pool:
    maxConnections: 151
    maxIdleTime: 30

fs.readdirSync(__dirname).filter((file) ->
  (file.indexOf(".") isnt 0) and (file.indexOf(".coffee") isnt -1) and (file isnt "index.coffee") and (file isnt "associations.coffee")
).forEach (file) ->
  model = sequelize.import(path.join(__dirname, file))
  db[model.name] = model
  return

Object.keys(db).forEach (modelName) ->
  db[modelName].associate db  if "associate" of db[modelName]
  return

module.exports = lodash.extend(
  sequelize: sequelize
  Sequelize: Sequelize
, db)