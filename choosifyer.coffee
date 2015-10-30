Things = new Mongo.Collection('things')

if Meteor.isClient 
    Template.body.helpers(
        things: () ->
            Things.find({createdBy: Meteor.userId()}, {sort:{text:1}})
        anySelected: () ->
            things = Things.find({createdBy: Meteor.userId(), selected: true})
            array = []
            things.forEach((x, index) -> array[index] = x)
            array.length > 0
    )

    Template.body.events(
        "submit .new-thing": (event) ->
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

    Template.thing.events(
        "click .delete": () ->
            Meteor.call('deleteThing', this._id)
        'click .editButton': (e) ->
            Meteor.call('isBeingEdited', this._id)
        'submit .edit-thing': (e) ->
            e.preventDefault()
            Meteor.call('editThingText', this._id, e.target.text.value)
    )

    Accounts.ui.config(
        passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"
    )


if Meteor.isServer
    Meteor.startup(() ->

        selectNext = (array, index, timeOut, iterationsLeft, firstCall) ->
            if array == null
                throw('Argument [array] cannot be null')
            
            if iterationsLeft > 0
                if not firstCall
                    prevIndex =  if index is 0 then array.length - 1 else index - 1
                    prev = array[prevIndex]
                    Things.update(prev._id, {
                        $set: {selected: ! prev.selected}
                    })
                    array[prevIndex].selected = ! prev.selected
                

                curr = array[index]
                Things.update(curr._id, {
                    $set: {selected: ! curr.selected}
                })
                array[index].selected = ! curr.selected

                nextIndex = if index is array.length - 1  then 0 else index + 1
                boundFunc = Meteor.bindEnvironment(
                    (() -> selectNext(array, nextIndex, timeOut, --iterationsLeft, false)), 
                    ((error) -> throw error)
                )
                setTimeout(boundFunc, timeOut)
            else 0
        #code to run on server at startup
        Meteor.methods(
            unselectAll: (id) ->
                things = Things.find({createdBy: Meteor.userId()}, {sort:{text:1}});

                things.forEach((obj) -> 
                    Things.update(obj._id, 
                        $set: 
                            selected: false
                    )       
                )
            toggleSelect: (element) ->
                Things.update(element._id, 
                    $set: 
                        selected: !element.selected
                )
            deleteThing:  (id) ->
                Things.remove(id) 
            isBeingEdited:  (id) ->
                Things.update(id, 
                    $set: 
                        beingEdited: true
                )
            editThingText: (id, newText) ->
                Things.update(id, 
                    $set: 
                        text: newText
                        beingEdited: false
                ) 
            chooseItem: (userId) ->
                things = Things.find({createdBy: userId}, {sort:{text:1}});
                arrayOfVictims = []
                things.forEach((x, index) -> arrayOfVictims[index] = x)

                min = arrayOfVictims.length * 4 ; max = arrayOfVictims.length * 7
                spinLength =  Math.random() * (max - min) + min
                prev = null
                timeToSleep = 1000/30
                
                boundFunc = Meteor.bindEnvironment(
                    (() -> selectNext(arrayOfVictims, 0, timeToSleep, spinLength, true)), 
                    ((error) -> throw error)
                )
                setTimeout(boundFunc, 0)  
            insertItem: (text) ->
                Things.insert(
                    text: text,
                    checked: false,
                    selected: false,
                    createdAt: new Date(),
                    createdBy: Meteor.userId(),
                    beingEdited: false
                )
        )
    )

