# == Schema Information
#
# Table name: feeds
#
#  id          :bigint           not null, primary key
#  payment_id  :bigint           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_feeds_on_payment_id  (payment_id)
#
require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { build :feed }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:payment) }
  end
end
