module.exports = (app)->

  app.get "/", (req, res)->
    res.render "site/index"

  app.get "/contact", (req, res)->
    res.render "site/contact"

  app.get "/faq", (req, res)->
    res.render "site/faq"

  app.get "/terms", (req, res)->
    res.render "site/terms"

  app.get "/pricing", (req, res)->
    res.render "site/pricing"

  app.get "/ping", (req, res)->
    res.type("txt").send("ok")
