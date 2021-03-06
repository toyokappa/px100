class Album < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  default_scope -> {order(created_at: :desc)}

  validates :user_id, presence: true
  validates :album_name, presence: true, length: { maximum: 30 }
  validate :cover_picture_size
  # ユーザー内でアルバム名を一意に
  validates :album_name,
            uniqueness: { scope: :user_id, case_sensitive: false },
            format: { with: /\A[A-Za-z][\w-]*\z/ },
            length: { minimum: 3, maximum: 25 },
            ban_reserved: true

  mount_uploader :cover_picture, PictureUploader

  private

  # アップロードされた画像のサイズをバリデーションする
  def cover_picture_size
    if cover_picture.size > 3.megabytes
      errors.add(:cover_picture, "should be less than 5MB")
    end
  end
end
