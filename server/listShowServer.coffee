Lists = share.Lists
ListItems = share.ListItems

Meteor.startup(() ->    
    Meteor.methods(  
        unselectAll: (listId) ->
            items = ListItems.find({listId: listId}, {sort:{text:1}});

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
        chooseItem: (listId) ->
            items = ListItems.find({listId: listId}, {sort:{text:1}});
            arrayOfChoices = []
            items.forEach((x, index) -> arrayOfChoices[index] = x)

            min = arrayOfChoices.length * 2 ; max = arrayOfChoices.length * 4
            spinLength =  Math.random() * (max - min) + min
            prev = null
            timeToSleep = 1000/5 
            

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
        insertItem: (text, listId) ->
            ListItems.insert(
                text: text,
                checked: false,
                selected: false,
                createdAt: new Date(),
                beingEdited: false,
                listId: listId
            )       
    )
)