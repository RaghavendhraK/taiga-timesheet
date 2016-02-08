Taiga = require './index'

class MileStones extends Taiga

  getByProjectId: (projectId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/milestones'
      method = 'get'
      params = {
        project: projectId
        closed: false
      }
      @callAPI path, method, params, (e, body)=>
        return cb.apply @, [e] if e?

        return cb.apply @, [null, body]

module.exports = MileStones