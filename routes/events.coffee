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
