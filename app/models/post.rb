class Post < ApplicationRecord
  has_many :comments
  belongs_to :user

  has_many :post_tags
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true
  validates :user_id, presence: true

  after_save :associate_tags

  def getAuthor
    User.find(user_id).name
  end

  def author?(current_user)
    user_id == current_user.id
  end

  private

  def associate_tags
    # Use uma expressão regular para encontrar todas as tags no corpo do post
    tags = body.scan(/#\w+/)

    tags.each do |tag_name|
      # Encontre a tag existente ou crie uma nova se não existir
      tag = Tag.find_or_create_by(name: tag_name)

      # Associe a tag ao post
      PostTag.create(post_id: id, tag_id: tag.id)
    end
  end

end
