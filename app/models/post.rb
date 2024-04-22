class Post < ApplicationRecord
  has_many :comments
  belongs_to :user

  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  after_save :associate_tags
  before_destroy  :destroy_tags

  def getAuthor
    User.find(user_id).name
  end

  def author?(current_user)
    user_id == current_user.id
  end

  private

  def associate_tags
    # Expressão regular para encontrar todas as tags no corpo do post
    tags = body.scan(/#\w+/)

    tags.each do |tag_name|
      tag = Tag.find_or_create_by(name: tag_name)
      # Associe a tag ao post
      PostTag.find_or_create_by(post_id: id, tag_id: tag.id)
    end
  end

  def destroy_tags
    self.tags.destroy_all
    self.comments.destroy_all
    # Depois essa query pade ser feita no sidekiq
    Tag.left_outer_joins(:post_tags).where(post_tags: { id: nil }).destroy_all
  end

end
