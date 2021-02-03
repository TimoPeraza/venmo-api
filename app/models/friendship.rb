# == Schema Information
#
# Table name: friendships
#
#  id               :bigint           not null, primary key
#  first_friend_id  :bigint           not null
#  second_friend_id :bigint           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_friendships_on_first_friend_id                       (first_friend_id)
#  index_friendships_on_first_friend_id_and_second_friend_id  (first_friend_id,
#                                                              second_friend_id) UNIQUE
#  index_friendships_on_second_friend_id                      (second_friend_id)
#
class Friendship < ApplicationRecord
  belongs_to :first_friend, class_name: 'User'
  belongs_to :second_friend, class_name: 'User'

  validate :friendship_uniqueness, on: %i[create update]

  def self.exists_friendship(user, friend)
    where(first_friend: user, second_friend: friend)
      .or(Friendship.where(first_friend: friend, second_friend: user)).exists?
  end

  private

  def friendship_uniqueness
    return unless Friendship.exists_friendship(first_friend, second_friend)

    errors.add(:friendship, I18n.t('api.errors.models.friendships.uniqueness'))
  end
end
