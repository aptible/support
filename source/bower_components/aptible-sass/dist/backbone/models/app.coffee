class App.Models.App extends Backbone.Model
  urlRoot: ->
    if @isNew()
      "/accounts/#{@get('account_id')}/apps"
    else
      '/apps'