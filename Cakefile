require("coffee-script").register()

require "date-utils"
GLOBAL.appConfig = require "./config/config"
GLOBAL.db        = require "./models/mysql/index"

task "db:create_tables", "Create all tables", ()->
  GLOBAL.db.sequelize.sync().complete (err)->
    console.error err  if err
    console.log "Database sync complete."

task "db:migrate", "Run pending database migrations", ()->
  migrator = GLOBAL.db.sequelize.getMigrator
    path:        "#{process.cwd()}/models/mysql/migrations"
    filesFilter: /\.coffee$/
    coffee: true
  migrator.migrate().success ()->
    console.log "Database migrations finished."

task "db:migrate_undo", "Undo database migrations", ()->
  migrator = GLOBAL.db.sequelize.getMigrator
    path:        "#{process.cwd()}/models/mysql/migrations"
    filesFilter: /\.coffee$/
    coffee: true
  migrator.migrate({method: "down"}).success ()->
    console.log "Database migrations reverted."
