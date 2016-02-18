config = require 'config'
async =  require 'async'

projects = config.get('projects')
taigaOptions = {
  credentials: config.get('credentials.taiga')
}

SprintUS = require './src/models/sprint_us'
sprintUS = new SprintUS taigaOptions

Export2XL = require './src/models/export2xl'


userStories = {}
processProject = (project, async2Cb)->
  console.log "=============================================================="
  tempData = null
  getSprintUserStories = (asyncCb)->
    slug = project['taiga_slug']
    sprintUS.getByProjectSlug slug, (e, data)->
      return asyncCb(e) if e?

      tempData = data
      return asyncCb()

  export2Excel = (asyncCb)->
    tempData['users'] = project['users']
    Export2XL.createXLByProject tempData, (e)->
      return asyncCb(e) if e?
      
      console.log "Generated Excel for project #{tempData['project']['name']}"
      return asyncCb()

  async.series [getSprintUserStories, export2Excel], (e)->
    console.log e if e?
    return async2Cb()

async.eachSeries projects, processProject, (e)->
  console.log e if e?
  console.log 'Done successfully!!'