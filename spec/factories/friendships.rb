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
FactoryBot.define do
  factory :friendship do
    first_friend  { user }
    second_friend { user }
  end
end
