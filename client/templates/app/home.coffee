Template.home.events(
    "click #home-signin": (e) ->
    	console.log 'clicked home signin button'
    	collapsible = $('.collapse')
    	expanded = $(collapsible).attr('aria-expanded')
    	dropdown = $('#login-dropdown-list')
    	if expanded is "true"
	        if dropdown.length > 0
	            Accounts._loginButtonsSession.closeDropdown()
	        else
	            $('.login-link-text').click()
        else
        	collapsible.collapse('toggle')
        	$('.login-link-text').click()
)