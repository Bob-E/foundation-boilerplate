toggleNavigation = ->
  button = $('#js-menu--button')
  button.click (event) ->
    $('.js-header--list').toggleClass('is-on-viewport','is-away')

$ ->
  toggleNavigation()
