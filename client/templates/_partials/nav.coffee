Template.nav.events(
    "click .logout": (e) ->
        e.stopPropagation()
        Meteor.logout()
        $('.collapse').collapse('hide')
        Router.go('/')
    'click .login-link-text': (e) ->
        e.stopPropagation()
        dropdown = $('#login-dropdown-list')
        if dropdown.length > 0
            Accounts._loginButtonsSession.closeDropdown()
    'click .navbar-toggle': (e) ->
        e.stopPropagation()
        collapsible = $('.collapse')
        dropdown = $('#login-dropdown-list')
        if dropdown.length > 0
            Accounts._loginButtonsSession.closeDropdown()
            collapsible.collapse('toggle')
        else
            collapsible.collapse('toggle') 
)