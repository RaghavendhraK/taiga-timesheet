global.config = require 'config'
async =  require 'async'

projects = config.get('projects')

# SprintUS = require './src/models/sprint_us'
# sprintUS = new SprintUS

# userStories = {}
# getUserStories = (project, asyncCb)->
#   slug = project['taiga_slug']
#   sprintUS.getByProjectSlug slug, (e, us)->
#     userStories[slug] = us
#     return asyncCb(e)

# async.eachLimit projects, 2, getUserStories, (e)->
#   console.log e, userStories

GoogleSheet = require './src/models/sheets.coffee'
sheetId = projects[0]['google_sheet_id']
gs = new GoogleSheet(sheetId)

gs.getSheet 'Sprint 23', (e, ws)->
  console.log e if e?
  
  setRows = (ws)->
    console.log 'Settings the rows', ws.title
    gs.getRows ws.id, (e, data)->
      console.log e if e?

      for row in data
        console.log row['userstorynamesprintceremonyname']
      # console.log data.length, Object.keys(data[25]),data[3]['_cre1l']

  return setRows(ws) if ws?

  gs.getSampleSheet (e, ws)->
    console.log e if e?
    return setRows(ws)
