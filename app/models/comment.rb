class Comment < ApplicationRecord
  extend Enumerize

  belongs_to :issue
  has_many :edges
  has_many :comment_from_comments, class_name: "Edge", foreign_key: "to_comment_id"
  has_many :from_comments, through: :comment_from_comments
  has_many :comment_to_comments, class_name: "Edge", foreign_key: "comment_id"
  has_many :to_comments, through: :comment_to_comments
  has_many :tags, inverse_of: :comment
  has_many :bookmarks

  accepts_nested_attributes_for :tags, :allow_destroy => true
  accepts_nested_attributes_for :edges, :allow_destroy => true

  # コメント種別
  enumerize :type_text,  in: [:description, :other], default: :other,  predicates: true

  # nested_attributes用の処理
  def edges_attributes=(listed_attributes)
    listed_attributes.each do |index, attributes|
    edge = edges.detect{|i| i.id == attributes[:id].to_i } || edges.build
      if edge
        attributes[:type_text] = :manual if edge.to_comment_id != attributes[:to_comment_id].to_i
      else
        attributes[:type_text] = :manual
      end
      _destroy = attributes.delete("_destroy")=="false" ? false : true
      if _destroy
        edge.destroy
      else
        edge.assign_attributes(attributes)
      end
    end
  end

  def edge_count(user)
    if edges.loaded?
      edges.to_a.count{|e| e.user == user}
    else
      edges.where(user_id: user).count
    end
  end

  def bookmarked_by?(user)
    bookmarks.exists?(user_id: user.id)
  end

  def bookmarked(user)
    bookmarked_by?(user) ? 2 : 1
  end

  def get_svg_id
    type_text == :other ? self.jira_id.to_s : "description"
  end

  def set_tag(user)
    unless type_text == :description
      if AutoTagAuthor.exists?(author_name: self.author)
        #Tag.create!(user_id: user.id, comment_id: self.id, content: "patch")
        #auto_tag_authorテーブルにある場合その全てのタグを付ける
        AutoTagAuthor.where(author_name: self.author).each do |ata|
          Tag.create!(user_id: user.id, comment_id: self.id, content: ata.tag_content , auto_tag_author_id: ata.id)
        end
      else
        arr = self.content.to_s.split(/\s*(\.|\?|\;)\s*/)
        array = arr.each_slice(2).to_a
        array.each do |sentence|
          s = Sanitize.clean(sentence[0].to_s).strip.downcase
          if (s.start_with?("wh") || s.start_with?("how") )&& sentence[1] == "?"
            return Tag.create!(user_id: user.id, comment_id: self.id, content: "question")
          elsif sentence[0].include?("pre class=\"code-")
            return Tag.create!(user_id: user.id, comment_id: self.id, content: "code")
          # elsif !self.tfidf.empty?
          #   self.tfidf.each do |key,val|
          #     return self.label = :investigative if val > 0.3
          #   end
          end
        end
      end
    end
  end
#自動タグの更新。
  def set_auto_tag(user , autoTag)
    unless type_text == :description
      if !Tag.exists?(comment_id: self.id, content: autoTag.tag_content)
        Tag.create!(user_id: user.id, comment_id: self.id, content: autoTag.tag_content , auto_tag_author_id: autoTag.id)

      end
    end
  end

  def get_color
    # コメントラベルによって色をつける
    # patch -> ピンク
    # question -> 水色
    # code -> 灰色
    # investigative -> 黄色
    return 'none' if self.tags.empty?
    self.tags.each do |tag|
      if tag.content == "patch"
        return 'pink'
      elsif tag.content == "question"
        return 'paleturquoise'
      elsif tag.content == "code"
        return 'gray'
      elsif tag.content == "investigative"
        return 'lightgoldenrod'
      else
        return 'none'
      end
    end
  end

end
