URI = (url) ->
  l = document.createElement('a')
  l.href = url
  l

use_turbolinks = (url) ->
  uri = URI(url)
  typeof Turbolinks isnt 'undefined' && uri.host is document.location.host

visit_url = (url) ->
  if use_turbolinks(url)
    Turbolinks.visit url
  else
    document.location.href = url

$(document).ready ->
  $.fn.extend
    orgSelectDropdown: (options) ->
      this.each ->
        dropdown = $(this)

        dropdown.on 'click', (e) ->
          e.preventDefault()
          link = $(e.target)
          orgHref = link.data('org-href')
          returnHref = link.data('return-to')

          $.ajax
            url: link.attr('href')
            type: 'PUT'
            data: { organization_url: orgHref }
            xhrFields:
              withCredentials: true
            crossDomain: true
            success: ->
              visit_url returnHref

  $('.current-organization .dropdown-menu a.org-name').orgSelectDropdown()