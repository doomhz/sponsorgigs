_ = require "underscore"

module.exports = (app)->

  app.get "/events(/)?(grid)?(row)?(map)?", (req, res)->
    renderType = _.first(_.intersection _.values(req.params), ["row", "grid", "map"]) or "grid"
    res.render "events/#{renderType}"

  app.get "/events/:id/*", (req, res)->
    eventId = req.params.id
    res.render "events/details",
      eventId: eventId

  app.get "/events/add", (req, res)->
    res.render "events/add"
