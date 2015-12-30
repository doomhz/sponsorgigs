Gig = GLOBAL.db.Gig

module.exports = (app)->

  app.get "/", (req, res)->
    Gig.findEnabledFirstPage (err, gigs)->
      res.render "site/index",
        currentPage: "home"
        gigs: gigs

  app.get "/contact", (req, res)->
    res.render "site/contact",
      currentPage: "contact"

  app.get "/faq", (req, res)->
    res.render "site/faq",
      currentPage: "faq"

  app.get "/terms", (req, res)->
    res.render "site/terms",
      currentPage: "terms"

  app.get "/pricing", (req, res)->
    res.render "site/pricing",
      currentPage: "pricing"

  app.get "/ping", (req, res)->
    res.type("txt").send("ok")
