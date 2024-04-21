class Comment < ApplicationRecord
  belongs_to :post


  validates :body, presence: true

  def getAuthor
    if user_id.nil?
        return nil
    end

    User.find(user_id).name
  end

  def author?(current_user)
    user_id == current_user.id
  end

end
