#!/usr/bin/env coffee
passport = require 'passport'
nunjucks = require 'nunjucks'
express = require 'express'
calcium = require 'calcium'
fs = require 'fs'

# config
config = require './config.json'

# middlewares
serveStatic = require 'serve-static'
sass = require 'node-sass-middleware'

# init app
app = express()

app.use require('cookie-parser')()
app.use require('body-parser')()
app.use require('express-session')
  secret: config.sessionSecret
app.use passport.initialize()
app.use passport.session()
app.use serveStatic __dirname + '/public'
app.use sass
  src: __dirname + '/public/css'
  dest: __dirname + '/public/css'
  prefix: '/css'
  debug: true
  force: true

nunjucks.configure 'views',
  autoescape: true,
  express: app


app.get '/', (req, res) ->
  res.render 'main/main.html'

app.get '/membership', (req, res) ->
  res.render 'membership/membership.html'

# /api

app.get '/api/calcium', (req, res) ->
  t = new Date()
  calcium.get 'B100000658', (e, d) ->
    res.jsonp e or d[t.getDate()] or {}

app.get '/api/calcium/:year/:month', (req, res) ->
  calcium.get 'B100000658', req.params.year, req.params.month, (e, d) ->
    res.jsonp e or d or {}

# listen

if typeof config.listen is 'string'
  c = ->
    app.listen config.listen
    fs.chmod config.listen, '777', ->
      console.log "Now listening on #{config.listen}"

  fs.access config.listen, (error) ->
    unless error then fs.unlink config.listen, c
    else c()

else
  app.listen config.listen
  console.log "Now listening on #{config.listen}"
