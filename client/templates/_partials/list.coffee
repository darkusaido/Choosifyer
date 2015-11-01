ListItems = new Mongo.Collection "listItems"

Template.list.helpers(
    items: () ->
        ListItems.find({}, {sort:{text:1}})
    anySelected: () ->
        items = ListItems.find({selected: true})
        array = []
        items.forEach((x, index) -> array[index] = x)
        array.length > 0
)

Template.list.events(
    "submit .new-item": (event) ->
        event.preventDefault()
        text = event.target.text.value                
        Meteor.call('insertItem', text)
        event.target.text.value = ""
    "click .clear": (event) ->
        event.preventDefault(); 
        Meteor.call('unselectAll', Meteor.userId())
    "click .choose": (event) ->
        event.preventDefault()
        Meteor.call('chooseItem', Meteor.userId())      
)