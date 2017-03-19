$ ->
  $('.slides').lightSlider({ item: 1 })
  $('.day-widget').click ->
    $('.day-widget').addClass('is-inactive')
    $(this).removeClass('is-inactive')
    $('#forecast-details-section').removeClass('is-hidden')
    $('#forecast-details').html($(this).find('.forecast-details').html())
