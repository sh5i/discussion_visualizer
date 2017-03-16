$ ->
  # グラフをクリックしたらハイライトしてポップアップを出す
  $(document).on 'click', 'svg g g.node', ->
    #$(".comment.active-click").removeClass("active-click")
    #$("g.node.active-click").removeClass("active-click")
    id = $(this).attr("id")
    #id = id.split("_")[1]

    # クラスのトグル
    toggle_class(id)

    # グラフに対応するコメントへスクロール
    scroll_to_comment(id)

  # コメントをクリックしたらハイライトする
  $('.comment').on 'click', ->
    id = $(this).attr("id").substr(8)
    toggle_class(id)

  # 更新後は更新したコメントへ移動
  $(window).load ->
    params = $(location).attr('search').split("?")
    if params[1]
      spparams = params[1].split("&")
      hash = {}
      for val in spparams
        hash[val.split("=")[0]] = val.split("=")[1]

      unless hash["cid"].nil?
        scroll_to_comment(hash["cid"])
        $(".comment#comment-#{hash["cid"]}").addClass("active-click")
        $("g##{hash["cid"]}").addClass("active-click")

  #SVGの拡大縮小
  $(document).on 'click', '#ZoomIn', ->
    Zoom(1.1)
  $(document).on 'click', '#ZoomOut', ->
    Zoom(10/11)

  #コメントの全件表示
  $(document).on 'click', '#ShowComments', ->
    $(".comments_area .comment").each( -> $(this).show("fast"))

  #ブックマークしたコメントの全件表示
  $(document).on 'click', '#ShowBookmarked', ->
    $(".comments_area .comment").each( -> $(this).hide("fast"))
    $(".bookmark.bookmarked").each( -> $(this).parent(".comment").show("fast"))

scroll_to_comment = (id) ->
  target = $(".comment#comment-#{id}").position().top
  sh     = $('.comments_area').scrollTop()
  s_pos  = $('.comments_area').position().top
  $('.comments_area').animate({scrollTop: target+sh-s_pos}, 500, 'swing')

toggle_class = (id) ->
  $comment = $(".comment#comment-#{id}")
  $node = $("g##{id}")
  $comment.show('fast')
  if $comment.hasClass("active-click")
    $node.removeClass("active-click")
    $comment.removeClass("active-click")
  else
    $('.comment').each( -> $(this).removeClass("active-click"))
    $("g.node").each( -> $(this).removeClass("active-click"))
    $node.addClass("active-click")
    $comment.addClass("active-click")

Zoom = (mag) ->
  polygon   = $("svg")
  w = parseInt(polygon.attr("width"))
  h = parseInt(polygon.attr("height"))
  polygon.attr("width",w*mag+"pt")
  polygon.attr("height",h*mag+"pt")
