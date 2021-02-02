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
#  index_friendships_on_first_friend_id_and_second_friend_id  (first_friend_id,second_friend_id) UNIQUE
#  index_friendships_on_second_friend_id                      (second_friend_id)
#
require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'validations' do
    context '.friendship_uniqueness' do
      let!(:user_one) { create(:user) }
      let!(:user_two) { create(:user) }
      let!(:friendship) do
        create(:friendship, first_friend: user_one, second_friend: user_two)
      end

      subject { build(:friendship, first_friend: user_two, second_friend: user_one) }

      it 'returns an error message' do
        subject.valid?
        expect(subject.errors[:friendship]).to include(
          I18n.t('api.errors.models.friendships.uniqueness')
        )
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:first_friend).class_name('User') }
    it { should belong_to(:second_friend).class_name('User') }
  end
end
