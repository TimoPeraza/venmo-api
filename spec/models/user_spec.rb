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
require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build :user }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) } 
  end

  describe 'associations' do
    it { should have_many(:sent_friendships).class_name('Friendship') }
    it { should have_many(:received_friendships).class_name('Friendship') }
    it { should have_many(:sent_friends).through(:sent_friendships) }
    it { should have_many(:received_friends).through(:received_friendships) }
  end
end
