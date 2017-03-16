$ ->
  $(document).on 'click', 'svg g g.node', ->
    #popupの中身を取得するAPI
    jira_id = $(this).attr("id")
    path = "/comments/"+jira_id+"/association"
    if path
      $.ajax(
        method: 'POST'
        url: path
      ).done( (res) ->
        # if res.status is 'ok'
      ).fail( ( jqXHR, textStatus ) ->
        # TODO Error Handling
        #console.log( "Request failed: " + textStatus )
      )

    # グラフをクリックしたらポップアップを表示
    $('#popup_viewer').removeClass("hidden")
    $('#popup_viewer').css("left", $(this).position().left + 30)
    $('#popup_viewer').css("top", $(this).position().top + 15)

  $(document).on 'click', '#popup_viewer .popup .close-popup', (e) ->
    $('#popup_viewer').addClass("hidden")
    $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
    $(".active-click").each( -> $(this).removeClass("active-click"))

  # フォームをクリックした時に同じタグを持つものをハイライト
  $(document).on 'click', '#popup_viewer .popup input', ->
    $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
    tag = $(this).val()
    path = "/comments/tags?"+"tag="+tag
    if path
      $.ajax(
        method: 'GET'
        url: path
      ).done( (res) ->
        for comment in res["comments"]
          $("svg g g##{comment['jira_id']}").addClass("same-tag")
      ).fail( ( jqXHR, textStatus ) ->
        # TODO Error Handling
        #console.log( "Request failed: " + textStatus )
      )
