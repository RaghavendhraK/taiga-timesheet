Projects = require './taiga/projects'
Milestones = require './taiga/milestones'
UserStories = require './taiga/user_stories'
Tasks = require './taiga/tasks'
TimeLog = require './taiga/time_log'

async = require 'async'
_ = require 'underscore'

class SprintUSTasks

  getByProjectSlug: (projectSlug, cb)->

    projectName = null
    projectId = null
    getProject = (asyncCb)->
      projectsModel = new Projects
      projectsModel.getProjectsBySlug projectSlug, (e, project)->
        return asyncCb(e) if e?

        projectName = project.name
        projectId = project.id
        console.log 'Project', projectName, projectSlug, projectId
        return asyncCb(null, projectId)

    sprintId = null
    sprintName = null
    sprintFromDate = null
    sprintToDate = null
    getMileStone = (projectId, asyncCb)->
      milestonesModel = new Milestones
      milestonesModel.getByProjectId projectId, (e, milestones)->
        return asyncCb(e) if e?
        
        if milestones?.length > 1
          e = new Error 'More than one open sprints'
          return asyncCb(e)
        else if milestones?.length is 0
          e = new Error 'No open sprints'
          return asyncCb(e)

        sprint = milestones[0]
        sprintId = sprint.id
        sprintName = sprint.name
        sprintFromDate = sprint.estimated_start
        sprintToDate = sprint.estimated_finish
        console.log 'Sprint', sprintName, sprintId
        return asyncCb(null, sprintId)

    userStories = []
    getUserStories = (asyncCb)->
      userStoriesModel = new UserStories
      userStoriesModel.getByMilestoneId sprintId, (e, result)->
        return asyncCb(e) if e?

        userStories = result
        console.log 'Userstories', userStories.length
        return asyncCb(null, userStories)

    tasks = []
    getTasks = (asyncCb)->
      tasksModel = new Tasks
      tasksModel.getByMilestoneId sprintId, (e, response)->
        return asyncCb(e) if e?

        tasks = response
        
        taskIds = _.pluck tasks, 'id'
        
        timeLogModel = new TimeLog
        timeLogModel.getTimeLogs projectId, taskIds, (e, result)->
          return asyncCb(e) if e?
          
          for task in response
            task['time_log'] = result[task['id']]

          console.log 'Tasks', tasks.length
          return asyncCb(null, tasks)

    getUserStoriesAndTasks = (sprintId, asyncCb)->
      tasks = {
        user_stories: getUserStories
        tasks: getTasks
      }
      async.parallel tasks, (e, result)->
        return asyncCb(e, result)

    formatResults = ()->
      result = {
        project: {
          id: projectId
          name: projectName
        }
        sprint: {
          id: sprintId
          name: sprintName
          from: sprintFromDate
          to: sprintToDate
        }
        user_stories: []
      }
      for us in userStories
        temp = {
          subject: us.subject
          ref: us.ref
          us_id: us.id
          time_log: {}
        }
        
        usTasks = _.where tasks, {user_story: us.id}
        console.log 'usTasks', usTasks.length
        if usTasks?
          totalTimeObj = {}
          fullNames = {}
          for task in usTasks
            unless task['assigned_to_extra_info']?
              task['assigned_to_extra_info'] = {
                username: 'NotAssignedTask'
                full_name_display: 'Not Assigned Task'
              }

            username = task['assigned_to_extra_info']['username']
            unless totalTimeObj[username]?
              totalTimeObj[username] = 0
              fullNames[username] = task['assigned_to_extra_info']['full_name_display']
            timeTaken = task['time_log']
            timeTaken = timeTaken.split(':')
            totalTimeObj[username] += ((parseFloat(timeTaken[0]) * 60) + parseFloat(timeTaken[1]))

          for username, totalTime of totalTimeObj
            totalTimeInHrs = Math.floor(totalTime/60)
            totalTimeInMins = totalTime % 60
            temp['time_log'][username] = {
              'full_name': fullNames[username]
              'hh:mm': "#{totalTimeInHrs}:#{totalTimeInMins}"
              'in_hrs': (totalTime/60).toFixed(2)
              'in_mins': totalTime
            }
        result.user_stories.push temp

      return result

    async.waterfall [getProject, getMileStone, getUserStoriesAndTasks], (e)->
      return cb.apply @, [e] if e?

      result = formatResults()
      return cb.apply @, [null, result]
            
module.exports = SprintUSTasks