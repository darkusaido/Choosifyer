Lists = share.Lists

Meteor.startup(() ->
    Meteor.methods(  
        insertList: (title) ->
            Lists.insert(
                title: title,
                createdAt: new Date(),
                createdBy: this.userId
            )
        getList: (id) -> 
            Lists.findOne({_id : id})
    )
)