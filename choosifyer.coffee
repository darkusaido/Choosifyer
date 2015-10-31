ListItems = new Mongo.Collection('listItems')

if Meteor.isClient 
    Meteor.subscribe("listItems")

    Template.body.helpers(
        items: () ->
            ListItems.find({}, {sort:{text:1}})
        anySelected: () ->
            items = ListItems.find({selected: true})
            array = []
            items.forEach((x, index) -> array[index] = x)
            array.length > 0
    )

    Template.body.events(
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
        "click .logout": (e) ->
            e.stopPropagation()
            Meteor.logout()
            $('.collapse').collapse('hide');
        'click .login-link-text': (e) ->
            e.stopPropagation()
            closeText = $('.login-close-text')
            if closeText.length > 0
                closeText[0].click()
        'click .navbar-toggle': (e) ->
            e.stopPropagation()
            closeText = $('.login-close-text')
            collapsible = $('.collapse')
            if closeText.length > 0
                closeText[0].click()
                checkExist = setInterval(() ->
                   if $('.login-close-text').length < 1 
                      console.log("Its gone now!")
                      clearInterval(checkExist)
                      collapsible.collapse('toggle')               
                , 100)
            else 
                collapsible.collapse('toggle')
        'submit .login-form': (e) ->
            $('.collapse').collapse('hide');        
    )

    Template.item.events(
        "click .delete": () ->
            Meteor.call('deleteItem', this._id)
        'click .editButton': (e) ->
            Meteor.call('isBeingEdited', this._id)
        'submit .edit-item': (e) ->
            e.preventDefault()
            Meteor.call('editItemText', this._id, e.target.text.value)
    )

    Accounts.ui.config(
        passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"
    )


if Meteor.isServer
    Meteor.publish("listItems", () ->
        ListItems.find({createdBy: this.userId})
    )

    Meteor.startup(() ->

        Meteor.methods(  
            unselectAll: (id) ->
                items = ListItems.find({createdBy: this.userId}, {sort:{text:1}});

                items.forEach((obj) -> 
                    ListItems.update(obj._id, 
                        $set: 
                            selected: false
                    )       
                )
            toggleSelect: (element) ->
                ListItems.update(element._id, 
                    $set: 
                        selected: !element.selected
                )
            deleteItem:  (id) ->
                ListItems.remove(id) 
            isBeingEdited:  (id) ->
                ListItems.update(id, 
                    $set: 
                        beingEdited: true
                )
            editItemText: (id, newText) ->
                ListItems.update(id, 
                    $set: 
                        text: newText
                        beingEdited: false
                ) 
            chooseItem: () ->
                items = ListItems.find({createdBy: this.userId}, {sort:{text:1}});
                arrayOfChoices = []
                items.forEach((x, index) -> arrayOfChoices[index] = x)

                min = arrayOfChoices.length * 4 ; max = arrayOfChoices.length * 7
                spinLength =  Math.random() * (max - min) + min
                prev = null
                timeToSleep = 1000/30 
                

                selectNext = (array, index, timeOut, iterationsLeft, firstCall) ->
                    if array == null
                        throw('Argument [array] cannot be null')
                    
                    if iterationsLeft > 0
                        if not firstCall
                            prevIndex =  if index is 0 then array.length - 1 else index - 1
                            prev = array[prevIndex]
                            ListItems.update(prev._id, {
                                $set: {selected: ! prev.selected}
                            })
                            array[prevIndex].selected = ! prev.selected
                        

                        curr = array[index]
                        ListItems.update(curr._id, {
                            $set: {selected: ! curr.selected}
                        })
                        array[index].selected = ! curr.selected

                        nextIndex = if index is array.length - 1  then 0 else index + 1
                        
                        Meteor.setTimeout(( () -> selectNext(array, nextIndex, timeOut, --iterationsLeft, false)), timeOut)
                    else 0
                selectNext(arrayOfChoices, 0, timeToSleep, spinLength, true)
                this.unblock()
            insertItem: (text) ->
                ListItems.insert(
                    text: text,
                    checked: false,
                    selected: false,
                    createdAt: new Date(),
                    createdBy: this.userId,
                    beingEdited: false
                )       
        )
    )

