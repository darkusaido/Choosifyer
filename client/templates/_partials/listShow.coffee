Lists = share.Lists
ListItems = share.ListItems
listId = ''

Template.listShow.helpers(
    items: () ->
        ListItems.find({}, {sort:{text:1}})
    anySelected: () ->
        items = ListItems.find({selected: true})
        array = []
        items.forEach((x, index) -> array[index] = x)
        array.length > 0
    list: () ->
        list = Lists.findOne()
        listId = list._id
        list
)

Template.listShow.events(
    "submit .new-item": (event) ->
        event.preventDefault()
        text = event.target.text.value                
        Meteor.call('insertItem', text, listId)
        event.target.text.value = ""
    "click .clear": (event) ->
        event.preventDefault(); 
        Meteor.call('unselectAll', listId)
    "click .choose": (event) ->
        event.preventDefault()
        Meteor.call('chooseItem', listId) 
    "click #other-lists-link": (event) ->
        #event.preventDefault() 
        #console.log("clicked on link")     
)