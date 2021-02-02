# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  has_many :sent_friendships, class_name: 'Friendship', foreign_key: :first_friend_id,
                              inverse_of: :first_friend,
                              dependent: :destroy
  has_many :sent_friends, through: :sent_friendships, source: :second_friend

  has_many :received_friendships, class_name: 'Friendship', foreign_key: :second_friend_id,
                                  inverse_of: :second_friend,
                                  dependent: :destroy
  has_many :received_friends, through: :received_friendships, source: :first_friend

  validates :username, uniqueness: true
  validates :username, presence: true
end
