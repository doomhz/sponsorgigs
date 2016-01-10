Gig = GLOBAL.db.Gig
_   = require "underscore"

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

  app.get "/events/edit/:id", (req, res)->
    eventId = req.params.id
    if not parseInt eventId
      res.statusCode = 400
      return res.json {}
    Gig.findById eventId, (err, gig)->
      res.render "events/edit",
        gig: gig

  app.post "/events", (req, res)->
    gigData = req.body
    Gig.createOrUpdateFromRequest gigData, (err, gig)->
      if err
        console.error err
        res.statusCode = 400
        return res.json {}
      res.json
        redirect_url: "/events/edit/#{gig.id}"

  app.get "/events/:id/*", (req, res)->
    eventId = req.params.id
    Gig.findById eventId, (err, gig)->
      res.render "events/details",
        eventId: eventId
        currentPage: "events"
        gig: gig

