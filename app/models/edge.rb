class Edge < ApplicationRecord
  extend Enumerize
  has_paper_trail

  belongs_to :user
  belongs_to :comment
  belongs_to :to_comment, class_name: "Comment", foreign_key: "to_comment_id"

  enumerize :type_text, in: [:reply, :quote, :conjection, :other, :manual], default: :manual
end
