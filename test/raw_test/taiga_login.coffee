loginDetails = {
  type: 'normal',
  username: 'someuser',
  password: '********'
}

restify = require 'restify'

client = restify.createJsonClient({
  url: 'https://api.taiga.io'
})

client.post '/api/v1/auth', loginDetails, (e, req, res, body)->
  console.log e, req.headers, body
