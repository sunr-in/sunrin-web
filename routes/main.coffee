
module.exports = (app) ->
  app.get '/', (req, res) ->
    res.render 'main/main.html'
  
  app.get '/membership', (req, res) ->
    res.render 'membership/membership.html'

# Usage:
# app.get '/some/auth/needed/page', loggedIn, (req, res) ->
loggedIn = (req, res, next) ->
  if req.isAuthenticated() then next()
  else res.redirect '/'
