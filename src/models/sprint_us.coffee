Projects = require '../lib/taiga/projects'
Milestones = require '../lib/taiga/milestones'
UserStories = require '../lib/taiga/user_stories'

class SprintUS

  getByProjectSlug: (projectSlug, cb)->
    projects = new Projects
    projects.getProjectsBySlug projectSlug, (e, project)->
      return cb.apply @, [e] if e?

      projectName = project.name
      projectId = project.id
      console.log 'Project', projectName, projectSlug, projectId

      milestones = new Milestones
      milestones.getByProjectId projectId, (e, milestones)->
        return cb.apply @, [e] if e?
        
        if milestones?.length > 1
          e = new Error 'More than one open sprints'
          return cb.apply @, [e]
        else if milestones?.length is 0
          e = new Error 'No open sprints'
          return cb.apply @, [e]

        sprint = milestones[0]
        sprintId = sprint.id
        sprintName = sprint.name
        console.log 'Sprint', sprintName, sprintId

        userStories = new UserStories
        userStories.getByMilestoneId sprintId, (e, userStories)->
          return cb.apply @, [e] if e?

          console.log 'Userstories', userStories.length
          sprintUSs = []
          for us in userStories
            sprintUSs.push {
              subject: us.subject
              ref: us.ref
              us_id: us.id
              sprint_name: sprintName
              sprint_id: sprintId
              project_name: projectName
              project_id: projectId
            }

          return cb.apply @, [null, sprintUSs]
            
module.exports = SprintUS