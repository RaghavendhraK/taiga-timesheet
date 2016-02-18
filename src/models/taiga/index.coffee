restify = require 'restify'
qs = require 'querystring'

class Taiga

  constructor: (options)->
    if options['taiga_api_url']?
      url = options['taiga_api_url']
    else
      url = 'https://api.taiga.io'
    
    @client = restify.createJSONClient({
      url: url
    })

    if options['credentials']?
      @credentials = options['credentials']
      @authToken = null
    else
      throw new Error 'Credentials are required for authentication.'

  authorise: (cb)->
    return cb.apply @, [null, @authToken] if @authToken?
    
    path = '/auth'
    method = 'post'
    params = @credentials
    @callAPI path, method, params, (e, obj)=>
      return cb.apply @, [e] if e?

      @authToken = obj['auth_token']
      return cb.apply @, [null, @authToken]

  callAPI: (path, method, params..., cb)->
    options = {
      path: '/api/v1' + path
    }
    if @authToken?
      options['headers'] = {
        Authorization: "Bearer #{@authToken}"
        'x-disable-pagination': 'True'
      }

    params = params[0] if params?.length > 0
    
    sendResponse = (e, res, obj)=>
      return cb.apply @, [e] if e?
      if res.statusCode is 200
        return cb.apply @, [null, obj]
      else
        return cb.apply @, [obj]

    if method is 'get' or method is 'del'
      options['path'] += '?' + qs.stringify(params) if params?
      @client[method] options, (e, req, res, obj)->
        obj = res.body if method is 'del'
        return sendResponse e, res, obj
    else if method is 'post' or method is 'put'
      @client[method] options, params, (e, req, res, obj)->
        return sendResponse e, res, obj
    else
      e = new Error "Unknown method #{method}"
      return cb.apply @, [e]

module.exports = Taiga