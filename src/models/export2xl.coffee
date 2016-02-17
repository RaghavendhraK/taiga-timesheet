ExcelBuilder = require 'msexcel-builder'

async = require 'async'
moment = require 'moment'

createXLByProject = (projectData, cb)->
  projectName = projectData.project.name
  workbook = ExcelBuilder.createWorkbook('./', projectName + '.xlsx')

  sprintName = projectData.sprint.name
  sheet = workbook.createSheet(sprintName, 10, 30)

  sheet.set(2, 1, 'User story name')
  sheet.merge({col:2, row:1}, {col:2, row:2})
  sheet.width(2, 45)
  sheet.align(2, 1, 'center')
  sheet.valign(2, 1, 'center')
  
  sprintFromDate = moment(projectData.sprint['from'], 'YYYY-MM-DD').format('Do MMMM YYYY')
  sprintToDate = moment(projectData.sprint['to'], 'YYYY-MM-DD').format('Do MMMM YYYY')
  sheet.set(3, 1, "#{sprintFromDate} - #{sprintToDate}")
  sheet.align(3, 1, 'center')
  noUsers = 3 + Object.keys(projectData.users).length
  sheet.merge({col:3, row:1}, {col:noUsers, row:1})

  colNo = 3
  for key, user of projectData.users
    sheet.set(colNo, 2, user)
    sheet.align(colNo, 2, 'center')
    colNo += 1

  rowNo = 3
  for userStory in projectData.user_stories
    temp = "US##{userStory['ref']} #{userStory['subject']}"
    sheet.set(2, rowNo, temp)
    sheet.wrap(2, rowNo, true)
    colNo = 3
    for key, user of projectData.users
      if userStory['time_log'][key]?
        time = userStory['time_log'][key]['in_hrs']
      else
        time = 0
      sheet.set(colNo, rowNo, time)
      sheet.align(colNo, rowNo, 'right')
      colNo += 1
    rowNo += 1

  workbook.save (e)->
    if (e) 
      workbook.cancel()
      e = new Error 'Excel creation error'
      return cb.apply @, [e]
    
    console.log "Excel sheet created for #{projectName}"
    return cb.apply @, []

module.exports = {
  
  createXLByProject: createXLByProject

  createXLs: (datas, cb)->
    async.forEach datas, createXLByProject, (e)=>
      return cb.apply @, [e]
}