global.config = require 'config'
async =  require 'async'

projects = config.get('projects')

SprintUS = require './src/models/sprint_us'
sprintUS = new SprintUS

userStories = {}
getSprintUserStories = (project, asyncCb)->
  slug = project['taiga_slug']
  sprintUS.getByProjectSlug slug, (e, us)->
    return asyncCb(e) if e?
    userStories[slug] = us
    return asyncCb()

async.eachLimit projects, 2, getSprintUserStories, (e)->
  console.log e, userStories, userStories['raghavendhrak-daily-sales']['user_stories']?[0]