Router.configure(
	layoutTemplate: 'layout',
	notFoundTemplate: 'notFound',
	loadingTemplate: 'loading'	
)

Router.route('/', () ->
	this.render 'home'
)

Router.route('/:userName', () ->
	if Meteor.user() and Meteor.user().username is this.params.userName 
		this.subscribe('listItems').wait()
		if this.ready()
			this.render 'list'
		else
			this.render 'loading'
	else 
		this.render 'notFound'
)