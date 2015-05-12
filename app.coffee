#!/usr/bin/env coffee
express = require 'express'
calcium = require 'calcium'
fs = require 'fs'

# config
config = require './config.json'

# middlewares
serveStatic = require 'serve-static'
nunjucks = require 'nunjucks'
sass = require 'node-sass-middleware'

# init app
app = express()

app.use serveStatic __dirname + '/public'
app.use sass
  src: __dirname + '/public/css'
  dest: __dirname + '/public/css'
  prefix: '/css'
  debug: true
  force: true

nunjucks.configure 'views/',
  autoescape: true,
  express: app


app.get '/', (req, res) ->
  res.sendFile __dirname + '/public/index.html'

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
