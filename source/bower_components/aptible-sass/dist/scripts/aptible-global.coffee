window.AptibleSassScripts =
  initialize: ->
    AptibleSassScripts.adjustContentHeight()
    AptibleSassScripts.fetchStatusPage()

  adjustContentHeight: ->
    sibling_height = 0;
    wrapper = $('#main-yield-wrapper')
    siblings = wrapper.siblings().filter (index, el)->
      $(el).prop('tagName') isnt 'SCRIPT'

    siblings.each () ->
      sibling_height += $(this).outerHeight(true)

    wrapper.css 'min-height', $(window).height() - sibling_height

  fetchStatusPage: ->
    status_icon = $('#status-circle, .current-status-indicator')
    status_link = $('#status-link, .current-status-link')

    window.fetchStatusPage
      pageId: "fmwgqnbnbc4r"
      successCallback: (data) ->
        # add a tooltip with the current status description
        status_link.tooltip
          placement: "bottom"
          title: data.status.description

        # ... and turn the light on
        switch data.status.indicator
          when "none"
            status_icon.addClass("green")
          when "minor"
            status_icon.addClass("yellow")
          when "major", "critical"
            status_icon.addClass("red")
          else
            return # TODO: throw an error and log if the switch falls through

$(document).on('page:change', AptibleSassScripts.initialize)
$(window).resize AptibleSassScripts.adjustContentHeight
