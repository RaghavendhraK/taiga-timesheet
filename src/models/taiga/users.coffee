Taiga = require './index'

class Users extends Taiga

  getByProjectId: (projectId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/users'
      method = 'get'
      params = {
        project: projectId
      }
      @callAPI path, method, params, (e, body)=>
        return cb.apply @, [e] if e?

        return cb.apply @, [null, body]


module.exports = Users