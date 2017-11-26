# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string
#  commentable_id   :integer
#  user_id          :integer
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  delegate :name, to: :user, prefix: true

  validates :body, :commentable_type, :commentable_id, :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:commentable_type, :commentable_id],
                                    message: " can't comment the same movie more than once" }
end
