calcium = require 'calcium'

module.exports = (app) ->
  app.get '/api/calcium', (req, res) ->
    t = new Date()
    calcium.get 'B100000658', (e, d) ->
      res.jsonp e or d[t.getDate()] or {}
  
  app.get '/api/calcium/:year/:month', (req, res) ->
    calcium.get 'B100000658', req.params.year, req.params.month, (e, d) ->
      res.jsonp e or d or {}
