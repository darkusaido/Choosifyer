Accounts.ui.config(
    passwordSignupFields: "USERNAME_AND_OPTIONAL_EMAIL"
)

Accounts.onLogin( () ->
	Router.go('/user/' + Meteor.user().username)
)