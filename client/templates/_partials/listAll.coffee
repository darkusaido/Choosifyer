Lists = share.Lists

Template.listAll.helpers(
    lists: () ->
        Lists.find({}, {sort:{title:1}})
)

Template.listAll.events(
    "submit .new-list": (event) ->
        event.preventDefault()
        title = event.target.title.value                
        Meteor.call('insertList', title)
        event.target.title.value = ""     
)