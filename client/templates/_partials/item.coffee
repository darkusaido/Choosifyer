Template.item.events(
    "click .delete": () ->
        Meteor.call('deleteItem', this._id)
    'click .editButton': (e) ->
        Meteor.call('isBeingEdited', this._id)
    'submit .edit-item': (e) ->
        e.preventDefault()
        Meteor.call('editItemText', this._id, e.target.text.value)
)