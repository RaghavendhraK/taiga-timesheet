global.config = require 'config'

SprintUS = require './src/models/sprint_us'
async =  require 'async'

sprintUS = new SprintUS

userStories = {}
getUserStories = (slug, asyncCb)->
  sprintUS.getByProjectSlug slug, (e, us)->
    userStories[slug] = us
    return asyncCb(e)

slugs = config.get('projects')
async.eachLimit slugs, 2, getUserStories, (e)->
  console.log e, userStories