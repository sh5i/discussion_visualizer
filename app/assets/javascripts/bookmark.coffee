$ ->
  $(document).on 'click', '.bookmark', ->
    $(this).toggleClass('bookmarked')
    if $(this).data().path
      $.ajax(
        method: 'POST'
        url: $(this).data().path
      ).done( (res) ->
        # if res.status is 'ok'
      ).fail( ( jqXHR, textStatus ) ->
        # TODO Error Handling
        #console.log( "Request failed: " + textStatus )
      )
