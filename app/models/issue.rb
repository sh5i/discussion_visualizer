class Issue < ApplicationRecord
  validates_uniqueness_of :url
  belongs_to :project
  has_many :comments
  has_many :edges, through: :comments
  has_many :tags, through: :comments
  has_many :users, through: :edges

  scope :belongs_user, -> user {
    joins(:comments).joins(:edges).where('edges.user_id = ?', user).uniq(:id)
  }

  def escape_title
    title.gsub("\"","\\\"")
  end

end
