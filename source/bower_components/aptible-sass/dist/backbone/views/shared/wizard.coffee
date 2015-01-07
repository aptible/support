class App.Views.Wizard extends Backbone.View
  template: ->
    JST['dist/templates/wizard']

  events:
    'click .ensure-configure-manually': 'on_ensure_configure_manually'
    'click .confirm-configure-manually': 'on_configure_manually'
    'click .nav li a': 'on_tab_click'

  tab_container_class: '.tab-content'
  default_binds: ['render', 'add_step_view', 'on_next', 'on_cancel', 'on_open', 'on_previous', 'on_save_success', 'close', 'resize']
  bind_to: []
  current_index: 0

  initialize: ->
    bindings = _.union(@default_binds, @bind_to)
    _.each bindings, (binding) =>
      _.bindAll @, binding

    @config = @initialize_config()
    @steps = @initialize_steps()

    _.each @steps, (step, index) =>
      step.index = index

    @render()
    @tabs = @$('.nav li')
    #@load_first_step()

    $(window).on('resize', @resize).resize()

  resize: ->
    height = $(window).height() - 200
    @$('.tab-content .tab-pane').css({ maxHeight: height })

  initialize_config: ->
    {}

  initialize_steps: ->
    []

  render: ->
    $(@el).html(@template()(@render_params()))
    @container = @$(@tab_container_class)

    _.each @steps, @add_step_view

    @

  render_params: ->
    steps: @steps

  load_first_step: ->
    @go_to_step @current_index

  add_step_view: (step, index) ->
    @container.append step.render().$el
    step.$el.data('index', index)

  go_to_step: (step_index) ->
    if @steps[step_index]
      @tabs.removeClass('disabled')
      @tabs.eq(step_index).find('a').tab('show')
      @tabs.eq(step_index).nextAll().addClass('disabled')

      @steps[step_index].on_enter()

  ################

  index: (index)->
    @current_index = index
    @tabs.eq(@current_index).find('a').tab('show')
    @steps[@current_index].on_enter()

    @on_update_index()

  on_update_index: ->
    previous = 'Previous'
    previous = 'Cancel' if @current_index is 0

    next = 'Save and continue'
    next = 'Finish' if @current_index is (@steps.length - 1)

    @config.set previous_button: previous, next_button: next

  on_show_tab: (e) ->
    tab = $(e.target)
    return tab.removeClass('disabled').tab('show') if tab.hasClass('disabled')

  on_next: ->
    return false unless @steps[@current_index].validate()
    return @on_complete() if @current_index is (@steps.length - 1)
    @index(@current_index + 1)

  on_previous: ->
    return @$('.modal').modal('hide') if @current_index is 0
    @index(@current_index - 1)

  on_cancel: ->
    return if @completed
    previous = @model.history[0]
    @model.set(previous).trigger('reset')

  on_open: ->
    @index(0)

  on_complete: ->
    @model.save(@model.attributes, { success: @on_save_success })

  on_save_success: ->
    @$('.modal').modal('hide')
    document.location.href = document.location.href

  update_previous_button: (config, value) ->
    @$('.cancel-button-text').text(value)

  update_next_button: (config, value)->
    @$('.next-button-text').text(value)

  on_tab_click: (e) ->
    tab_index = $(e.target).data('index')
    @index(tab_index)

  on_close: ->
    $(document).off 'page:change', @close
    $(window).off 'resize', @resize
    _.each @steps, @close_child_view

  close_child_view: (view)->
    view.close()
