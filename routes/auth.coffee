config = require '../config.json'
facebook = require 'passport-facebook'

module.exports = (app, passport) ->

  passport.serializeUser (user, callback) ->
    done null, user
  
  passport.deserializeUser (user, callback) ->
    done null, user
  
  passport.use new facebook.Strategy config.facebook,
    (accessToken, refreshToken, profile, callback) ->
      # todo: save this
      console.dir arguments # accessToken, refreshToken, profile
      callback null, callback

  checkAuth = (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.redirect '/'

  app.get '/auth/facebook', passport.authenticate 'facebook'

  app.get '/auth/facebook/callback',
    passport.authenticate 'facebook',
      successRedirect: '/login_success',
      failureRedirect: '/login_fail'

  app.get '/login_success', checkAuth, (req, res) ->
    res.send req.user

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'


