$(document).ready ->
  $('.btn').click ->
    # stash width
    width = $(this).find('i.form-icon').css( "width" )
    # toggle spinner on
    $(this).find('i.form-icon')
    .toggleClass('fa-spinner')
    .toggleClass('fa-spin')
    # unstash width
    $('i.form-icon').css(width: width)