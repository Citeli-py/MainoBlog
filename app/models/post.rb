class Post < ApplicationRecord
  has_many :comments
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  def getAuthor
    User.find(user_id).name
  end

  def author?(current_user)
    user_id == current_user.id
  end

end
