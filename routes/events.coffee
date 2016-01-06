Gig = GLOBAL.db.Gig
_   = require "underscore"

module.exports = (app)->

  app.get "/events(/)?(grid)?(row)?(map)?", (req, res)->
    renderType = _.first(_.intersection _.values(req.params), ["row", "grid", "map"]) or "grid"
    Gig.findEnabled (err, gigs)->
      res.render "events/#{renderType}",
        currentPage: "events"
        gigs: gigs

  app.get "/events/:id/*", (req, res)->
    eventId = req.params.id
    Gig.findById eventId, (err, gig)->
      res.render "events/details",
        eventId: eventId
        currentPage: "events"
        gig: gig

  app.get "/events/add", (req, res)->
    res.render "events/add"

  app.post "/events/add", (req, res)->
    gigData = req.body
    Gig.createFromRequest(gigData).complete (err, gig)->
      if err
        console.error err
        res.statusCode = 400
        res.json {}
      res.json
        redirect_url: "/events/add"
