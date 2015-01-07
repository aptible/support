class App.Views.DocumentDownloadButton extends Backbone.View
  template: ->
    JST['dist/templates/download_button']

  initialize: ->
    @model.on 'change:s3_path', @render, @
    @model.on 'change:s3_path', @stop_listening, @
    @model.start_polling() unless @model.get('s3_path')

    @render()

  render: ->
    @$el.html(@template()(@render_params()))
    @

  render_params: ->
    { model: @model, download_url: @download_url() }

  download_url: ->
    @$el.data('download-url') || false

  stop_listening: ->
    @model.stop_polling() if @model.get('s3_path')
