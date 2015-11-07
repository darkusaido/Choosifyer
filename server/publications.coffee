Lists = share.Lists
ListItems = share.ListItems

Meteor.publish("lists", () ->
    Lists.find({createdBy: this.userId})
)
Meteor.publish("list", (id) ->
    Lists.find({_id: id})
)
Meteor.publish("listItems", (listId) ->
    ListItems.find({listId: listId})
)