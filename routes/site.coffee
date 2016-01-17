Gig     = GLOBAL.db.Gig
Emailer = require "../lib/emailer"


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

  app.get "/about_us", (req, res)->
    res.render "site/about_us",
      currentPage: "about_us"

  app.post "/contact", (req, res, next)->
    name = req.body.name
    email = req.body.email
    subject = req.body.subject
    message = req.body.message
    contactEmail = GLOBAL.appConfig().contact_email
    emailData =
      "user_agent": req.get('User-Agent')
      "user_ip": req.ip
      "name": name
      "email": email
      "message": message
    options =
      to:
        email: contactEmail
      reply_to: email
      subject: "[contact page] #{subject}"
      template: "contact"
    emailer = new Emailer options, emailData
    emailer.send (err, result)->
      console.error err if err
    res.json {}


  app.get "/ping", (req, res)->
    res.type("txt").send("ok")
