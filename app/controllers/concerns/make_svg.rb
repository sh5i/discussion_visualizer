module MakeSVG

  def create_svg(issue, user)
    cmts = issue.comments.order(:internal_id)

    file_name = issue.id.to_s.intern
    gv = Gviz.new(file_name)

    gv.graph do
      global layout:'dot', label: issue.escape_title, rankdir: "BT", splines: true
      #node cmts.find_by(type_text: :description).internal_id.to_s.intern, shape:'box', label: "#0", fontsize: 12, fixedsize: true, width: 0.5, height: 0.25, id: 'hogehoge'
      cmts.each do |cmt|
        node cmt.internal_id.to_s.intern, shape:'box', label: "##{cmt.internal_id}\n#{cmt.author}", fontsize: 12, id: "#{cmt.get_svg_id}", peripheries: cmt.bookmarked(user), style: "solid,filled", fillcolor:cmt.get_color
        cmt.edges.each do |edge|
          route edge.comment.internal_id.to_s.intern => edge.to_comment.internal_id.to_s.intern

          # edge属性の変更
          if edge.type_text == :reply
            # 呼びかけ関係
            edge("#{edge.comment.internal_id}_#{edge.to_comment.internal_id}".intern, arrowhead: 'vee')
          elsif edge.type_text == :quote
            # 引用関係
            edge("#{edge.comment.internal_id}_#{edge.to_comment.internal_id}".intern, arrowhead: 'box', style: 'bold')
          elsif edge.type_text == :conjection
            # 並列関係
            edge("#{edge.comment.internal_id}_#{edge.to_comment.internal_id}".intern, arrowhead: 'diamond', style: 'bold')
          elsif edge.type_text == :manual
            # 手動生成
            edge("#{edge.comment.internal_id}_#{edge.to_comment.internal_id}".intern, arrowhead: 'vee', style: 'bold', color: 'darkgray')
          else
            edge("#{edge.comment.internal_id}_#{edge.to_comment.internal_id}".intern, arrowhead: 'vee', style: 'dashed')
          end
        end
      end
    end

    gv.save(file_name, :svg)
  end
end
