console.error('window.swiftypeEngineKey required for Searcher') unless window.swiftypeEngineKey

class Searcher
  searchURL: 'https://api.swiftype.com/api/v1/public/engines/search.json'
  defaultSearchTerm: 'faq'
  constructor: (@$el) ->
    @title = @$el.find('.results-title')
    @defaultTitle = @title.text()
    @container = @$el.find('#search-results')
    @cache = {}
    return @

  searchFor: (searchTerm) ->
    return @renderSearchResults(searchTerm, @cache[searchTerm]) if @cache[searchTerm]

    $.ajax
      dataType: 'jsonp',
      url: @searchURL,
      data: { q: searchTerm, engine_key: window.swiftypeEngineKey, per_page: 6, page: 1 },
      success: (data) =>
        if data.record_count is 0
          @clear()
        else
          @cache[searchTerm] = data.records.page
          @renderSearchResults(searchTerm, data.records.page)

  renderSearchResults: (searchTerm, results) ->
    resultHTML = ''

    title = if searchTerm is 'faq' then @defaultTitle else "Articles similar to <em>#{searchTerm}</em>"
    @title.html(title)

    for result in results
      resultHTML = resultHTML + "<li><a href='#{result.url}'>#{result.title}</a></li>"
    @container.html resultHTML

  initialize: ->
    @searchFor @defaultSearchTerm

  clear: ->
    @searchFor @defaultSearchTerm

class SubjectLine
  constructor: (@$el, @searcher) ->
    $el.on 'blur', (e) =>
      @onBlur(e)

    @searcher.initialize()
    return @

  onBlur: (e) ->
    value = @getValue()
    if value
      @searcher.searchFor value
    else
      @searcher.clear()

  getValue: ->
    @$el.val().trim()

$(document).ready ->
  searcher = new Searcher $('#searcher')
  subjectLine = new SubjectLine $('#support-form-subject'), searcher
