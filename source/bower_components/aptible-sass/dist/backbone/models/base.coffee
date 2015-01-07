Backbone.Model::initialize = ->
  @history = []
  _.bindAll @, 'save_state', 'close'
  @on 'change', @save_state
  $(document).on 'page:load', @close

Backbone.Model::close = ->
  $(document).off 'page:load', @close
  @stopListening()
  clearTimeout @timer if @timer?

Backbone.Model::save_state = ->
  @history?.push @.toJSON()

Backbone.View::close = ->
  @remove()
  @on_close() if @on_close?
