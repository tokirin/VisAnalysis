$(document).ready ->
  $('.nav li').click(()->
    $(this).closest('ul').find('.active').removeClass('active')
    $(this).addClass('active')
  )