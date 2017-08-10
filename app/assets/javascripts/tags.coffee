
$ ->
  get_comment_from_server = () ->
    filter = $('input[name="filter_status"]:checked').val()
    # ラジオボタン選択時にサーバーと通信してtag検索を行う
    $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
    checked_arr = []
    $('input[name="tag"]:checked').each ->
        checked_arr.push($(this).val())
    path = "/comments/tags?"
    path += "filter="+filter+"&" 
    for tag in checked_arr
      path += "tag[]="+tag+"&"
    path = path.slice(0,-1)
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
      )

  is_checked = $('input[name="tag"]:checked').val()
  checked_arr = []
  $('input[name="tag"]:checked').each ->
      checked_arr.push($(this).val())
  #todo:解除時の挙動
  $(document).on 'click' ,'input[name="tag"]', ->
    if $(this).val() == is_checked
      # ラジオボタンを解除する
      $('input[name="tag"]').prop('checked', false)
      is_checked = 0
      # 解除時にグラフとコメントの表示を消す
      $("g.node.same-tag").each( -> $(this).removeClass("same-tag"))
      $(".comments_area .comment").each( -> $(this).show("fast"))
    else
      get_comment_from_server()

  $(document).on 'click' ,'input[name="filter_status"]', ->
    get_comment_from_server()
