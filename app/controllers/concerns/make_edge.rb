require 'nokogiri'
require 'sanitize'
require 'tree_tagger'

module MakeEdge

  @@conjections = %w(after also although and as because before but considering directly expect for however if immediately lest like nor now notwithstanding once only or plus providing save since so than that though till unless until without yet)

  def create_edges(cmts, user)
    Edge.transaction do
      make_links_by_reply(cmts, user)
      make_links_by_quote(cmts, user)
      # TODO 補足関係のいい取得ほうが見つかったら実装する
      make_links_by_conjection(cmts, user)
      finalize_comments(cmts, user)
    end
     rescue => e
       return e
  end


  # 呼びかけ関係(ある人物の名前を含むかどうか)から呼びかけ先のコメントを取得するメソッド
  def make_links_by_reply(cmts, user)
    cmts.each do |cmt|
    xml_cmt = Nokogiri::HTML(cmt.content)
      xml_cmt.xpath('html/body/p/a').each do |elem|
        if elem.attribute("class").to_s == "user-hover"
          target = cmts.where("author = ? and id >= ? and id < ?", elem.attribute("rel").to_s, cmts.minimum(:id), cmt.id).last
          if !target.nil?
            @edge = Edge.new(user: user, comment: cmt, to_comment_id: target.id, type_text: :reply)
            @edge.save!
          end
        end
      end
    end
  end

  #引用関係
  def make_links_by_quote(cmts, user)
    cmts.each do |cmt|
      xml_cmt = Nokogiri::HTML(cmt.content)
      xml_cmt.xpath('html/body/blockquote').each do |elem|
        cmts.where("id < ?", cmt.id).each do |target|
          if Sanitize.clean(target.content).gsub(/\s\s/, " ").strip.include?(Sanitize.clean(elem.xpath('p').text).strip)
            @edge = Edge.new(user: user, comment: cmt, to_comment_id: target.id, type_text: :quote)
            @edge.save!
            break
          end
        end
      end
    end
  end

  def make_links_by_conjection(cmts, user)
    cmts.each do |cmt|
      #tagger = TreeTagger.new()
      #rst = tagger.analysis(Sanitize.clean(cmt.content).strip)
      first_word = Sanitize.clean(cmt.content).strip.split(" ")[0].downcase.delete(",")
      if cmt.content.start_with?("<p>") && !first_word.empty? && @@conjections.include?(first_word)
        target = cmts.where("id < ?", cmt.id).order("internal_id DESC").find_by("author = ?", cmt.author)
        if !target.nil?
          @edge = Edge.new(user: user, comment: cmt, to_comment_id: target.id, type_text: :conjection)
          @edge.save!
          break
        end
      end
    end
  end

  def finalize_comments(cmts, user)
    desc = cmts.find_by(type_text: :description)
    cmts.each do |cmt|
      if cmt.edge_count(user) == 0 && cmt.type_text != :description
        @edge = Edge.new(user: user, comment: cmt, to_comment_id: desc.id, type_text: :other)
        @edge.save!
      end
    end
  end

end
