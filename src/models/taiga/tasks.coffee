Taiga = require './index'

class Tasks extends Taiga

  getByMilestoneId: (milestoneId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/tasks'
      method = 'get'
      params = {
        milestone: milestoneId
        # is_closed: true
      }
      @callAPI path, method, params, (e, body)=>
        return cb.apply @, [e] if e?

        return cb.apply @, [null, body]

module.exports = Tasks