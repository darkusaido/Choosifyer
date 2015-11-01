Template.loading.rendered = () ->
    unless Session.get('loadingSplash') 
        this.loading = window.pleaseWait(
            #logo: '/images/Meteor-logo.png'
            backgroundColor: '#7f8c8d'
            loadingHtml: message + spinner
        )
    Session.set('loadingSplash', true)

Template.loading.destroyed = () ->
    if this.loading 
        this.loading.finish()
  
message = '<p class="loading-message">Loading Message</p>'
spinner = '<div class="sk-spinner sk-spinner-rotating-plane"></div>'