#!/usr/bin/env coffee
express = require 'express'
calcium = require 'calcium'

# config (from package.json)
config = require('./package.json').config

# middlewares
serveStatic = require 'serve-static'
coffee = require 'coffee-middleware'
sass = require 'node-sass-middleware'

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
  force: true

app.get '/', (req, res) ->
  res.sendFile __dirname + '/index.php'

# /api

app.get '/api/calcium/today', (req, res) ->
  c = calcium.get 'B100000658', (e, d) ->
    if e
      res.jsonp e
    else
      res.jsonp d


if typeof config.listen is 'string'
    c = ->
        app.listen config.listen
        fs.chmod config.listen, '777', ->
             console.log "Now listening on #{config.listen}"

    fs.exists config.listen, (exists) ->
        if exists then fs.unlink config.listen, c
        else c()

else
    app.listen config.listen
    console.log "Now listening on #{config.listen}"
