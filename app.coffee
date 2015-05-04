express = require 'express'
calcium = require 'calcium'

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

app.listen '/tmp/sunrin.sock'