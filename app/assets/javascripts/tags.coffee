$ ->
  is_checked = $('input[name="tag"]:checked').val()
  $(document).on 'click' ,'input[name="tag"]', ->
    if $(this).val() == is_checked
      # ラジオボタンを解除する
      $('input[name="tag"]').prop('checked', false)
      is_checked = 0
      # 解除時にグラフとコメントの表示を消す
      $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
      $(".comments_area .comment").each( -> $(this).show("fast"))
    else
      is_checked = $(this).val()

      # ラジオボタン選択時にサーバーと通信してtag検索を行う
      $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
      tag = $(this).val()
      path = "/comments/tags?"+"tag="+tag
      if path
        $.ajax(
          method: 'GET'
          url: path
        ).done( (res) ->
          $(".comments_area .comment").each( -> $(this).hide("fast"))
          for comment in res["comments"]
            $("svg g g##{comment['jira_id']}").addClass("same-tag")
            $(".comments_area .comment##{'comment-' + comment['jira_id']}").show("fast")
        ).fail( ( jqXHR, textStatus ) ->
          # TODO Error Handling
          # console.log( "Request failed: " + textStatus)
        )
