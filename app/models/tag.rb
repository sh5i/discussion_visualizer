class Tag < ApplicationRecord
  belongs_to :user
  belongs_to :comment, inverse_of: :tags

  scope :autocomplete, ->(term) { where("content LIKE ?", "#{term}%").order(:content) }
end
