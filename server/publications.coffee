Lists = share.Lists
ListItems = share.ListItems

Meteor.publish("lists", () ->
    Lists.find({createdBy: this.userId})
)
Meteor.publish("list", (id) ->
    Lists.find({createdBy: this.userId, _id: id})
)
Meteor.publish("listItems", (listId) ->
    ListItems.find({createdBy: this.userId, listId: listId})
)