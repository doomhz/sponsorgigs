module.exports = (app)->
  
  app.use (req, res)->
    #console.errorToFile "404 - [#{req.method}] #{req.originalUrl}", JSON.stringify(req.headers), JSON.stringify(req.body)  if console.errorToFile?
    res.statusCode = 404
    if req.accepts "html"
      return res.render "errors/404"
    if req.accepts "json"
      return res.send
        error: "Not found"
    res.type("txt").send("Not found")
