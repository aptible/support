$(document).ready () =>
  buttons = $('.download-buttons a.category-box')
  panels = $('.download-panels .download-panel')

  buttons.each (index, button) =>
    button = $(button)
    button.on 'click', (e) =>
      return false if button.hasClass('active')

      targetAnchor = button.attr('href')
      window.location.hash = 'download-' + targetAnchor.replace('#', '')
      target = $(targetAnchor)

      console.log(targetAnchor, button, target)

      buttons.removeClass('active')
      panels.removeClass('active')

      button.addClass('active')
      target.addClass('active')

      e.preventDefault()

  # On page load, check if there is an existing hash in the URL.  If so, click
  # the associated button
  if /download\-/.test(window.location.hash)
    target = window.location.hash.replace('download-', '')
    targetButton = $('[href="'+target+'"]')

    targetButton.click()