Taiga = require './index'

class UserStories extends Taiga

  getByMilestoneId: (milestoneId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/userstories'
      method = 'get'
      params = {
        milestone: milestoneId
      }
      @callAPI path, method, params, (e, body)=>
        return cb.apply @, [e] if e?

        return cb.apply @, [null, body]


module.exports = UserStories