Taiga = require './index'

ChangeCase = require 'change-case'
async = require 'async'

class TimeLog extends Taiga

  getTimeLogAttr: (projectId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/task-custom-attributes'
      method = 'get'
      params = {
        project: projectId
      }
      @callAPI path, method, params, (e, attributes)=>
        return cb.apply @, [e] if e?

        for attribute in attributes
          name = ChangeCase.lower(ChangeCase.constant(attribute['name']))
          if name is 'time_log'
            return cb.apply @, [null, attribute]

        e = new Error 'Tasks Custom field Time Log not found.'
        return cb.apply @, [e]

  getTimeLogAttrValues: (taskId, attrId, cb)->
    @authorise (e)=>
      return cb.apply @, [e] if e?

      path = '/tasks/custom-attributes-values/' + taskId
      method = 'get'
      @callAPI path, method, (e, result)=>
        return cb.apply @, [e] if e?

        attrId = attrId.toString()
        for key, attrValue of result['attributes_values']
          if key is attrId
            return cb.apply @, [null, attrValue]

        return cb.apply @, [null, '00:00']

  getTimeLogs: (projectId, taskIds, cb)->
    @getTimeLogAttr projectId, (e, attr)=>
      return cb.apply @, [e] if e?

      result = {}
      getTimeLogValues = (taskId, asynCb)=>
        @getTimeLogAttrValues taskId, attr['id'], (e, value)->
          return asynCb(e) if e?

          result[taskId] = value
          return asynCb()

      async.each taskIds, getTimeLogValues, (e)=>
        return cb.apply @, [e, result]

module.exports = TimeLog