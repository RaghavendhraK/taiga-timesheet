Taiga = require './index'

class Projects extends Taiga

  getProjectsBySlug: (slug, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/projects/by_slug'
      method = 'get'
      params = {slug: slug}
      @callAPI path, method, params, (e, body)=>
        return cb.apply @, [e] if e?

        return cb.apply @, [null, body]

module.exports = Projects