module.exports = (app)->

  app.get "/", (req, res)->
    res.render "site/index"

  app.get "/ping", (req, res)->
    res.type("txt").send("ok")
