Router.configure(
	layoutTemplate: 'layout',
	notFoundTemplate: 'notFound',
	loadingTemplate: 'loading'	
)

Router.route('/', () ->
	this.render 'home'
)

Router.route('/user/:userName', () ->
	if Meteor.user() and Meteor.user().username is this.params.userName 
		this.subscribe('lists').wait()
		if this.ready()
			this.render 'listAll'
		else
			this.render 'loading'
	else 
		this.render 'notFound'
)

Router.route('/list/:listId',
	name: 'listShow'
	template: 'layout'
	data: () ->
		Meteor.call('getList', this.params.listId)
	subscriptions: () -> 
		listId = this.params.listId
		this.subscribe('list', listId).wait()
		this.subscribe('listItems', listId).wait()
	action: (() -> if this.ready() then this.render('listShow') else this.render('loading'))
)