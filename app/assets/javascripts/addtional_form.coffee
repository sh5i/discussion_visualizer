$ ->
  $(".additional-form").each (i, e)->
    $form = $(e)

    minLength = 1
    maxLength = 100

    activeItemLength = ()->
      $form.find(".additional-form-item").not(".hidden").length

    toggleAddButton = ()->
      $add = $form.find(".additional-form-add-button")
      $add.toggleClass("hidden", activeItemLength() >= maxLength )

    toggleAddButton()

    $form.find(".additional-form-del-button").click (e)->
      return if activeItemLength() <= minLength # 最後の一つの要素は消せない
      $item = $(e.currentTarget).parents(".additional-form-item:first")
      $item.find(".additional-form-target").val("1") # 未選択を選ぶ
      $item.addClass("hidden")
      toggleAddButton()

    $form.find(".additional-form-add-button").click (e)->
      $add = $(e.currentTarget)
      $template = $form.find(".additional-form-item").last().clone(true)
      # テンプレートを料理して新規フォームを作る
      $template.removeClass("hidden")
      $target = $template.find(".additional-form-target")
      $target.val("")
      name = $target.attr("name")
      # idのところをごにょごにょしてidを書き換え、新規フォーム扱いにする # TODO: ちょっと無理やり感あるかも
      name = name.replace(/\[([0-9]+)\](?=\[.+\]$)/,(a,b,c)->"[#{Number(b)+1}]")
      $target.attr("name", name)
      $add.before($template)
      $template.find(".additional-form-clear").val("").change()
      toggleAddButton()
