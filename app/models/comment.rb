class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :user_id, :uniqueness => { scope: [:commentable_type, :commentable_id],
                                       message: " can't comment the same movie more than once" }
end
