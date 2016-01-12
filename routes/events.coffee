Gig     = GLOBAL.db.Gig
Emailer = require "../lib/emailer"
_       = require "underscore"

module.exports = (app)->

  app.get "/events", (req, res)->
  # app.get "/events(/)?(grid)?(row)?(map)?", (req, res)->
    renderType = _.first(_.intersection _.values(req.params), ["row", "grid", "map"]) or "grid"
    Gig.findEnabled (err, gigs)->
      res.render "events/#{renderType}",
        currentPage: "events"
        gigs: gigs

  app.get "/events/add", (req, res)->
    res.render "events/add",
      gig: Gig.build()

  app.get "/events/edit/:sid", (req, res)->
    eventSId = req.params.sid
    Gig.findBySId eventSId, (err, gig)->
      return res.redirect "/404"  if not gig
      res.render "events/edit",
        gig: gig

  app.get "/events/:pid/*", (req, res)->
    eventPId = req.params.pid
    Gig.findByPId eventPId, (err, gig)->
      return res.redirect "/404"  if not gig
      res.render "events/details",
        currentPage: "events"
        gig: gig

  app.post "/events", (req, res)->
    gigData = req.body
    Gig.createOrUpdateFromRequest gigData, (err, gig)->
      if err
        console.error err
        res.statusCode = 400
        return res.json {}
      if not gigData.id
        contactEmail = GLOBAL.appConfig().contact_email
        email = gig.email
        name = gig.organizer
        emailData =
          "user_agent": req.get('User-Agent')
          "user_ip": req.ip
          "gig_edit_url": "#{GLOBAL.appConfig().app_url}/events/edit/#{gig.sid}"
          "gig_url": "#{GLOBAL.appConfig().app_url}/events/#{gig.pid}/#{gig.slug}"
          "email": email
          "name": name
        options =
          to:
            email: contactEmail
          reply_to: email
          subject: "[new gig] #{gig.title} by #{name}"
          template: "new_gig_admin"
        emailer = new Emailer options, emailData
        emailer.send (err, result)->
          console.error err  if err
          options =
            to:
              email: email
            reply_to: contactEmail
            subject: "Thanks for adding your gig, #{name}!"
            template: "new_gig"
          emailer2 = new Emailer options, emailData
          emailer2.send (err, result)->
            console.error err  if err
      res.json
        redirect_url: "/events/edit/#{gig.sid}"

  app.post "/invest", (req, res, next)->
    pid = req.body.pid
    name = req.body.name
    email = req.body.email
    phone = req.body.phone
    contactEmail = GLOBAL.appConfig().contact_email
    Gig.findByPId pid, (err, gig)->
      if not gig
        console.error err
        res.statusCode = 404
        return res.json {}
      emailData =
        "user_agent": req.get('User-Agent')
        "user_ip": req.ip
        "gig_url": "#{GLOBAL.appConfig().app_url}/events/#{gig.pid}/#{gig.slug}"
        "gig_name": gig.name
        "name": name
        "email": email
        "phone": phone
      options =
        to:
          email: contactEmail
        reply_to: email
        subject: "[new sponsor] #{name} wants to invest"
        template: "sponsor_message_admin"
      emailer = new Emailer options, emailData
      emailer.send (err, result)->
        console.error err  if err
        options =
          to:
            email: email
          reply_to: contactEmail
          subject: "Thanks for being a sponsor, #{name}!"
          template: "sponsor_message"
        emailer2 = new Emailer options, emailData
        emailer2.send (err, result)->
          console.error err  if err
      res.json {}

