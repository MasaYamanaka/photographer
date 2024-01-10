class Article < ApplicationRecord
  include Visible

  has_many :comments, dependent: :destroy
  # has_one_attached :image, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  validates :images, content_type: {in:[:png, :jpg, :jpeg], message: "is not png, jpg,or jpeg"},
  size: { between: 1.kilobyte..20.megabytes , message: 'must be less than 4MB in size' }

  def image_as_thumbnail
    return unless image.content_type.in?(%w[image/jpeg image/jpg image/png])
    image.variant(resize_to_limit: [800, 400]).processed
  end
end
