#!/usr/bin/env coffee
express = require 'express'
calcium = require 'calcium'
fs = require 'fs'

# config (from package.json)
config = require('./package.json').config

# middlewares
serveStatic = require 'serve-static'
coffee = require 'coffee-middleware'
sass = require 'middlesass'

# init app
app = express()
app.use serveStatic __dirname + '/public'
app.use coffee
  src: __dirname + '/src/coffee'
  dest: __dirname + '/public/js'
  force: true
app.use sass
  src: __dirname + '/src/sass'
  dest: __dirname + '/public/css'
  prefix: '/css'
  debug: true
  force: true

app.get '/', (req, res) ->
  res.sendFile __dirname + '/index.php'

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
